require 'sinatra'
require 'sqlite3'
require 'date'
require 'json'
require 'fileutils'
require 'securerandom'

set :bind, '0.0.0.0'
set :port, ENV.fetch('PORT', 4567)

set :host_authorization, {
  permitted_hosts: ['.onrender.com', 'localhost', '127.0.0.1'],
  allow_if: ->(env) { env['PATH_INFO'] == '/salud' }
}

set :database, 'data/inventario.db'

# Conexión a la base de datos.
def db
  FileUtils.mkdir_p(File.dirname(settings.database))

  SQLite3::Database.new(settings.database).tap do |database|
    database.results_as_hash = true
    database.execute('PRAGMA foreign_keys = ON')
  end
end

# Prepara las tablas y adapta la base de datos si ya existía.
def preparar_base_datos
  database = db

  database.execute <<-SQL
    CREATE TABLE IF NOT EXISTS recepciones (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      fecha_recepcion TEXT NOT NULL,
      responsable TEXT NOT NULL,
      created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
  SQL

  database.execute <<-SQL
    CREATE TABLE IF NOT EXISTS lotes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      recepcion_id INTEGER,
      alimento TEXT NOT NULL,
      cantidad REAL NOT NULL CHECK (cantidad > 0),
      cantidad_disponible REAL NOT NULL DEFAULT 0
        CHECK (cantidad_disponible >= 0),
      unidad TEXT NOT NULL,
      fecha_recepcion TEXT NOT NULL,
      fecha_vencimiento TEXT,
      responsable TEXT NOT NULL,
      estado TEXT NOT NULL DEFAULT 'Pendiente_de_revision',
      bloqueado INTEGER NOT NULL DEFAULT 0,
      motivo_estado TEXT,
      FOREIGN KEY (recepcion_id) REFERENCES recepciones(id)
    )
  SQL

  # Agrega recepcion_id a instalaciones anteriores de la aplicación.
  columnas = database.execute('PRAGMA table_info(lotes)')
  unless columnas.any? { |columna| columna['name'] == 'recepcion_id' }
    database.execute('ALTER TABLE lotes ADD COLUMN recepcion_id INTEGER')
  end

  columnas = database.execute('PRAGMA table_info(lotes)')

  unless columnas.any? { |columna| columna['name'] == 'cantidad_disponible' }
    database.execute(
      <<-SQL,
        ALTER TABLE lotes
        ADD COLUMN cantidad_disponible REAL NOT NULL DEFAULT 0
        CHECK (cantidad_disponible >= 0)
      SQL
    )

    database.execute(
      <<-SQL,
        UPDATE lotes
        SET cantidad_disponible = CASE
          WHEN estado = 'Disponible'
            AND bloqueado = 0
            AND (
              fecha_vencimiento IS NULL
              OR fecha_vencimiento = ''
              OR fecha_vencimiento > ?
            )
          THEN cantidad
          ELSE 0
        END
      SQL
      [Date.today.iso8601]
    )
  end

    database.execute <<-SQL
    CREATE TABLE IF NOT EXISTS familias (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      codigo TEXT NOT NULL UNIQUE,
      integrantes INTEGER NOT NULL CHECK (integrantes > 0),
      activa INTEGER NOT NULL DEFAULT 1,
      created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
  SQL

  # Agrega apellidos a familias existentes sin perder sus registros.
  columnas_familias = database.execute('PRAGMA table_info(familias)')

  unless columnas_familias.any? { |columna| columna['name'] == 'apellidos' }
    database.execute(
      "ALTER TABLE familias ADD COLUMN apellidos TEXT NOT NULL DEFAULT ''"
    )
  end

  database.execute <<-SQL
    CREATE TABLE IF NOT EXISTS entregas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      codigo_operacion TEXT NOT NULL UNIQUE,
      familia_id INTEGER NOT NULL,
      fecha_entrega TEXT NOT NULL,
      responsable TEXT NOT NULL,
      created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (familia_id) REFERENCES familias(id)
    )
  SQL

  database.execute <<-SQL
    CREATE TABLE IF NOT EXISTS detalle_entregas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      entrega_id INTEGER NOT NULL,
      lote_id INTEGER NOT NULL,
      cantidad REAL NOT NULL CHECK (cantidad > 0),
      FOREIGN KEY (entrega_id) REFERENCES entregas(id),
      FOREIGN KEY (lote_id) REFERENCES lotes(id),
      UNIQUE (entrega_id, lote_id)
    )
  SQL

  database.close
end

preparar_base_datos

helpers do
  def fecha_valida?(valor)
    Date.iso8601(valor)
    true
  rescue Date::Error, TypeError
    false
  end

  def actualizar_lotes_vencidos(database)
    database.execute(
      <<-SQL,
        UPDATE lotes
        SET estado = 'Vencido'
        WHERE fecha_vencimiento IS NOT NULL
          AND fecha_vencimiento <> ''
          AND fecha_vencimiento <= ?
          AND estado <> 'Vencido'
      SQL
      [Date.today.iso8601]
    )
  end
end

get '/' do
  redirect '/inventario'
end

# Consulta el inventario, actualiza vencimientos y prepara los datos
# necesarios para mostrar stock, lotes y alertas.
get '/inventario' do
  database = db

  actualizar_lotes_vencidos(database)

  @lotes = database.execute(
    <<-SQL
      SELECT *
      FROM lotes
      ORDER BY
        alimento COLLATE NOCASE ASC,
        CASE WHEN estado = 'Disponible' THEN 0 ELSE 1 END ASC,
        CASE
          WHEN fecha_vencimiento IS NULL OR fecha_vencimiento = '' THEN 1
          ELSE 0
        END ASC,
        fecha_vencimiento ASC,
        fecha_recepcion ASC
    SQL
  )

  @lotes_por_alimento = @lotes.group_by { |lote| lote['alimento'] }

  # El stock se calcula solo con lotes disponibles y no bloqueados.
  @stock_por_alimento = database.execute(
    <<-SQL
      SELECT
        alimento,
        unidad,
        SUM(cantidad_disponible) AS cantidad_disponible
      FROM lotes
      WHERE estado = 'Disponible'
        AND bloqueado = 0
      GROUP BY alimento, unidad
      ORDER BY alimento COLLATE NOCASE ASC
    SQL
  )

  @alertas = @lotes.select do |lote|
    vencimiento = lote['fecha_vencimiento'].to_s

    !vencimiento.empty? &&
      fecha_valida?(vencimiento) &&
      Date.iso8601(vencimiento) >= Date.today &&
      Date.iso8601(vencimiento) <= Date.today + 14
  end.sort_by do |lote|
    Date.iso8601(lote['fecha_vencimiento'])
  end

  @total_lotes = @lotes.length
  @pendientes_revision = @lotes.count do |lote|
    lote['estado'] == 'Pendiente_de_revision'
  end

  database.close
  erb :inventario
ensure
  database&.close
end

# Registra una recepción que puede contener varios alimentos.
# Cada alimento genera un lote independiente.
post '/recepciones' do
  fecha_recepcion = params[:fecha_recepcion].to_s.strip
  responsable = params[:responsable].to_s.strip

  unless fecha_valida?(fecha_recepcion)
    halt 422, 'Ingresa una fecha de recepción válida.'
  end

  if responsable.empty?
    halt 422, 'Ingresa el nombre de la persona responsable.'
  end

  alimentos = Array(params[:alimento])
  cantidades = Array(params[:cantidad])
  unidades = Array(params[:unidad])
  vencimientos = Array(params[:fecha_vencimiento])

  items = alimentos.each_index.map do |indice|
    {
      alimento: alimentos[indice].to_s.strip,
      cantidad: cantidades[indice].to_s.strip,
      unidad: unidades[indice].to_s.strip,
      fecha_vencimiento: vencimientos[indice].to_s.strip
    }
  end

  # Omite filas completamente vacías del formulario.
  items.reject! do |item|
    item[:alimento].empty? &&
      item[:cantidad].empty? &&
      item[:unidad].empty? &&
      item[:fecha_vencimiento].empty?
  end

  if items.empty?
    halt 422, 'Agrega al menos un alimento a la recepción.'
  end

  items.each do |item|
    if item[:alimento].empty? ||
       item[:cantidad].empty? ||
       item[:unidad].empty?
      halt 422, 'Completa el alimento, la cantidad y la unidad de cada fila.'
    end

    begin
      cantidad = Float(item[:cantidad])
    rescue ArgumentError, TypeError
      halt 422, 'Una de las cantidades ingresadas no es válida.'
    end

    unless cantidad.finite? && cantidad > 0
      halt 422, 'Las cantidades deben ser mayores que cero.'
    end

    unless item[:fecha_vencimiento].empty?
      unless fecha_valida?(item[:fecha_vencimiento])
        halt 422, 'Una de las fechas de vencimiento no es válida.'
      end

      if Date.iso8601(item[:fecha_vencimiento]) < Date.iso8601(fecha_recepcion)
        halt 422, 'La fecha de vencimiento no puede ser anterior a la recepción.'
      end
    end
  end

  database = db

  begin
    database.transaction do
      database.execute(
        'INSERT INTO recepciones (fecha_recepcion, responsable) VALUES (?, ?)',
        [fecha_recepcion, responsable]
      )

      recepcion_id = database.last_insert_row_id

      items.each do |item|
        database.execute(
          <<-SQL,
            INSERT INTO lotes (
              recepcion_id,
              alimento,
              cantidad,
              cantidad_disponible,
              unidad,
              fecha_recepcion,
              fecha_vencimiento,
              responsable,
              estado
            )
            VALUES (?, ?, ?, 0, ?, ?, ?, ?, 'Pendiente_de_revision')
          SQL
          [
            recepcion_id,
            item[:alimento],
            Float(item[:cantidad]),
            item[:unidad],
            fecha_recepcion,
            item[:fecha_vencimiento].empty? ? nil : item[:fecha_vencimiento],
            responsable
          ]
        )
      end
    end
  ensure
    database.close
  end

  redirect '/inventario'
end

# Permite revisar un lote pendiente y marcarlo como disponible o no apto.
post '/lotes/:id/revision' do
  nuevo_estado = params[:estado].to_s

  unless ['Disponible', 'No_apto'].include?(nuevo_estado)
    halt 422, 'El estado seleccionado no es válido.'
  end

  if nuevo_estado == 'No_apto' && params[:motivo].to_s.strip.empty?
    halt 422, 'Debes indicar el motivo para marcar el lote como no apto.'
  end  

  database = db

  begin
    lote = database.get_first_row(
      'SELECT * FROM lotes WHERE id = ?',
      [params[:id].to_i]
    )

    halt 404, 'No se encontró el lote solicitado.' unless lote

    unless lote['estado'] == 'Pendiente_de_revision'
      halt 409, 'Este lote ya fue revisado.'
    end

    if nuevo_estado == 'Disponible' &&
       !lote['fecha_vencimiento'].to_s.empty? &&
       Date.iso8601(lote['fecha_vencimiento']) <= Date.today
      database.execute(
        "UPDATE lotes SET estado = 'Vencido' WHERE id = ?",
        [lote['id']]
      )
      halt 422, 'El lote está vencido y no puede marcarse como disponible.'
    end

    database.execute(
      'UPDATE lotes SET estado = ?, motivo_estado = ?, cantidad_disponible = ? WHERE id = ?',
      [
        nuevo_estado,
        nuevo_estado == 'No_apto' ? params[:motivo].to_s.strip : nil,
        nuevo_estado == 'Disponible' ? lote['cantidad'] : 0,
        lote['id']
      ]
    )
  ensure
    database.close
  end

  redirect '/inventario'
end

# Muestra las familias beneficiarias registradas.
get '/familias' do
  database = db

  begin
    @familias = database.execute(
      <<-SQL
        SELECT id, codigo, apellidos, integrantes, created_at
        FROM familias
        WHERE activa = 1
        ORDER BY codigo COLLATE NOCASE ASC
      SQL
    )
  ensure
    database.close
  end

  erb :familias
end

# Registra una familia y genera su código automáticamente.
post '/familias' do
  apellidos = params[:apellidos].to_s.strip
  integrantes_texto = params[:integrantes].to_s.strip

  if apellidos.empty?
    halt 422, 'Ingresa los apellidos de la familia.'
  end

  begin
    integrantes = Integer(integrantes_texto)
  rescue ArgumentError, TypeError
    halt 422, 'Ingresa un número válido de integrantes.'
  end

  unless integrantes > 0
    halt 422, 'La cantidad de integrantes debe ser mayor que cero.'
  end

  database = db

  begin
    database.transaction do
      # Código temporal único para poder insertar el registro.
      codigo_temporal = "PEND-#{SecureRandom.hex(12)}"

      database.execute(
        'INSERT INTO familias (codigo, apellidos, integrantes) VALUES (?, ?, ?)',
        [codigo_temporal, apellidos, integrantes]
      )

      familia_id = database.last_insert_row_id
      codigo_final = format('FAM-%04d', familia_id)

      database.execute(
        'UPDATE familias SET codigo = ? WHERE id = ?',
        [codigo_final, familia_id]
      )
    end

    redirect '/familias'

  ensure
    database.close
  end
end

get '/entregas' do
  database = db

  begin
    actualizar_lotes_vencidos(database)

    @familias = database.execute(
      <<-SQL
        SELECT id, codigo, apellidos, integrantes
        FROM familias
        WHERE activa = 1
        ORDER BY codigo COLLATE NOCASE ASC
      SQL
    )

    @stock = database.execute(
      <<-SQL,
        SELECT
          alimento,
          unidad,
          SUM(cantidad_disponible) AS cantidad_disponible
        FROM lotes
        WHERE estado = 'Disponible'
          AND bloqueado = 0
          AND cantidad_disponible > 0
          AND (
            fecha_vencimiento IS NULL
            OR fecha_vencimiento = ''
            OR fecha_vencimiento > ?
          )
        GROUP BY alimento, unidad
        ORDER BY alimento COLLATE NOCASE ASC
      SQL
      [Date.today.iso8601]
    )

    @entregas = database.execute(
      <<-SQL
        SELECT
          e.id,
          e.fecha_entrega,
          e.responsable,
          f.codigo,
          f.apellidos
        FROM entregas e
        INNER JOIN familias f ON f.id = e.familia_id
        ORDER BY e.fecha_entrega DESC, e.id DESC
        LIMIT 50
      SQL
    )

    @detalles_entregas = database.execute(
      <<-SQL
        SELECT
          de.entrega_id,
          l.alimento,
          l.unidad,
          SUM(de.cantidad) AS cantidad
        FROM detalle_entregas de
        INNER JOIN lotes l ON l.id = de.lote_id
        GROUP BY de.entrega_id, l.alimento, l.unidad
        ORDER BY l.alimento COLLATE NOCASE ASC
      SQL
    )

  ensure
    database.close
  end

  @mensaje = 'Entrega registrada correctamente.' if params[:ok] == '1'
  erb :entregas
end

post '/entregas' do
  familia_id = params[:familia_id].to_s.strip
  fecha_entrega = params[:fecha_entrega].to_s
  responsable = params[:responsable].to_s.strip

  if familia_id.empty? || responsable.empty?
    halt 422, 'Completa los campos obligatorios.'
  end

  begin
    familia_id = Integer(familia_id)
  rescue ArgumentError, TypeError
    halt 422, 'Selecciona una familia válida.'
  end

  unless fecha_valida?(fecha_entrega)
    halt 422, 'Ingresa una fecha de entrega válida.'
  end

  productos = Array(params[:producto])
  cantidades = Array(params[:cantidad])

  if productos.length != cantidades.length
    halt 422, 'Revisa los alimentos y sus cantidades.'
  end

  items = []

  productos.zip(cantidades).each do |producto, cantidad_texto|
    producto = producto.to_s.strip
    cantidad_texto = cantidad_texto.to_s.strip

    next if producto.empty? && cantidad_texto.empty?

    if producto.empty? || cantidad_texto.empty?
      halt 422, 'Completa el alimento y la cantidad de cada fila.'
    end

    begin
      cantidad = Float(cantidad_texto)
    rescue ArgumentError, TypeError
      halt 422, 'Ingresa cantidades válidas.'
    end

    unless cantidad.finite? && cantidad > 0
      halt 422, 'Las cantidades deben ser mayores que cero.'
    end

    alimento, unidad = producto.split('|||', 2)

    if alimento.to_s.empty? || unidad.to_s.empty?
      halt 422, 'Selecciona un alimento válido.'
    end

    items << {
      alimento: alimento,
      unidad: unidad,
      cantidad: cantidad
    }
  end

  if items.empty?
    halt 422, 'Agrega al menos un alimento a la entrega.'
  end

  # Agrupa filas repetidas del mismo alimento y unidad.
  items = items.group_by { |item| [item[:alimento], item[:unidad]] }
               .map do |clave, filas|
    {
      alimento: clave[0],
      unidad: clave[1],
      cantidad: filas.sum { |fila| fila[:cantidad] }
    }
  end

  database = db

  begin
    actualizar_lotes_vencidos(database)

    begin
      database.transaction do
        familia = database.get_first_row(
          'SELECT id FROM familias WHERE id = ? AND activa = 1',
          [familia_id]
        )

        raise RuntimeError, 'La familia seleccionada no existe.' unless familia

        # Primero verifica que exista stock suficiente para TODOS los alimentos.
        asignaciones = items.map do |item|
          lotes = database.execute(
            <<-SQL,
              SELECT id, cantidad_disponible
              FROM lotes
              WHERE alimento = ?
                AND unidad = ?
                AND estado = 'Disponible'
                AND bloqueado = 0
                AND cantidad_disponible > 0
                AND (
                  fecha_vencimiento IS NULL
                  OR fecha_vencimiento = ''
                  OR fecha_vencimiento > ?
                )
              ORDER BY
                CASE
                  WHEN fecha_vencimiento IS NULL OR fecha_vencimiento = ''
                  THEN 1 ELSE 0
                END,
                fecha_vencimiento ASC,
                fecha_recepcion ASC,
                id ASC
            SQL
            [item[:alimento], item[:unidad], Date.today.iso8601]
          )

          stock_total = lotes.sum do |lote|
            lote['cantidad_disponible'].to_f
          end

          if stock_total < item[:cantidad]
            raise RuntimeError,
              "Stock insuficiente de #{item[:alimento]}. Disponible: #{stock_total} #{item[:unidad]}."
          end

          { item: item, lotes: lotes }
        end

        # Registra una sola entrega para todos los alimentos.
        database.execute(
          <<-SQL,
            INSERT INTO entregas
              (codigo_operacion, familia_id, fecha_entrega, responsable)
            VALUES (?, ?, ?, ?)
          SQL
          [SecureRandom.uuid, familia_id, fecha_entrega, responsable]
        )

        entrega_id = database.last_insert_row_id

        # Descuenta cada alimento siguiendo el orden FEFO.
        asignaciones.each do |asignacion|
          restante = asignacion[:item][:cantidad]

          asignacion[:lotes].each do |lote|
            break if restante <= 0.000001

            disponible = lote['cantidad_disponible'].to_f
            descontar = [restante, disponible].min

            database.execute(
              <<-SQL,
                UPDATE lotes
                SET cantidad_disponible = cantidad_disponible - ?
                WHERE id = ?
                  AND cantidad_disponible >= ?
              SQL
              [descontar, lote['id'], descontar]
            )

            unless database.changes == 1
              raise RuntimeError, 'No se pudo actualizar el inventario.'
            end

            database.execute(
              'INSERT INTO detalle_entregas (entrega_id, lote_id, cantidad) VALUES (?, ?, ?)',
              [entrega_id, lote['id'], descontar]
            )

            restante -= descontar
          end

          if restante > 0.000001
            raise RuntimeError, 'No fue posible completar el descuento del inventario.'
          end
        end
      end

    rescue RuntimeError => error
      @error = error.message

      @familias = database.execute(
        'SELECT id, codigo, apellidos, integrantes FROM familias WHERE activa = 1 ORDER BY codigo COLLATE NOCASE ASC'
      )

      @stock = database.execute(
        <<-SQL,
          SELECT alimento, unidad,
                 SUM(cantidad_disponible) AS cantidad_disponible
          FROM lotes
          WHERE estado = 'Disponible'
            AND bloqueado = 0
            AND cantidad_disponible > 0
            AND (
              fecha_vencimiento IS NULL
              OR fecha_vencimiento = ''
              OR fecha_vencimiento > ?
            )
          GROUP BY alimento, unidad
          ORDER BY alimento COLLATE NOCASE ASC
        SQL
        [Date.today.iso8601]
      )

      status 422
      erb :entregas
    else
      redirect '/entregas?ok=1'
    end

  ensure
    database.close
  end
end

# Comprobación básica del funcionamiento de la aplicación.
get '/salud' do
  content_type :json
  {
    estado: 'correcto',
    aplicacion: 'Banco de Alimentos Comunitario'
  }.to_json
end