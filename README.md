# Banco de Alimentos Comunitario

Sistema web para apoyar la gestión de un banco de alimentos comunitario, facilitando el registro y control de donaciones, la administración de inventario por lotes, la gestión de familias beneficiarias y el seguimiento de entregas.

## Contexto del proyecto

Este proyecto nace de la necesidad de apoyar a organizaciones comunitarias que reciben donaciones de alimentos de manera variable y necesitan administrar sus existencias, evitar pérdidas por vencimiento y mejorar la distribución de los recursos disponibles.

La propuesta busca ofrecer una herramienta sencilla y accesible que facilite el trabajo de las personas voluntarias y contribuya a una gestión más ordenada, transparente y equitativa.

## Funcionalidades principales

La aplicación contempla tres áreas principales:

### 1. Control de inventario por lotes y priorización FEFO

(*First Expired, First Out*)

- **Registro de donaciones:** permite registrar alimentos recibidos, cantidades, unidades y fechas de recepción y vencimiento.
- **Identificación de lotes:** cada registro genera un lote con identificador único.
- **Revisión de alimentos:** permite aprobar o rechazar los lotes recibidos, registrando el motivo cuando un alimento no es apto.
- **Consulta de inventario:** muestra los alimentos y permite consultar el detalle de sus lotes y cantidades disponibles.
- **Priorización FEFO:** organiza los lotes según su fecha de vencimiento, priorizando aquellos que deben utilizarse primero.
- **Alertas de vencimiento:** identifica alimentos próximos a vencer y distingue alertas preventivas y prioritarias.
- **Control de vencimientos:** los alimentos vencidos quedan excluidos del inventario disponible.

### 2. Gestión de familias beneficiarias

- Registro y consulta de familias.
- Administración de integrantes y estado de las familias.
- Consulta de la última entrega registrada.
- Acceso al historial de entregas de cada familia.

### 3. Registro y seguimiento de entregas

- Registro de alimentos y cantidades entregadas a cada familia.
- Consulta de disponibilidad de inventario.
- Validación de existencias antes de registrar una entrega.
- Actualización del inventario a partir de las entregas registradas.
- Seguimiento de las entregas realizadas.

## Tecnologías utilizadas

- Ruby
- Sinatra
- SQLite
- HTML y ERB
- CSS
- JavaScript
- Docker y Docker Compose
- Git y GitHub

## Estructura del proyecto

```text
banco-alimentos-comunitario/
├── .kiro/
│   ├── skills/
│   │   └── identidad-visual-banco-alimentos/
│   │       └── SKILL.md
│   └── specs/
│       ├── inventario-lotes-fefo/
│       │   ├── requirements.md
│       │   ├── design.md
│       │   ├── tasks.md
│       │   └── .config.kiro
│       └── familias-entregas/
│           ├── requirements.md
│           ├── design.md
│           └── tasks.md
├── data/
├── public/
│   └── style.css
├── views/
│   ├── inventario.erb
│   ├── familias.erb
│   └── entregas.erb
├── AGENTS.md
├── app.rb
├── Dockerfile
├── compose.yaml
├── Gemfile
└── README.md
```

## Cómo ejecutar el proyecto

### Requisitos previos

- Docker instalado.
- Docker Compose disponible.

### Ejecución

1. Clonar el repositorio:

```bash
git clone https://github.com/DianBogda/banco-alimentos-comunitario.git
```

2. Ingresar a la carpeta:

```bash
cd banco-alimentos-comunitario
```

3. Construir e iniciar la aplicación:

```bash
docker compose up --build
```

4. Abrir la aplicación en el navegador:

```text
http://localhost:4567
```

Para detener la aplicación:

```bash
docker compose down
```

## Spec Driven Development

El desarrollo del proyecto utiliza el enfoque **Spec Driven Development (SDD)**, partiendo de la definición de necesidades y criterios de aceptación para orientar el diseño y la implementación de funcionalidades.

El proyecto incluye:

- `AGENTS.md`: contexto e instrucciones generales para el agente.
- `.kiro/specs/inventario-lotes-fefo/requirements.md`: requisitos y criterios de aceptación del control de inventario.
- `.kiro/specs/inventario-lotes-fefo/design.md`: diseño técnico de la gestión de inventario por lotes.
- `.kiro/specs/familias-entregas/requirements.md`: requisitos de gestión de familias y registro de entregas.
- `.kiro/specs/familias-entregas/design.md`: diseño técnico de las funcionalidades.
- `.kiro/specs/familias-entregas/tasks.md`: tareas definidas para orientar su implementación.
- `.kiro/skills/identidad-visual-banco-alimentos/SKILL.md`: instrucciones para mantener la identidad visual de la aplicación.

## Alcance y consideraciones

La aplicación integra funcionalidades de inventario, gestión de familias beneficiarias y registro de entregas. Su desarrollo y validación se realizan de manera progresiva.

Los datos utilizados para las pruebas y demostraciones son ficticios. La versión desplegada es demostrativa y no debe utilizarse para gestionar información real de beneficiarios o donantes.

**Almacenamiento en la demo:** La aplicación utiliza SQLite para almacenar los registros. En el despliegue gratuito de Render no se ha configurado un disco persistente, por lo que los datos de prueba pueden perderse cuando la instancia se reinicia o se vuelve a desplegar. Por esta razón, la demo debe utilizarse exclusivamente con información ficticia.

## Demo en línea

La aplicación está desplegada en Render y puede probarse desde el siguiente enlace:

[**Banco de Alimentos Comunitario – Abrir aplicación**](https://banco-alimentos-comunitario.onrender.com/inventario)

**Nota:** La instancia gratuita de Render puede tardar unos segundos en responder después de un período de inactividad.

## Repositorio

[GitHub – Banco de Alimentos Comunitario](https://github.com/DianBogda/banco-alimentos-comunitario)

---

**Proyecto desarrollado como parte del curso Fundamentos de Product Engineering con IA – Código Facilito.**