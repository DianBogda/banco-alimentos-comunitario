# Banco de Alimentos Comunitario

Sistema web para apoyar la gestión de inventario de un banco de alimentos comunitario, facilitando el registro, revisión y seguimiento de donaciones mediante el control de lotes y la priorización de alimentos según su fecha de vencimiento.

## Contexto del proyecto

Este proyecto nace de la necesidad de apoyar a organizaciones comunitarias que reciben donaciones de alimentos de manera variable y necesitan administrar sus existencias, evitar pérdidas por vencimiento y mejorar el control de los productos disponibles.

La propuesta busca ofrecer una herramienta sencilla que facilite el trabajo de las personas voluntarias y contribuya a una gestión más ordenada del inventario.

## Funcionalidad principal

El feature desarrollado es el **Control de Inventario por Lotes y Priorización FEFO** (*First Expired, First Out*).

Sus funcionalidades principales son:

- **Registro de donaciones:** permite registrar los alimentos recibidos y sus respectivos datos, incluyendo cantidad, unidad, fecha de recepción y fecha de vencimiento.
- **Identificación de lotes:** cada alimento registrado genera un lote con un identificador único.
- **Revisión de alimentos:** permite aprobar o rechazar los lotes recibidos, registrando el motivo cuando un alimento no es apto.
- **Consulta de inventario:** muestra los alimentos agrupados y permite consultar el detalle de sus lotes y cantidades disponibles.
- **Priorización FEFO:** organiza los lotes según su fecha de vencimiento, priorizando aquellos que deben utilizarse primero.
- **Alertas de vencimiento:** identifica alimentos próximos a vencer y distingue las alertas preventivas de las prioritarias.
- **Control de vencimientos:** los alimentos vencidos quedan excluidos del inventario disponible.

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
│       └── inventario-lotes-fefo/
│           ├── requirements.md
│           ├── design.md
│           └── .config.kiro
├── data/
├── public/
│   └── style.css
├── views/
│   └── inventario.erb
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

El desarrollo de este feature se realizó utilizando el enfoque **Spec Driven Development (SDD)**, partiendo de la definición del problema y construyendo una especificación que orientó la implementación.

El proyecto incluye:

- `AGENTS.md`: contexto e instrucciones generales para el agente.
- `.kiro/specs/inventario-lotes-fefo/requirements.md`: definición del problema, solución propuesta y criterios de aceptación.
- `.kiro/specs/inventario-lotes-fefo/design.md`: diseño técnico de la solución.
- `.kiro/skills/identidad-visual-banco-alimentos/SKILL.md`: instrucciones para mantener la identidad visual de la aplicación.

## Alcance y consideraciones

Esta versión corresponde a un prototipo académico enfocado en el control de inventario por lotes, revisión de alimentos, priorización FEFO y alertas de vencimiento.

No contempla todavía la gestión completa de familias beneficiarias, registro de entregas ni distribución de canastas.

Los datos utilizados para las pruebas y demostraciones son ficticios. La versión desplegada es demostrativa y no debe utilizarse para gestionar información real de beneficiarios o donantes.

## Demo

Enlace de demostración: *Pendiente de confirmar publicación.*

## Repositorio

[GitHub – Banco de Alimentos Comunitario](https://github.com/DianBogda/banco-alimentos-comunitario)

---

**Proyecto desarrollado como parte del curso Fundamentos de Product Engineering con IA – Código Facilito.**