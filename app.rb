require 'sinatra'
require 'sqlite3'
require 'date'
require 'json'
require 'fileutils'

set :bind, '0.0.0.0'
set :port, 4567
set :database, 'data/inventario.db'

# Conexión a la base de datos.
def db
  FileUtils.mkdir_p(File.dirname(settings.database))

  SQLite3::Database.new(settings.database).tap do |database|
    database.results_as_hash = true
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
        SUM(cantidad) AS cantidad_disponible
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
              unidad,
              fecha_recepcion,
              fecha_vencimiento,
              responsable,
              estado
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, 'Pendiente_de_revision')
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
      'UPDATE lotes SET estado = ?, motivo_estado = ? WHERE id = ?',
      [
        nuevo_estado,
        nuevo_estado == 'No_apto' ? params[:motivo].to_s.strip : nil,
        lote['id']
      ]
    )
  ensure
    database.close
  end

  redirect '/inventario'
end

# Comprobación básica del funcionamiento de la aplicación.
get '/salud' do
  content_type :json
  {
    estado: 'correcto',
    aplicacion: 'Banco de Alimentos Comunitario'
  }.to_json
end