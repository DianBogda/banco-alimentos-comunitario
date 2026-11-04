\# Tasks: Registro de Familias y Entregas



\## Nota sobre el estado de esta especificación



Esta especificación se documenta de manera retrospectiva, tomando como referencia la implementación existente de la aplicación y las pruebas realizadas antes de su despliegue en Render.



Los estados indican el nivel de avance conocido:



\- \*\*Implementado:\*\* funcionalidad presente en el código.

\- \*\*Verificado:\*\* funcionalidad probada y confirmada por el usuario.

\- \*\*Pendiente de verificación:\*\* funcionalidad implementada que requiere pruebas adicionales.

\- \*\*Mejora futura:\*\* funcionalidad fuera del alcance actual.



\---



\## 1. Registro de familias beneficiarias



\- \[x] Crear la tabla `familias` en SQLite.

\- \[x] Incorporar los campos código, apellidos, integrantes, estado y fecha de registro.

\- \[x] Generar automáticamente un código único para cada familia con formato `FAM-0001`.

\- \[x] Validar que los apellidos sean obligatorios.

\- \[x] Validar que la cantidad de integrantes sea un número entero mayor que cero.

\- \[x] Evitar el registro de códigos duplicados mediante una restricción de unicidad.

\- \[x] Mostrar las familias registradas en la pantalla correspondiente.

\- \[x] Verificar el registro de familias y la generación de códigos únicos.

\- \[x] Verificar que no se permita registrar códigos duplicados.



\*\*Estado:\*\* Implementado y verificado.



\## 2. Consulta de familias beneficiarias



\- \[x] Consultar las familias activas desde la base de datos.

\- \[x] Mostrar código, apellidos, cantidad de integrantes y fecha de registro.

\- \[x] Ordenar las familias por código en forma ascendente.

\- \[ ] Verificar el mensaje mostrado cuando todavía no existen familias registradas.



\*\*Estado:\*\* Implementado. Ordenamiento verificado; mensaje de lista vacía pendiente de verificación.



\## 3. Registro de entregas



\- \[x] Crear la tabla `entregas` para registrar cada operación.

\- \[x] Crear la tabla `detalle\_entregas` para registrar los alimentos y lotes utilizados.

\- \[x] Permitir seleccionar una familia activa.

\- \[x] Incorporar fecha de entrega y responsable.

\- \[x] Permitir agregar varios alimentos en una misma entrega.

\- \[ ] Permitir agregar y quitar filas de alimentos mediante JavaScript.

\- \[x] Permitir ingresar la cantidad correspondiente a cada alimento.

\- \[x] Validar los datos obligatorios y las cantidades mayores que cero.

\- \[ ] Agrupar filas repetidas del mismo alimento y unidad.

\- \[x] Registrar todos los alimentos de una operación bajo una misma entrega.

\- \[x] Verificar el registro de varios alimentos en una misma entrega.



\*\*Estado:\*\* Implementado y parcialmente verificado.



\## 4. Validación de existencias y actualización del inventario



\- \[x] Consultar únicamente alimentos con stock disponible.

\- \[x] Excluir lotes vencidos, bloqueados o sin cantidad disponible.

\- \[x] Seleccionar los lotes siguiendo el criterio FEFO.

\- \[x] Verificar que exista stock suficiente para todos los alimentos antes de registrar la entrega.

\- \[ ] Evitar que se registre una entrega parcial cuando no existe stock suficiente.

\- \[x] Descontar las cantidades entregadas de los lotes correspondientes.

\- \[x] Registrar en el detalle de la entrega los lotes y cantidades utilizados.

\- \[x] Ejecutar el registro y los descuentos dentro de una transacción de base de datos.

\- \[x] Verificar que las cantidades se descuenten correctamente de los lotes del inventario.

\- \[ ] Verificar el comportamiento cuando el stock es insuficiente para uno de los alimentos.

\- \[ ] Verificar que un error durante el registro no deje descuentos parciales en el inventario.



\*\*Estado:\*\* Implementado. Descuento de stock verificado; escenarios de error pendientes de verificación.



\## 5. Consulta del historial de entregas



\- \[x] Consultar las últimas 50 entregas registradas.

\- \[x] Ordenar las entregas desde la más reciente a la más antigua.

\- \[x] Mostrar fecha, código de familia, apellidos y responsable.

\- \[x] Mostrar los alimentos incluidos en cada entrega.

\- \[x] Mostrar las cantidades y unidades correspondientes.

\- \[ ] Verificar el mensaje mostrado cuando todavía no existen entregas registradas.



\*\*Estado:\*\* Implementado. Consulta general del historial pendiente de verificación completa.



\---



\## 6. Mejoras futuras



Las siguientes funcionalidades quedan fuera del alcance de esta versión:



\- \[ ] Incorporar alertas de alimentos básicos faltantes o con stock bajo.

\- \[ ] Permitir editar los apellidos y la cantidad de integrantes de una familia.

\- \[ ] Permitir desactivar familias desde la interfaz, conservando sus registros históricos.

\- \[ ] Incorporar una consulta del historial individual de entregas por familia.

\- \[ ] Incorporar criterios de priorización para la distribución de alimentos.

\- \[ ] Incorporar usuarios, autenticación y permisos de acceso.

\- \[ ] Registrar quién realiza modificaciones en los datos.



\---



\## 7. Resumen del estado



La aplicación cuenta con el registro y consulta de familias beneficiarias, el registro de entregas con varios alimentos y la actualización del inventario mediante el descuento de cantidades desde los lotes correspondientes.



Las pruebas confirmadas por el usuario incluyen el registro de familias, la generación de códigos únicos, la prevención de duplicados, el ordenamiento de familias y el descuento correcto de varios alimentos desde el inventario.



Quedan pendientes algunas pruebas de escenarios de error y de visualización de listas vacías. Las mejoras adicionales se mantienen identificadas como trabajo futuro.



