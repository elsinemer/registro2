# La base de datos

Como estan armadas las tablas, por que difieren del diagrama original, y como
las usa Django.

---

## 1. Las tablas

```
┌───────────────────────┐
│ funcionario           │
├───────────────────────┤
│ id          PK        │◄──────────────┬───────────────────┬─────────────────┐
│ cedula      unico     │               │                   │                 │
│ nombre                │               │                   │                 │
│ activo                │               │                   │                 │
└───────────────────────┘               │                   │                 │
                                        │                   │                 │
┌───────────────────────┐   ┌───────────┴───────────┐   ┌───┴─────────────┐   │
│ usuario               │   │ horario               │   │ registro        │   │
├───────────────────────┤   ├───────────────────────┤   ├─────────────────┤   │
│ id            PK      │   │ id            PK      │◄──│ id_horario  FK  │   │
│ id_funcionario FK ────┼───┘ id_funcionario FK     │   │ id_funcionario ─┼───┘
│ hash_password         │   │ fecha                 │   │ desvio          │
│ rol                   │   │ entrada  (hora)       │   │ motivo          │
└───────────────────────┘   │ salida   (hora)       │   │ marca           │
                            └───────────────────────┘   └─────────────────┘
```

| Tabla | Una fila es... | Columnas importantes |
|---|---|---|
| `funcionario` | una persona que ficha | `cedula` (unica), `activo` (si esta dado de baja, el reloj lo rechaza) |
| `horario` | lo que una persona tiene que cumplir **un dia** | `fecha`, `entrada`, `salida` |
| `registro` | una marca en el reloj | `desvio` en minutos (positivo = tarde), `motivo` (1 = ingreso, 2 = salida), `marca` (fecha y hora de la marca) |
| `usuario` | una cuenta para entrar a administrar | `hash_password`, `rol`. **Todavia no se usa en la app.** |

**Las relaciones.** Un funcionario tiene muchos horarios (uno por dia) y
muchos registros. Cada registro apunta al horario contra el que se comparo:
asi, aunque despues le cambien el horario a alguien, sus marcas viejas
siguen diciendo contra que hora se midieron.

---

## 2. Diferencias con el diagrama original

El diagrama original (`diagrama-integracion-reloj.sql`, en la carpeta de la
materia) estaba en sintaxis MySQL. Para PostgreSQL hubo que traducirlo, y
ademas corregir cosas que no habrian funcionado en ningun motor:

| En el original | En `sql/01_esquema.sql` | Por que |
|---|---|---|
| `entrada DATE`, `salida DATE` | `TIME` | `DATE` guarda solo el dia (`2026-10-09`), no la hora. Con `DATE` no habia forma de saber a que hora entra alguien. |
| Tabla `User` | Tabla `usuario` | `user` es una palabra reservada en PostgreSQL. |
| Claves primarias compuestas, como `PRIMARY KEY(id, id_funcionario)` | Solo `id` | El `id` ya es unico solo. Ademas, `registro` apunta a `horario(id)`: Postgres exige que la columna apuntada sea unica por si misma, y con la clave compuesta no lo era. |
| `id INTEGER UNSIGNED` y `id_funcionario INTEGER` | Todos `INTEGER` | Postgres no tiene `UNSIGNED`. En MySQL, ademas, una clave foranea tiene que tener exactamente el mismo tipo que la columna a la que apunta (incluido el `UNSIGNED`), asi que el original habria fallado al crear las relaciones. |
| `AUTO_INCREMENT` | `GENERATED ALWAYS AS IDENTITY` | Es la forma de Postgres de numerar solo. |
| `Funcionario`, `Nombre` | `funcionario`, `nombre` | Postgres pasa a minuscula los nombres que no van entre comillas. Usar minuscula desde el principio evita confusiones. |

Dos interpretaciones nuestras, porque el diagrama no las aclaraba:

- **`motivo`**: lo usamos como tipo de marca, `1` = ingreso y `2` = salida.
  Hoy el reloj solo registra ingresos.
- **`marca`**: guarda la fecha y hora en que se marco, como texto
  (`2026-10-09T08:10:00`). Es el unico lugar del diagrama donde entra la hora
  real de la marca.

Si el grupo decide otra cosa para estas dos columnas, se cambia en
`views.registrar`.

---

## 3. Como la usa Django

### Los modelos (`reloj/fichadas/models.py`)

Cada tabla tiene una clase de Python que la representa. Django usa esas
clases para leer y escribir sin que escribamos SQL:

```python
Funcionario.objects.filter(cedula=11111111).first()
# Django lo traduce a: SELECT ... FROM funcionario WHERE cedula = 11111111 LIMIT 1
```

Lo particular de este proyecto es esta linea, que tienen todos los modelos:

```python
class Meta:
    managed = False
    db_table = "funcionario"
```

Normalmente Django crea las tablas a partir de los modelos (con
`makemigrations` y `migrate`). Aca es al reves: **las tablas las crea el
script SQL** y Django solo las usa. `managed = False` le dice a Django "esta
tabla no es tuya, no la crees ni la modifiques". `db_table` le dice el nombre
exacto.

Por eso, **si cambias una tabla, hay que cambiarla en los dos lugares**: en
`sql/01_esquema.sql` y en `models.py`. Para chequear que coinciden, Django
puede leer la base y mostrar los modelos que le corresponderian:

```bash
python manage.py inspectdb funcionario horario registro usuario
```

### Las claves foraneas

En el SQL la columna se llama `id_funcionario`. En el modelo el campo se
llama `funcionario` y lleva `db_column="id_funcionario"`:

```python
funcionario = models.ForeignKey(Funcionario, on_delete=models.DO_NOTHING, db_column="id_funcionario")
```

La ventaja es que en Python `horario.funcionario` devuelve directamente el
objeto `Funcionario`, con su nombre y su cedula, sin hacer una consulta a mano.

### Las vistas (`reloj/fichadas/views.py`)

Dos funciones auxiliares hacen el trabajo, y las usan las dos rutas:

- **`buscar_horario(cedula, fecha)`** busca al funcionario y su horario de
  ese dia. Si la cedula no existe, si esta dado de baja o si no tiene horario
  ese dia, devuelve el mensaje de error que se muestra en pantalla.
- **`calcular_desvio(horario, fecha)`** resta la hora de entrada a la hora
  de la marca, en minutos.

Despues:

- **`/fichar/`** usa las dos y devuelve el resultado para mostrar en pantalla.
  No guarda nada.
- **`/registrar/`** las usa de nuevo y guarda la marca:

  ```python
  Registro.objects.create(funcionario=..., horario=..., desvio=..., motivo=Registro.INGRESO, marca=...)
  ```

  `.create()` hace el `INSERT` y devuelve el registro con su `id` ya asignado.
  El desvio se recalcula en el servidor en vez de aceptar el que mande el
  navegador, para que nadie pueda guardar un numero inventado.

### La conexion (`reloj/reloj/settings.py`)

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DB_NAME', 'reloj'),
        'USER': os.environ.get('DB_USER', ''),
        ...
    }
}
```

`os.environ.get('DB_USER', '')` lee una **variable de entorno** y, si no
existe, usa el valor por defecto. Asi cada uno pone su usuario y contraseña de
Postgres en su maquina sin escribirlos en el codigo (y sin subirlos al repo).
Vacios, Django se conecta con tu usuario del sistema, que es lo que pasa en
una instalacion tipica de Linux.

El paquete que hace de puente entre Python y PostgreSQL es `psycopg`, y esta
en `requirements.txt`.

---

## 4. Consultas utiles

```bash
psql -d reloj
```

```sql
-- Todas las marcas, con nombre y horario
SELECT r.id, f.nombre, h.fecha, h.entrada, r.desvio, r.marca
FROM registro r
JOIN funcionario f ON f.id = r.id_funcionario
JOIN horario h ON h.id = r.id_horario
ORDER BY r.id;

-- Quienes llegaron tarde hoy
SELECT f.nombre, r.desvio
FROM registro r
JOIN funcionario f ON f.id = r.id_funcionario
JOIN horario h ON h.id = r.id_horario
WHERE h.fecha = CURRENT_DATE AND r.desvio > 0;

-- Dar de baja a alguien
UPDATE funcionario SET activo = false WHERE cedula = 22222222;
```

Para empezar de cero, volve a correr los dos scripts: el primero borra las
tablas y las crea vacias.
