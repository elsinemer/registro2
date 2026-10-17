-- Esquema de la base del reloj, version PostgreSQL.
-- Traducido de diagrama-integracion-reloj.sql (que estaba en sintaxis MySQL).
--
-- Cambios respecto al original (ver docs/BASE-DE-DATOS.md):
--   * La tabla "User" se llama "usuario": user es palabra reservada en Postgres.
--   * horario.entrada y horario.salida son TIME, no DATE: tienen que guardar horas.
--   * Las claves primarias son solo "id" (en el original eran compuestas).
--   * Nombres en minuscula: Postgres los pasa a minuscula si no van entre comillas.
--
-- Se puede correr de nuevo cuando quieras: borra las tablas y las crea vacias.

SET client_min_messages = warning;  -- no avisar si las tablas no existian

DROP TABLE IF EXISTS registro, horario, usuario, funcionario CASCADE;

CREATE TABLE funcionario (
    id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cedula  INTEGER NOT NULL UNIQUE,
    nombre  VARCHAR(255) NOT NULL,
    activo  BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE usuario (
    id              INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_funcionario  INTEGER NOT NULL UNIQUE REFERENCES funcionario (id),
    hash_password   VARCHAR(255) NOT NULL,
    rol             INTEGER NOT NULL
);

-- Un horario por funcionario y por dia.
CREATE TABLE horario (
    id              INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_funcionario  INTEGER NOT NULL REFERENCES funcionario (id),
    fecha           DATE NOT NULL,
    entrada         TIME NOT NULL,
    salida          TIME NOT NULL
);

-- Cada marca en el reloj.
--   desvio: minutos de diferencia con el horario (positivo = tarde)
--   motivo: 1 = ingreso, 2 = salida
--   marca:  fecha y hora en que se marco, como texto "YYYY-MM-DDTHH:MM:SS"
CREATE TABLE registro (
    id              INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_funcionario  INTEGER NOT NULL REFERENCES funcionario (id),
    id_horario      INTEGER NOT NULL REFERENCES horario (id),
    desvio          INTEGER NOT NULL,
    motivo          INTEGER NOT NULL,
    marca           VARCHAR(255),
    justificacion   VARCHAR(255) NOT NULL DEFAULT '',
    observaciones   TEXT NOT NULL DEFAULT ''
);
