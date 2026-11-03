# Requirements — Control de Inventario por Lotes y Priorización FEFO

## 1. Introducción

### 1.1. Definición del problema

El Banco de Alimentos Comunitario recibe donaciones que pueden incluir diferentes tipos de alimentos, cantidades y fechas de vencimiento. La falta de un control organizado por lotes dificulta conocer las cantidades realmente disponibles de cada alimento, identificar los productos próximos a vencer y priorizar su distribución.

Esta situación puede provocar pérdidas de alimentos y dificultar el trabajo de los voluntarios y la supervisión del coordinador.

### 1.2. Objetivo de la solución

Implementar una funcionalidad de control de inventario por lotes que permita registrar los distintos alimentos recibidos, revisar su condición, consultar las cantidades disponibles de cada producto y priorizar aquellos cuya fecha de vencimiento sea más próxima, aplicando el criterio FEFO (First Expired, First Out).

## 2. Historias de usuario y criterios de aceptación

### Historia de usuario 1: Registrar donaciones por tipo de alimento

**Como** voluntario del Banco de Alimentos,  
**quiero** registrar los distintos tipos de alimentos que recibimos en una donación,  
**para** mantener un inventario organizado y conocer las cantidades disponibles de cada producto.

**Criterios de aceptación:**

- **CA-1.1 — Registro de distintos alimentos:** Dada una donación que contiene diferentes tipos de alimentos, cuando el voluntario la registra, entonces el sistema debe generar un lote independiente para cada tipo de alimento.
- **CA-1.2 — Identificación de lotes:** Cada lote debe tener un identificador único y estar asociado a un solo tipo de alimento.
- **CA-1.3 — Datos del lote:** Cada lote debe registrar tipo de alimento, cantidad, unidad de medida, fecha de recepción y fecha de vencimiento, cuando corresponda.
- **CA-1.4 — Estado inicial:** Todo lote nuevo debe quedar inicialmente en estado «Pendiente de revisión».

### Historia de usuario 2: Revisar la condición de los alimentos recibidos

**Como** voluntario del Banco de Alimentos,  
**quiero** revisar y registrar la condición de los alimentos recibidos,  
**para** asegurar que solamente los productos aptos se incorporen al inventario disponible.

**Criterios de aceptación:**

- **CA-2.1 — Revisión pendiente:** Dado un lote recién registrado, cuando se consulta su información, entonces debe identificarse como «Pendiente de revisión».
- **CA-2.2 — Aprobación de alimentos:** Dado un lote pendiente cuya condición ha sido revisada y se considera apta, cuando se aprueba, entonces su estado debe cambiar a «Disponible».
- **CA-2.3 — Incorporación al stock:** Cuando un lote pasa a estado «Disponible», su cantidad debe incorporarse al stock disponible del tipo de alimento correspondiente.
- **CA-2.4 — Alimentos no aptos:** Cuando un alimento no es apto para consumo, debe permanecer excluido del stock disponible y no puede utilizarse para entregas.

### Historia de usuario 3: Consultar el inventario por tipo de alimento

**Como** coordinador del Banco de Alimentos,  
**quiero** consultar el inventario agrupado por tipo de alimento y conocer las cantidades disponibles y pendientes de revisión,  
**para** supervisar las existencias y tomar decisiones sobre su gestión.

**Criterios de aceptación:**

- **CA-3.1 — Organización del inventario:** El sistema debe mostrar los alimentos agrupados por tipo de producto.
- **CA-3.2 — Cantidades disponibles:** Para cada tipo de alimento, el sistema debe mostrar la cantidad total disponible y su unidad de medida.
- **CA-3.3 — Detalle de lotes:** El usuario debe poder consultar los lotes asociados a cada tipo de alimento, incluyendo sus cantidades, fechas y estados.
- **CA-3.4 — Diferenciación de estados:** Los lotes pendientes de revisión, disponibles y no disponibles deben distinguirse visualmente.

### Historia de usuario 4: Priorizar los alimentos según FEFO

**Como** voluntario del Banco de Alimentos,  
**quiero** visualizar los lotes disponibles ordenados según su fecha de vencimiento,  
**para** priorizar la utilización de los alimentos que vencen primero y reducir las pérdidas.

**Criterios de aceptación:**

- **CA-4.1 — Orden de vencimiento:** Dado que existen varios lotes disponibles del mismo tipo de alimento, cuando se consulta el inventario, entonces deben mostrarse ordenados desde la fecha de vencimiento más próxima hasta la más lejana.
- **CA-4.2 — Alimentos sin vencimiento:** Los lotes sin fecha de vencimiento deben aparecer al final de la lista, ordenados desde la fecha de recepción más antigua.
- **CA-4.3 — Exclusión de otros estados:** Los lotes pendientes de revisión, no aptos o vencidos no deben incluirse en la priorización de alimentos disponibles.

### Historia de usuario 5: Identificar alimentos próximos a vencer y vencidos

**Como** coordinador del Banco de Alimentos,  
**quiero** identificar los alimentos próximos a vencer y aquellos que ya vencieron,  
**para** anticipar su utilización y evitar que productos vencidos permanezcan en el inventario disponible.

**Criterios de aceptación:**

- **CA-5.1 — Alerta preventiva:** Cuando un alimento se encuentre a 14 días o menos de su fecha de vencimiento, el sistema debe mostrar una alerta visual.
- **CA-5.2 — Alerta prioritaria:** Cuando falten 7 días o menos para el vencimiento, el sistema debe mostrar una alerta visual más destacada.
- **CA-5.3 — Cambio de estado:** Cuando la fecha de vencimiento sea igual o anterior a la fecha actual, el lote debe pasar al estado «Vencido».
- **CA-5.4 — Exclusión de vencidos:** Los lotes vencidos deben quedar excluidos del stock disponible y no pueden utilizarse para entregas.

## 3. Reglas de negocio generales

1. Cada lote corresponde a un único tipo de alimento y tiene un identificador propio.
2. Una misma donación puede generar varios lotes independientes cuando contiene diferentes tipos de alimentos.
3. Ningún lote se incorpora al stock disponible sin haber sido revisado y aprobado como apto.
4. Los alimentos pendientes de revisión, no aptos o vencidos no pueden considerarse disponibles para entrega.
5. El stock disponible considera únicamente lotes aptos, con cantidad mayor que cero y sin restricciones que impidan su utilización.
6. El criterio FEFO se aplica entre lotes del mismo tipo de alimento, priorizando el vencimiento más próximo.
7. Los alimentos sin fecha de vencimiento se muestran al final, ordenados por fecha de recepción, desde el más antiguo.

## 4. Alcance de la implementación

Esta especificación contempla exclusivamente el control de inventario por lotes, su revisión, consulta y priorización FEFO, incluyendo la identificación de alimentos próximos a vencer y vencidos.

La gestión de anulaciones, devoluciones físicas, solicitudes de clasificación, permisos avanzados y otros procesos complementarios queda fuera del alcance de esta primera implementación y podrá abordarse en futuras mejoras.

Para las pruebas se utilizarán exclusivamente datos ficticios.