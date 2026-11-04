\# Requirements

\## Registro de Familias Beneficiarias y Gestión de Entregas



\### Objetivo



Implementar el registro y consulta de familias beneficiarias, junto con el registro de entregas de alimentos, permitiendo controlar las cantidades entregadas y mantener actualizado el inventario disponible.



\---



\## HU1 – Registrar familias beneficiarias



\*\*Como\*\* responsable del banco de alimentos,

\*\*quiero\*\* registrar a las familias beneficiarias indicando sus apellidos y número de integrantes,

\*\*para\*\* identificarlas y mantener un registro organizado de quienes reciben apoyo.



\*\*Criterios de aceptación\*\*



\- CA-1.1: El sistema debe permitir ingresar los apellidos de la familia.

\- CA-1.2: El sistema debe permitir ingresar el número de integrantes del grupo familiar.

\- CA-1.3: Los campos apellidos y número de integrantes deben ser obligatorios.

\- CA-1.4: El número de integrantes debe ser un valor entero mayor que cero.

\- CA-1.5: El sistema debe generar automáticamente un código único para cada familia, con formato FAM-0001.

\- CA-1.6: El sistema no debe permitir registrar códigos de familia duplicados.

\- CA-1.7: Una vez registrada, la familia debe aparecer en el listado de familias beneficiarias.



\---



\## HU2 – Consultar familias beneficiarias



\*\*Como\*\* responsable del banco de alimentos,

\*\*quiero\*\* consultar las familias registradas y sus datos básicos,

\*\*para\*\* identificar a las familias beneficiarias al momento de gestionar las entregas.



\*\*Criterios de aceptación\*\*



\- CA-2.1: El sistema debe mostrar un listado de las familias activas registradas.

\- CA-2.2: El listado debe mostrar el código, apellidos, número de integrantes y fecha de registro.

\- CA-2.3: Las familias deben mostrarse ordenadas de forma ascendente según su código.

\- CA-2.4: Si no existen familias registradas, el sistema debe mostrar un mensaje informativo.



\---



\## HU3 – Registrar entregas de alimentos



\*\*Como\*\* responsable del banco de alimentos,

\*\*quiero\*\* registrar una entrega asociada a una familia beneficiaria, indicando la fecha, el responsable y los alimentos entregados,

\*\*para\*\* mantener un registro de la distribución de alimentos.



\*\*Criterios de aceptación\*\*



\- CA-3.1: El sistema debe permitir seleccionar una familia beneficiaria activa.

\- CA-3.2: El sistema debe permitir ingresar la fecha de entrega.

\- CA-3.3: El sistema debe permitir ingresar el nombre del responsable de la entrega.

\- CA-3.4: El sistema debe permitir incorporar varios alimentos en una misma entrega.

\- CA-3.5: Cada alimento debe seleccionarse desde los productos disponibles en el inventario.

\- CA-3.6: El sistema debe permitir indicar la cantidad de cada alimento que se entregará.

\- CA-3.7: Los campos obligatorios deben validarse antes de registrar la entrega.

\- CA-3.8: Las cantidades deben ser valores numéricos mayores que cero.

\- CA-3.9: El sistema debe permitir agregar o quitar filas de alimentos en el formulario.

\- CA-3.10: Todos los alimentos ingresados deben quedar asociados a una misma operación de entrega.



\---



\## HU4 – Validar existencias y actualizar el inventario



\*\*Como\*\* responsable del banco de alimentos,

\*\*quiero\*\* que el sistema verifique las cantidades disponibles y descuente automáticamente los alimentos entregados,

\*\*para\*\* mantener actualizado el inventario y evitar entregas superiores al stock existente.



\*\*Criterios de aceptación\*\*



\- CA-4.1: El sistema debe ofrecer únicamente alimentos con stock disponible para realizar una entrega.

\- CA-4.2: Antes de registrar la entrega, el sistema debe verificar que exista stock suficiente para todos los alimentos solicitados.

\- CA-4.3: Si no existe stock suficiente de alguno de los alimentos, el sistema debe informar el problema y no registrar parcialmente la entrega.

\- CA-4.4: Al confirmar una entrega, el sistema debe descontar las cantidades correspondientes del inventario.

\- CA-4.5: Cuando un alimento esté distribuido en varios lotes, el descuento debe realizarse siguiendo el criterio FEFO.

\- CA-4.6: El sistema debe registrar qué lotes fueron utilizados y las cantidades descontadas de cada uno.

\- CA-4.7: La entrega y la actualización del inventario deben ejecutarse como una operación única, evitando registros o descuentos incompletos ante un error.

\- CA-4.8: Una vez completada la operación, el inventario debe reflejar las nuevas cantidades disponibles.



\---



\## HU5 – Consultar el historial de entregas



\*\*Como\*\* responsable del banco de alimentos,

\*\*quiero\*\* consultar las entregas realizadas y sus respectivos detalles,

\*\*para\*\* llevar un seguimiento de la distribución de alimentos entre las familias beneficiarias.



\*\*Criterios de aceptación\*\*



\- CA-5.1: El sistema debe mostrar las últimas 50 entregas registradas.

\- CA-5.2: Las entregas deben mostrarse ordenadas por fecha, desde la más reciente.

\- CA-5.3: Cada registro debe mostrar la fecha de entrega, código de la familia, apellidos, alimentos entregados y responsable.

\- CA-5.4: El sistema debe mostrar las cantidades y unidades correspondientes a cada alimento entregado.

\- CA-5.5: Si todavía no existen entregas registradas, el sistema debe mostrar un mensaje informativo.



\---



\## Alcance y consideraciones



Esta especificación contempla el registro y consulta de familias beneficiarias, el registro de entregas y su integración con el inventario existente.



Las funcionalidades se desarrollan como parte de un prototipo académico, utilizando datos ficticios.



No se consideran dentro del alcance actual:



\- Edición de los datos de las familias.

\- Desactivación de familias desde la interfaz.

\- Consulta de un historial individual completo por familia.

\- Priorización automática de familias o distribución de canastas.

\- Alertas de alimentos básicos con stock bajo.

\- Gestión de usuarios, autenticación y permisos.



\## Métricas de éxito



Las siguientes métricas permitirán evaluar si la funcionalidad de registro de familias y entregas cumple su objetivo.



| Métrica | Forma de medición | Meta esperada |

|---|---|---:|

| Registro correcto de familias | Familias registradas correctamente / intentos válidos de registro | 100% |

| Prevención de códigos duplicados | Intentos de registro duplicado rechazados | 100% |

| Registro correcto de entregas | Entregas válidas registradas correctamente / intentos válidos | 100% |

| Asociación de entregas a familias | Entregas vinculadas a una familia existente y activa | 100% |

| Descuento correcto del inventario | Cantidades descontadas correctamente de los lotes utilizados | 100% |

| Control de stock | Entregas registradas que superan el stock disponible | 0 |

| Aplicación del criterio FEFO | Entregas que utilizan primero los lotes con vencimiento más próximo | 100% |



\### Validación de las métricas



Las métricas se evaluarán mediante pruebas funcionales con datos ficticios, comprobando los registros en la aplicación y los cambios en el inventario.



Los porcentajes representan los objetivos esperados para el funcionamiento de esta versión, no resultados de medición ya obtenidos.

