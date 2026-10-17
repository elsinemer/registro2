# Marcas de ingreso y salida

## Cómo se usa

1. En la pantalla principal, escribe los ocho dígitos de la cédula.
2. Para registrar la entrada, pulsa `+` o el botón **Registrar ingreso**.
   Para registrar la salida, pulsa `-` o **Registrar salida**.
3. El navegador envía a Django la cédula y el tipo de marca. Django consulta el
   horario del funcionario para la fecha actual.
4. Para el ingreso se compara con `horario.entrada`; para la salida, con
   `horario.salida`. La hora registrada la toma el servidor.
5. Si la diferencia absoluta es de **5 minutos o más**, se abre la pantalla de
   justificación. Allí se elige un motivo y se pueden escribir observaciones.
   Al confirmar, se guarda la marca y la página vuelve a la pantalla principal.
6. Si la diferencia es menor a cinco minutos, la marca se guarda directamente
   y la pantalla principal muestra el resultado antes de reiniciarse.

## Qué queda guardado

Cada marca crea una fila en `registro` con el funcionario, el horario que se
usó, el desvío en minutos, la fecha y hora de la marca y el tipo: `1` para
ingreso o `2` para salida. Si se pidió justificar, también guarda el texto
seleccionado en `justificacion` y el detalle en `observaciones`.

Para el desvío, el servidor resta la hora prevista a la hora real. En una
salida, un resultado negativo significa que se retiró antes; uno positivo,
que se retiró después. El mismo cálculo deja en cero una marca exacta.

## Preparar una base de datos existente

El modelo Django ahora escribe `justificacion` y `observaciones`. Si esas
columnas todavía no existen en la tabla `registro`, ejecuta una sola vez el
script `sql/03_actualizar_registro_motivo.sql` contra la base configurada en
`reloj/reloj/settings.py`. El script de actualización es para MySQL. Si estás
creando una base desde cero con el esquema SQL del proyecto, esas columnas ya
están incluidas en `sql/01_esquema.sql`.

## Comprobación rápida

- En la pantalla, completa la cédula y confirma que aparecen los dos botones.
- Pulsa `-` y verifica en la respuesta del servidor que se informa la hora de
  salida prevista.
- Para probar la pantalla de justificación, configura temporalmente la hora
  de salida al menos cinco minutos antes o después de la hora actual.
- Confirma un motivo y revisa la última fila de `registro`: debe indicar
  `motivo = 2`, el desvío y la justificación.
- Comprueba que el navegador vuelve a `/` después de guardar.
