# Tasks: Control de Inventario por Lotes y Priorización FEFO

> **Nota sobre este documento:** Este archivo fue reconstruido retrospectivamente después de la implementación del feature, con fines de documentación y aprendizaje. No formó parte de la entrega original de la primera SPEC.
>
> La reconstrucción se realizó a partir de los requisitos, el diseño y la revisión del código de la primera implementación. Algunos archivos utilizados como evidencia corresponden a copias locales conservadas durante el desarrollo y no necesariamente forman parte del repositorio GitHub.
>
> Los estados de las tareas distinguen entre funcionalidades implementadas, pruebas manuales realizadas y verificaciones adicionales pendientes.

## Estados de avance

- **Implementado:** existe evidencia de que la funcionalidad está desarrollada en el código revisado.
- **Verificado:** se realizó una prueba manual y se comprobó el comportamiento indicado.
- **Pendiente de verificación:** falta confirmar el comportamiento mediante una prueba específica.
- **Mejora futura:** funcionalidad identificada posteriormente, fuera del alcance de esta SPEC.

---

## 1. Preparación de la base de datos y modelo de lotes

**Objetivo:** preparar la estructura de datos para registrar recepciones y lotes individuales de alimentos.

- [x] 1.1. Crear la tabla `recepciones` con identificador, fecha de recepción, responsable y fecha de creación.
- [x] 1.2. Crear la tabla `lotes` con identificador, recepción asociada, alimento, cantidad, unidad, fechas, responsable y estado.
- [x] 1.3. Establecer la relación entre recepciones y lotes mediante `recepcion_id`.
- [x] 1.4. Definir el estado inicial de los lotes como `Pendiente_de_revision`.
- [x] 1.5. Incorporar restricciones para evitar cantidades iguales o inferiores a cero.
- [x] 1.6. Incorporar una migración para agregar `recepcion_id` cuando la tabla de lotes ya existe.
- [ ] 1.7. Verificar que los registros se mantengan después de reiniciar la aplicación y Docker.
- [ ] 1.8. Verificar que los identificadores de los lotes sean únicos incluso cuando se registran varias recepciones.

**Estado:** estructura de base de datos implementada. La persistencia después de reinicios y la unicidad mediante pruebas adicionales quedan pendientes de verificación.

**Evidencia:** revisión local de `app_tarea_2.rb`, sección de preparación de base de datos.

---

## 2. Registro de donaciones y generación de lotes

**Objetivo:** permitir registrar una recepción que contenga diferentes tipos de alimentos, generando un lote independiente para cada uno.

- [x] 2.1. Crear el formulario de recepción con fecha y responsable.
- [x] 2.2. Permitir agregar diferentes alimentos dentro de una misma recepción.
- [x] 2.3. Permitir indicar alimento, cantidad, unidad y fecha de vencimiento opcional.
- [x] 2.4. Validar que el alimento no esté vacío.
- [x] 2.5. Validar que la cantidad sea numérica y mayor que cero.
- [x] 2.6. Validar que se haya seleccionado una unidad.
- [x] 2.7. Validar el formato de las fechas.
- [x] 2.8. Evitar fechas de vencimiento anteriores a la fecha de recepción.
- [x] 2.9. Generar un lote independiente por cada alimento registrado.
- [x] 2.10. Asociar los lotes generados a una misma recepción.
- [x] 2.11. Registrar los lotes inicialmente como pendientes de revisión.
- [x] 2.12. Utilizar una transacción para registrar la recepción y sus lotes de manera conjunta.
- [x] 2.13. Permitir agregar y quitar filas de alimentos dinámicamente en el formulario.
- [x] 2.14. Comprobar mediante pruebas el registro de varios alimentos en una misma recepción.
- [x] 2.15. Comprobar que sea posible quitar un alimento del formulario antes de registrar la recepción.
- [ ] 2.16. Verificar que un error durante el registro no deje una recepción incompleta o lotes parciales.
- [ ] 2.17. Probar el envío de cantidades inválidas, campos obligatorios vacíos y fechas incorrectas.
- [ ] 2.18. Verificar el comportamiento cuando se intenta registrar una recepción sin alimentos.

**Estado:** implementación realizada y pruebas manuales de registro y eliminación de filas realizadas. Las pruebas de errores, validaciones específicas y atomicidad de las transacciones quedan pendientes de verificación.

**Evidencia:** revisión local de `app_tarea_2.rb` y `views/inventario_tarea_2.erb`.

---

## 3. Revisión y validación de lotes

**Objetivo:** permitir revisar las condiciones de los alimentos recibidos antes de incorporarlos al inventario disponible.

- [x] 3.1. Mostrar los lotes pendientes de revisión en la pantalla de inventario.
- [x] 3.2. Permitir aprobar un lote y cambiar su estado a `Disponible`.
- [x] 3.3. Permitir rechazar un lote y cambiar su estado a `No_apto`.
- [x] 3.4. Solicitar un motivo obligatorio cuando un lote se marca como no apto.
- [x] 3.5. Comprobar el cambio de estado de lotes aptos y no aptos.
- [x] 3.6. Evitar que un lote vencido sea aprobado como disponible.
- [x] 3.7. Excluir del cálculo de stock los lotes pendientes y no aptos.
- [ ] 3.8. Verificar que los cambios de estado se reflejen correctamente en todas las consultas y resúmenes del inventario.
- [ ] 3.9. Verificar que un lote que ya fue revisado no pueda modificarse mediante una solicitud no autorizada.
- [ ] 3.10. Verificar que los lotes no aptos y vencidos no puedan utilizarse en futuras entregas.

**Estado:** implementación realizada y pruebas manuales de aprobación, rechazo y obligatoriedad del motivo realizadas. Las verificaciones adicionales de seguridad, consistencia y uso posterior quedan pendientes.

**Evidencia:** revisión local de las rutas de revisión de lotes en `app_tarea_2.rb` y las acciones de revisión en `views/inventario_tarea_2.erb`.

---

## 4. Inventario, cantidades y priorización FEFO

**Objetivo:** organizar los alimentos por tipo, calcular el stock disponible y priorizar los lotes según su fecha de vencimiento.

- [x] 4.1. Agrupar los lotes por tipo de alimento.
- [x] 4.2. Mostrar la cantidad total disponible por alimento y su unidad.
- [x] 4.3. Mostrar el detalle individual de los lotes registrados.
- [x] 4.4. Diferenciar visualmente los estados de los lotes.
- [x] 4.5. Incorporar el ordenamiento de lotes por alimento y fecha de vencimiento.
- [x] 4.6. Ubicar los lotes sin fecha de vencimiento después de los que sí tienen fecha.
- [x] 4.7. Comprobar el ordenamiento de los lotes y la ubicación al final de los no aptos y vencidos.
- [x] 4.8. Calcular el stock disponible considerando los lotes aprobados, con cantidad positiva y no bloqueados.
- [x] 4.9. Comprobar que las cantidades de los lotes se sumaran correctamente.
- [x] 4.10. Comprobar que las tarjetas de resumen mostraran correctamente la información.
- [ ] 4.11. Verificar específicamente que la priorización FEFO se aplique únicamente a lotes disponibles y aptos.
- [ ] 4.12. Verificar el orden FEFO con varios lotes del mismo alimento y diferentes fechas de vencimiento.
- [ ] 4.13. Verificar que los lotes sin fecha de vencimiento queden ordenados por fecha de recepción.
- [ ] 4.14. Verificar que los lotes bloqueados no se contabilicen como stock disponible.
- [ ] 4.15. Verificar que las cantidades y unidades se mantengan correctamente al agrupar alimentos.
- [ ] 4.16. Verificar el comportamiento con cantidades decimales y diferentes unidades de medida.

**Estado:** implementación realizada y pruebas manuales de ordenamiento, cantidades y tarjetas de resumen efectuadas. Quedan pendientes algunas verificaciones específicas de reglas FEFO, bloqueos y consistencia de unidades.

**Evidencia:** revisión local de la ruta `GET /inventario` en `app_tarea_2.rb` y de la vista `inventario_tarea_2.erb`.

---

## 5. Alertas y control de vencimientos

**Objetivo:** identificar alimentos próximos a vencer y excluir del inventario disponible aquellos cuya fecha de vencimiento ya llegó o pasó.

- [x] 5.1. Actualizar el estado de los lotes cuya fecha de vencimiento ya llegó o pasó.
- [x] 5.2. Mostrar alertas para alimentos próximos a vencer dentro de los 14 días siguientes.
- [x] 5.3. Diferenciar visualmente los alimentos que vencen dentro de los próximos 7 días.
- [x] 5.4. Registrar alimentos con fechas de vencimiento vencidas y vigentes para comprobar su comportamiento.
- [x] 5.5. Comprobar que las alertas funcionaran según las fechas registradas.
- [x] 5.6. Comprobar que los lotes vencidos quedaran fuera del stock disponible.
- [x] 5.7. Identificar una limitación en la primera versión: las alertas se presentaban ordenadas alfabéticamente y no por fecha de vencimiento.
- [x] 5.8. Corregir posteriormente el orden de las alertas, estableciendo una prioridad ascendente por fecha de vencimiento en una versión siguiente de la aplicación.
- [ ] 5.9. Verificar los límites exactos de las alertas: 14 días, 7 días y fecha de vencimiento actual.
- [ ] 5.10. Verificar que los lotes vencidos no aparezcan como disponibles en ninguna sección del inventario.
- [ ] 5.11. Verificar que las alertas distingan correctamente los lotes según su estado.
- [ ] 5.12. Comprobar el comportamiento de los lotes sin fecha de vencimiento.

**Estado:** alertas y control de vencimientos implementados y probados manualmente. Se identificó y corrigió posteriormente una limitación en el ordenamiento de las alertas. Los casos límite y filtros específicos quedan pendientes de verificación adicional.

**Evidencia:** revisión local de la función de actualización de vencimientos, ruta `GET /inventario` y vista `inventario_tarea_2.erb`. La corrección del ordenamiento corresponde a una versión posterior de la aplicación.

---

## 6. Interfaz, identidad visual y diseño adaptable

**Objetivo:** construir una interfaz clara y accesible, coherente con la identidad visual del Banco de Alimentos Comunitario.

- [x] 6.1. Aplicar la paleta de colores definida en la SKILL de identidad visual.
- [x] 6.2. Incorporar el degradado de identidad en el encabezado.
- [x] 6.3. Utilizar estilos consistentes para títulos, paneles, formularios y botones.
- [x] 6.4. Incorporar etiquetas visibles en los campos del formulario.
- [x] 6.5. Diferenciar visualmente las acciones principales y secundarias.
- [x] 6.6. Incorporar indicadores visuales para los estados de los lotes.
- [x] 6.7. Incorporar estilos para las alertas de vencimiento.
- [x] 6.8. Incorporar áreas de interacción amplias para botones y campos.
- [x] 6.9. Incorporar reglas responsive para adaptar la interfaz a teléfonos y computadores.
- [x] 6.10. Comprobar visualmente los diferentes estados y definir sus colores correspondientes.
- [ ] 6.11. Comprobar la legibilidad y el funcionamiento de la interfaz en diferentes tamaños de pantalla.
- [ ] 6.12. Verificar que la información de los estados y alertas se comprenda sin depender exclusivamente del color.
- [ ] 6.13. Revisar la señalización visual de los lotes bloqueados.
- [ ] 6.14. Realizar pruebas de accesibilidad con usuarios de diferentes niveles de experiencia tecnológica.

**Estado:** implementación visual realizada y estados comprobados durante las pruebas manuales. Las verificaciones específicas de accesibilidad y adaptación a distintos dispositivos quedan pendientes.

**Evidencia:** revisión local de `views/inventario_tarea_2.erb`, `public/style_tarea_2.css` y `.kiro/skills/identidad-visual-banco-alimentos/SKILL_2.md`.

---

## 7. Verificaciones adicionales recomendadas

**Objetivo:** identificar aspectos importantes que no quedaron confirmados durante las pruebas manuales recordadas y que conviene comprobar antes de considerar robusta la funcionalidad.

Estas pruebas no se registran como realizadas. Se mantienen pendientes para futuras revisiones.

- [ ] 7.1. Comprobar que una recepción con varios alimentos se registre de forma atómica: si falla uno de los lotes, no deben quedar datos parciales.
- [ ] 7.2. Comprobar que no se puedan registrar cantidades nulas, negativas, no numéricas o infinitas.
- [ ] 7.3. Comprobar que no se acepten fechas inválidas o fechas de vencimiento anteriores a la recepción.
- [ ] 7.4. Comprobar que un lote vencido el día actual cambie correctamente a estado `Vencido`.
- [ ] 7.5. Comprobar los límites de las alertas cuando faltan exactamente 14 días y exactamente 7 días para el vencimiento.
- [ ] 7.6. Comprobar que los lotes no aptos, vencidos y bloqueados no se contabilicen como stock disponible.
- [ ] 7.7. Comprobar que las alertas no incluyan lotes que no correspondan a los estados que deben gestionarse.
- [ ] 7.8. Comprobar que el ordenamiento FEFO se mantenga correctamente cuando existen varios lotes del mismo alimento.
- [ ] 7.9. Comprobar que la edición o revisión de un lote no altere accidentalmente su identificador o relación con la recepción.
- [ ] 7.10. Comprobar que los datos persistan después de reiniciar Docker y la aplicación.
- [ ] 7.11. Comprobar el comportamiento cuando la base de datos no está disponible o se produce un error de conexión.
- [ ] 7.12. Comprobar que las pantallas y formularios funcionen correctamente en distintos tamaños de pantalla y navegadores.

---

## 8. Mejoras futuras y oportunidades de evolución

> Las siguientes ideas surgieron durante la revisión de la primera implementación. No forman parte del alcance original de esta SPEC ni se consideran tareas implementadas. Se registran como oportunidades para futuras versiones.

### 8.1. Usuarios y autorización

- [ ] Diseñar un sistema de inicio de sesión.
- [ ] Definir perfiles y permisos según las responsabilidades de cada usuario.
- [ ] Restringir acciones sensibles, como aprobar, rechazar, editar o eliminar lotes.
- [ ] Registrar quién realizó cada modificación.

### 8.2. Gestión de estados y revisión física

- [ ] Permitir una nueva revisión de un lote marcado inicialmente como `No_apto`.
- [ ] Permitir cambiarlo a `Disponible` cuando una nueva verificación física confirme que está en condiciones de uso.
- [ ] Incorporar un estado de `Eliminado` o `Descartado` cuando el alimento no pueda utilizarse.
- [ ] Solicitar y registrar el motivo de cada cambio de estado.
- [ ] Mantener un historial de las revisiones y modificaciones realizadas.

### 8.3. Validación y corrección de nombres de alimentos

- [ ] Evaluar la creación de un catálogo de alimentos para normalizar sus nombres.
- [ ] Evitar registros duplicados por diferencias de escritura o errores tipográficos.
- [ ] Permitir corregir el nombre de un alimento después de su registro, conservando la identificación y trazabilidad del lote.
- [ ] Evaluar mecanismos de búsqueda y sugerencias de nombres existentes.

### 8.4. Corrección y actualización de información de lotes

- [ ] Permitir completar o corregir la fecha de vencimiento de un lote inicialmente registrado sin ella, cuando una segunda revisión permita identificarla.
- [ ] Permitir actualizar información del lote sin perder su identificador ni su relación con la recepción original.
- [ ] Registrar quién realizó la modificación, cuándo y por qué.
- [ ] Mantener un historial de cambios para evitar pérdida de trazabilidad.

### 8.5. Control de vencimientos y eliminación

- [ ] Mantener los lotes vencidos fuera del stock disponible.
- [ ] Permitir registrar cuándo se realizó efectivamente la eliminación física del alimento.
- [ ] Registrar responsable, fecha y motivo de eliminación.
- [ ] Diferenciar entre un lote vencido pendiente de eliminación y uno ya eliminado.
- [ ] Conservar el registro histórico para mantener la trazabilidad del inventario.

### 8.6. Otras oportunidades de mejora

- [ ] Identificar nuevas necesidades a partir del uso real de la aplicación.
- [ ] Revisar los procesos de registro, revisión y consulta con los voluntarios.
- [ ] Priorizar futuras mejoras según su impacto, frecuencia de uso y facilidad de implementación.
- [ ] Evaluar nuevas funcionalidades sin comprometer la simplicidad de uso ni el bajo costo del sistema.

---

## 9. Resumen del estado de la primera SPEC

| Área | Estado |
|---|---|
| Base de datos y modelo de lotes | Implementado |
| Registro de donaciones | Implementado y probado manualmente |
| Revisión de lotes | Implementada y probada manualmente |
| Inventario y cantidades | Implementados y probados manualmente |
| Priorización FEFO | Implementada; verificaciones adicionales pendientes |
| Alertas de vencimiento | Implementadas y probadas manualmente |
| Ordenamiento de alertas | Limitación detectada y corregida en una versión posterior |
| Interfaz e identidad visual | Implementadas y revisadas manualmente |
| Pruebas funcionales principales | Realizadas antes del despliegue |
| Pruebas adicionales de robustez | Pendientes de verificación |
| Mejoras futuras | Identificadas; fuera del alcance de esta SPEC |

## Alcance y cierre

Esta reconstrucción corresponde exclusivamente a la primera SPEC: **Control de Inventario por Lotes y Priorización FEFO**.

La implementación contempló el registro de recepciones y lotes, la revisión de condiciones, la organización del inventario, el cálculo de cantidades disponibles, la priorización por vencimiento y las alertas correspondientes.

Se realizaron pruebas manuales antes del despliegue de la aplicación en Render. Durante ese proceso se identificaron oportunidades de mejora, algunas de las cuales fueron incorporadas posteriormente en nuevas versiones.

Las mejoras futuras enumeradas en este documento no forman parte de los criterios de aceptación originales ni deben interpretarse como funcionalidades ya implementadas.

Este documento permite conservar el aprendizaje de la primera etapa y utilizarlo como referencia para la evolución del Banco de Alimentos Comunitario.