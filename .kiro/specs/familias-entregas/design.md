\# Design

\## Registro de Familias Beneficiarias y Gestión de Entregas



\### 1. Objetivo



Diseñar e implementar el registro y consulta de familias beneficiarias, junto con el registro de entregas de alimentos y su integración con el inventario existente.



La solución permite identificar a las familias mediante un código único, registrar los alimentos entregados y actualizar automáticamente las cantidades disponibles, manteniendo la trazabilidad de los lotes utilizados.



\### 2. Arquitectura y tecnologías



La funcionalidad se integra en la aplicación existente Banco de Alimentos Comunitario.



\*\*Tecnologías utilizadas:\*\*



\- Ruby y Sinatra: lógica de aplicación y gestión de rutas.

\- SQLite: almacenamiento de familias, entregas y detalles.

\- HTML y ERB: formularios y vistas.

\- CSS: presentación visual y adaptación a distintos tamaños de pantalla.

\- JavaScript: incorporación y eliminación dinámica de alimentos en el formulario de entregas.

\- Docker: entorno de ejecución de la aplicación.



Se mantiene la estructura y la base de datos utilizada por el módulo de inventario.



\### 3. Modelo de datos



La funcionalidad incorpora tres tablas principales y utiliza la tabla de lotes existente.



\#### 3.1 Tabla FAMILIAS



Almacena la información básica de las familias beneficiarias.



| Campo | Descripción |

|---|---|

| id | Identificador interno autoincremental. |

| codigo | Código único generado automáticamente. |

| apellidos | Apellidos de la familia. |

| integrantes | Número de integrantes del grupo familiar. |

| activa | Estado de la familia. |

| created\_at | Fecha de creación del registro. |



El código se genera con el formato `FAM-0001`, utilizando el identificador interno de la familia.



La base de datos establece una restricción de unicidad para el campo `codigo`.



\#### 3.2 Tabla ENTREGAS



Almacena la información general de cada operación de entrega.



| Campo | Descripción |

|---|---|

| id | Identificador interno autoincremental. |

| codigo\_operacion | Identificador único de la operación. |

| familia\_id | Referencia a la familia beneficiaria. |

| fecha\_entrega | Fecha en que se realiza la entrega. |

| responsable | Persona responsable de la entrega. |

| created\_at | Fecha de creación del registro. |



Cada entrega se asocia a una familia mediante una clave foránea.



El campo `codigo\_operacion` utiliza un identificador UUID único.



\#### 3.3 Tabla DETALLE\_ENTREGAS



Registra los alimentos y cantidades asociados a cada operación.



| Campo | Descripción |

|---|---|

| id | Identificador interno autoincremental. |

| entrega\_id | Referencia a la entrega. |

| lote\_id | Referencia al lote de inventario utilizado. |

| cantidad | Cantidad descontada del lote. |



Una entrega puede contener varios alimentos y utilizar uno o más lotes para completar las cantidades solicitadas.



La combinación de `entrega\_id` y `lote\_id` debe ser única.



\#### 3.4 Relación con la tabla LOTES



Se reutiliza la tabla `lotes` del módulo de inventario.



El campo `cantidad\_disponible` permite controlar las existencias restantes de cada lote.



Cada detalle de entrega mantiene una referencia al lote utilizado, permitiendo identificar de dónde provienen los alimentos distribuidos.



\### 4. Diseño funcional



\#### 4.1 Registro de familias



\*\*Ruta:\*\* `GET /familias`



Presenta el formulario de registro y el listado de familias activas.



\*\*Ruta:\*\* `POST /familias`



Proceso:



1\. Recibir apellidos y número de integrantes.

2\. Validar que ambos campos estén completos.

3\. Comprobar que el número de integrantes sea un entero mayor que cero.

4\. Iniciar una transacción.

5\. Insertar la familia con un código temporal único.

6\. Obtener el identificador interno generado.

7\. Asignar el código definitivo con formato `FAM-0001`.

8\. Confirmar la transacción.

9\. Redirigir al listado de familias.



El listado se ordena de forma ascendente por código.



\#### 4.2 Registro de entregas



\*\*Ruta:\*\* `GET /entregas`



Presenta el formulario de entrega y el historial de las últimas 50 operaciones.



Antes de mostrar la información, el sistema actualiza los lotes vencidos y consulta:



\- Familias activas.

\- Alimentos con stock disponible.

\- Últimas entregas registradas.

\- Detalles de los alimentos entregados.



\*\*Ruta:\*\* `POST /entregas`



El proceso contempla las siguientes etapas:



1\. Recibir la familia seleccionada, fecha, responsable, alimentos y cantidades.

2\. Validar los campos obligatorios y los datos ingresados.

3\. Agrupar las filas repetidas del mismo alimento y unidad.

4\. Actualizar el estado de los lotes vencidos.

5\. Iniciar una transacción.

6\. Verificar que la familia seleccionada esté activa.

7\. Consultar los lotes disponibles para cada alimento.

8\. Comprobar que exista stock suficiente para todos los productos solicitados.

9\. Registrar una única operación de entrega.

10\. Descontar las cantidades correspondientes de los lotes.

11\. Registrar cada descuento en la tabla DETALLE\_ENTREGAS.

12\. Confirmar la transacción y redirigir al historial.



\### 5. Control de inventario y criterio FEFO



El descuento de alimentos utiliza el criterio FEFO (\*First Expired, First Out\*), priorizando los lotes cuya fecha de vencimiento sea más próxima.



Para realizar el descuento, el sistema considera únicamente lotes que cumplan las siguientes condiciones:



\- Estado `Disponible`.

\- No bloqueados.

\- Cantidad disponible mayor que cero.

\- Sin fecha de vencimiento o con vencimiento posterior a la fecha actual.



Los lotes con fecha de vencimiento más próxima se utilizan primero.



Los lotes sin fecha de vencimiento se consideran al final, ordenados por fecha de recepción.



Cuando la cantidad solicitada supera la disponibilidad de un lote, el sistema continúa utilizando los siguientes hasta completar la cantidad requerida.



El descuento se realiza sobre el campo `cantidad\_disponible`, conservando el registro original del lote.



\### 6. Validaciones y manejo de errores



El sistema contempla validaciones para evitar registros incompletos o inconsistentes.



\*\*Registro de familias:\*\*



\- Apellidos obligatorios.

\- Número de integrantes obligatorio.

\- Número entero mayor que cero.

\- Código único por familia.



\*\*Registro de entregas:\*\*



\- Selección de una familia activa.

\- Fecha de entrega válida.

\- Responsable obligatorio.

\- Al menos un alimento.

\- Alimento y cantidad obligatorios en cada fila utilizada.

\- Cantidades numéricas mayores que cero.

\- Existencias suficientes para todos los alimentos solicitados.



Si algún alimento no tiene stock suficiente, la operación se cancela y se informa el problema.



La transacción permite evitar que queden entregas registradas o cantidades descontadas parcialmente cuando ocurre un error durante el proceso.



\### 7. Interfaz de usuario



La funcionalidad incorpora dos vistas principales:



\*\*Familias (`familias.erb`):\*\*



\- Formulario de registro de familias.

\- Listado de familias registradas.

\- Visualización de código, apellidos, integrantes y fecha de registro.

\- Navegación hacia inventario y entregas.



\*\*Entregas (`entregas.erb`):\*\*



\- Selección de familia beneficiaria.

\- Fecha y responsable de la entrega.

\- Formulario dinámico para agregar o quitar alimentos.

\- Selección de productos disponibles y cantidades.

\- Mensajes de error y confirmación.

\- Historial de las últimas 50 entregas.



La interfaz utiliza el estilo visual existente de la aplicación y mantiene la navegación entre inventario, familias y entregas.



\### 8. Alcance y limitaciones



La implementación contempla el registro de familias, la gestión de entregas y la actualización del inventario.



No incluye:



\- Edición de apellidos o cantidad de integrantes.

\- Desactivación de familias desde la interfaz.

\- Historial individual completo por familia.

\- Alertas automáticas de stock bajo.

\- Priorización automática de familias.

\- Autenticación y administración de permisos.

\- Notificaciones externas.



\### 9. Verificación



La funcionalidad se probó antes de su publicación en Render.



Las pruebas realizadas y confirmadas incluyen:



\- Registro de familias y generación de códigos únicos.

\- Prevención de registros con códigos duplicados.

\- Visualización de familias ordenadas por código.

\- Registro de varios alimentos en una misma entrega.

\- Descuento de las cantidades correspondientes desde los lotes de inventario.



La verificación de otros escenarios y validaciones puede ampliarse mediante pruebas adicionales.

