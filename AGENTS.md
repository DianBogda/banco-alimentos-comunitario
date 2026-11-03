# AGENTS.md — Banco de Alimentos Comunitario

## 1. Propósito del proyecto

Construir una aplicación sencilla y accesible para apoyar la gestión de un banco de alimentos comunitario.

La aplicación busca facilitar el registro de donaciones, el control de inventario, la identificación de alimentos próximos a vencer y el registro de entregas a familias beneficiarias.

El objetivo es reducir pérdidas de alimentos, mejorar la organización y favorecer una distribución justa y transparente.

## 2. Usuarios y roles

**Coordinador (Jorge)**

- Supervisa el funcionamiento general.
- Define criterios comunitarios de distribución.
- Revisa los registros y autoriza excepciones justificadas.
- Consulta el inventario y el seguimiento de las familias.

**Voluntarios**

- Registran donaciones y entregas.
- Clasifican alimentos siguiendo los criterios establecidos.
- Actualizan información del inventario.
- Registran alimentos dañados, vencidos o no aptos.
- Consultan las instrucciones y guías de trabajo.

La aplicación debe facilitar el trabajo autónomo de voluntarios, sin depender de la presencia permanente del coordinador.

## 3. Principios de diseño

- Priorizar una primera versión de bajo costo, utilizando herramientas gratuitas cuando sea posible.
- Diseñar una interfaz adaptable a teléfonos y computadores.
- Utilizar lenguaje sencillo, botones visibles y formularios fáciles de completar.
- Considerar que algunos voluntarios tienen poca experiencia con herramientas digitales.
- Evitar funciones innecesarias que compliquen el uso.
- Mantener la información organizada y fácil de consultar.

## 4. Reglas generales del negocio

### Inventario y donaciones

- Cada donación debe quedar registrada con alimento, cantidad, unidad, fecha de recepción y fecha de vencimiento, cuando corresponda.
- Los lotes de un mismo alimento deben mantenerse identificados por separado.
- El inventario debe actualizarse cuando ingresen donaciones, se realicen entregas o se registren mermas.
- No se deben registrar entregas por cantidades superiores al stock disponible.

### Vencimientos y distribución

- Aplicar el criterio FEFO (First Expired, First Out): priorizar la salida de los alimentos que vencen primero.
- Identificar alimentos próximos a vencer, idealmente con alertas a 14 y 7 días.
- La distribución debe considerar las necesidades del hogar y el tiempo de espera, según criterios definidos por el coordinador.

### Estado de los alimentos

- Disponible: alimento apto para distribución.
- Pendiente de revisión: alimento cuya condición debe verificarse antes de utilizarlo.
- No apto o merma: alimento que no puede distribuirse para consumo humano.

Los alimentos con dudas sobre su inocuidad deben permanecer separados hasta su revisión. Ningún alimento no apto para consumo humano puede entregarse a las familias. Una autorización administrativa nunca puede reemplazar los criterios de seguridad alimentaria.

### Entregas y trazabilidad

- Cada entrega debe quedar registrada e identificada con la familia beneficiaria.
- El historial debe permitir consultar las entregas anteriores.
- Se debe evitar la duplicación accidental de registros.
- Las modificaciones relevantes deben poder rastrearse.

### Capacitación de voluntarios

- La guía de clasificación de alimentos debe estar disponible permanentemente.
- Los nuevos voluntarios deben confirmar que revisaron la guía antes de registrar donaciones.
- El sistema debe conservar el registro de quién realizó la confirmación y cuándo.

## 5. Instrucciones para el agente de IA

Antes de realizar cualquier tarea:

1. Leer estas instrucciones y la documentación relacionada con la funcionalidad solicitada.
2. Comprender el problema que se busca resolver.
3. Respetar las reglas del negocio y las decisiones previamente acordadas.
4. No inventar requisitos, datos reales, criterios de distribución ni funcionalidades.
5. Si existen contradicciones o información insuficiente, consultar antes de implementar.
6. Priorizar soluciones simples, mantenibles y de bajo costo.
7. No agregar funcionalidades fuera del alcance solicitado sin autorización.
8. Verificar los criterios de aceptación antes de considerar terminada una funcionalidad.

Si una implementación no cumple los criterios de aceptación, identificar el problema y proponer los ajustes necesarios en la especificación antes de continuar con nuevas instrucciones de implementación.

## 6. Privacidad y datos

- Utilizar exclusivamente datos ficticios durante el desarrollo y las demostraciones.
- No incorporar información personal real de familias o beneficiarios.
- No conectar servicios externos ni contratar herramientas pagadas sin autorización.
- No afirmar que existe almacenamiento permanente, seguridad o respaldo si esas capacidades no están implementadas y verificadas.

## 7. Idioma y documentación

- La interfaz de usuario debe estar en español.
- Los mensajes, etiquetas y explicaciones deben utilizar lenguaje claro y sencillo.
- La documentación del proyecto debe mantenerse en español, salvo que una herramienta requiera términos técnicos en inglés.

## 8. Criterio general de éxito

La aplicación debe ayudar a los voluntarios a registrar y organizar alimentos y entregas de manera sencilla, reducir errores y facilitar la supervisión del coordinador, manteniendo la seguridad alimentaria y la trazabilidad de la información.

## 9. Tecnologías y entorno de desarrollo

La implementación del proyecto utilizará las siguientes tecnologías:

- **Ruby:** lenguaje principal para desarrollar la lógica de negocio y las validaciones del sistema.
- **Sinatra:** framework web ligero para construir la aplicación.
- **SQLite:** base de datos local para almacenar alimentos, lotes y movimientos.
- **Docker:** herramienta para configurar y ejecutar la aplicación en un entorno reproducible.
- **HTML, CSS y JavaScript:** tecnologías para construir la interfaz de usuario.

### Instrucciones técnicas

- Mantener una arquitectura sencilla, adecuada para un prototipo funcional.
- Ejecutar la aplicación mediante Docker.
- Garantizar la persistencia de los datos entre reinicios del contenedor, siempre que esta funcionalidad esté implementada y verificada.
- Implementar las reglas de negocio y validaciones críticas en el backend.
- No incorporar tecnologías o servicios externos adicionales sin justificación y autorización.
- Mantener coherencia con el documento `design.md` y la skill de identidad visual.

### Alcance de implementación

Las reglas y funcionalidades descritas en este documento representan el contexto general del proyecto. La implementación de cada entrega debe limitarse al feature definido en su correspondiente especificación (`requirements.md`), sin asumir que todas las funcionalidades del proyecto deben estar desarrolladas.