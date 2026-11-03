---
name: identidad-visual-banco-alimentos
description: Define y mantiene la identidad visual del Banco de Alimentos Comunitario. Utilizar al diseñar, implementar o modificar pantallas, componentes y elementos visuales de la aplicación.
---

# Skill: Identidad visual del Banco de Alimentos Comunitario

## 1. Propósito de la identidad visual

La aplicación debe transmitir:

- Cercanía y colaboración comunitaria.
- Confianza, seguridad y transparencia.
- Frescura, bienestar y alimentación.
- Orden, claridad y facilidad de uso.

La identidad debe ser cálida y moderna, pero también sobria y profesional. No debe parecer infantil ni excesivamente institucional.

## 2. Paleta de colores

Utilizar una combinación de turquesas y naranjas que transmita frescura, cercanía, energía y confianza.

### Colores turquesa

- Turquesa principal: `#5DC1B9`
- Turquesa medio: `#8AE0DB`
- Turquesa suave: `#B8F0ED`

### Colores naranjas

- Naranja principal: `#FF9800`
- Naranja suave: `#FFC340`

### Colores complementarios

- Blanco cálido: `#F7F8F5`
- Azul petróleo oscuro: `#29434A`

### Colores complementarios para tarjetas de resumen

- Lotes registrados: `#8AE0DB` (turquesa claro).
- Pendientes de revisión: `#DCEFE8` (verde suave).
- Próximos a vencer: `#FFE5C2` (naranja suave).

Estos tonos permiten diferenciar las tarjetas sin abandonar la identidad visual de la aplicación.

### Uso de los colores

- El turquesa principal será el color de identidad y se utilizará en navegación, botones principales y elementos destacados.
- Los turquesas medio y suave podrán utilizarse en fondos, tarjetas y superficies secundarias.
- El naranja principal se utilizará para acentos, llamadas de atención y acciones secundarias.
- El naranja suave podrá utilizarse en fondos de elementos destacados.
- El azul petróleo se utilizará en textos y elementos que requieran buen contraste.
- El blanco cálido será el fondo general preferido.
- Los colores complementarios de las tarjetas de resumen se utilizarán para diferenciar visualmente la información general del inventario.

## 3. Uso de degradés

El degradé principal combinará los tonos turquesa y naranja de la identidad visual:

`linear-gradient(110deg, #5DC1B9 0%, #8AE0DB 45%, #FF9800 100%)`

Se podrá utilizar en:

- Encabezados y banners.
- Elementos decorativos.
- Tarjetas destacadas.
- Detalles gráficos de la identidad.

No utilizar degradés detrás de textos pequeños, formularios o información que requiera lectura rápida.

Los degradés deben ser moderados y no competir con el contenido.

## 4. Tipografía y legibilidad

- Utilizar tipografías sans serif, sencillas y modernas.
- Priorizar la legibilidad en teléfonos y computadores.
- Mantener tamaños de texto cómodos.
- Utilizar títulos claros y jerarquías visuales consistentes.
- Evitar textos pequeños, tipografías decorativas y exceso de mayúsculas.

## 5. Componentes de interfaz

### Botones

- Deben ser grandes y fáciles de identificar.
- Utilizar textos claros que indiquen la acción.
- Mantener formas y estilos consistentes.
- Diferenciar visualmente las acciones principales y secundarias.
- El botón «Eliminar este alimento» utilizará un tono naranja claro, evitando el rojo para no confundirlo con el estado de vencido.

### Formularios

- Utilizar etiquetas visibles y descriptivas.
- Solicitar solamente los datos necesarios.
- Agrupar campos relacionados.
- Mostrar mensajes de validación y errores comprensibles.

### Tarjetas y paneles

- Presentar la información de manera ordenada.
- Utilizar espacios adecuados entre elementos.
- Evitar la sobrecarga visual.
- Destacar los datos importantes sin saturar la pantalla.
- Las tarjetas de resumen utilizarán tonos suaves diferenciados: turquesa claro para lotes registrados, verde suave para pendientes de revisión y naranja suave para próximos a vencer.

### Tablas

- Los encabezados de las tablas de stock utilizarán turquesa principal.
- En el detalle de lotes, el nombre del alimento utilizará turquesa principal y los encabezados de su tabla utilizarán turquesa claro.

### Iconografía

- Utilizar iconos sencillos, reconocibles y consistentes.
- Acompañar los iconos importantes con texto.
- No depender exclusivamente del color o de un icono para comunicar información.

## 6. Accesibilidad

La facilidad de uso es una prioridad.

- Mantener contraste suficiente entre texto y fondo.
- No utilizar el naranja o el turquesa como texto pequeño sobre fondos donde pierdan legibilidad.
- No comunicar estados únicamente mediante colores.
- Utilizar mensajes claros para errores, confirmaciones y advertencias.
- Mantener áreas de interacción cómodas para usuarios con poca experiencia tecnológica.
- Diseñar pensando primero en teléfonos, sin descuidar la versión de escritorio.

## 7. Estados y alertas

Los estados operativos deben distinguirse claramente.

- Disponible: utilizar una identificación visual positiva en verde suave, con texto verde oscuro.
- Pendiente de revisión: utilizar una identificación neutral en tonos suaves de la gama turquesa y verde.
- No apto: utilizar una identificación de advertencia en naranja claro, conservando su apariencia suave y diferenciada.
- Vencido: utilizar una identificación de alerta en rojo suave, diferenciada del estado no apto.
- Bloqueado: mostrar una señal explícita que indique que el alimento no puede asignarse.

### Alertas de vencimiento

- Hasta 14 días antes del vencimiento: utilizar una alerta preventiva en tono naranja, con contraste suficiente respecto del fondo.
- 7 días o menos: utilizar una alerta prioritaria en rojo.
- Mantener una diferenciación visual clara entre ambos niveles de alerta.

Los colores de estado deben ser consistentes y no confundirse con los colores decorativos de la marca.

Los colores de las tarjetas de resumen representan información general del inventario y no reemplazan los colores utilizados para identificar los estados individuales de los lotes.

## 8. Consistencia visual

- Mantener la misma paleta en todas las pantallas.
- Reutilizar componentes y estilos cuando sea posible.
- Evitar introducir colores adicionales sin una justificación funcional.
- Mantener coherencia entre botones, tarjetas, formularios, encabezados e iconos.
- No modificar las reglas de negocio para resolver decisiones visuales.

## 9. Principio general

Toda decisión visual debe favorecer la claridad, la confianza y la facilidad de uso.

La estética nunca debe dificultar la lectura, ocultar información importante ni interferir con la seguridad y el correcto funcionamiento del Banco de Alimentos Comunitario.

