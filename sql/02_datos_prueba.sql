-- Datos de prueba. Correr despues de 01_esquema.sql.
--
-- Los horarios se cargan para el dia en que se corre este script
-- (CURRENT_DATE). Si al dia siguiente queres seguir probando, volve a correr
-- los dos scripts.

BEGIN;

INSERT INTO funcionario (cedula, nombre, activo) VALUES
    (11111111, 'Juan Perez',  true),
    (22222222, 'Maria Gomez', true),
    (33333333, 'Carlos Diaz', true),
    (44444444, 'Ana Lopez',   false);  -- dada de baja: el reloj la rechaza

-- Carlos Diaz no tiene horario cargado para hoy, a proposito.
INSERT INTO horario (id_funcionario, fecha, entrada, salida) VALUES
    ((SELECT id FROM funcionario WHERE cedula = 11111111), CURRENT_DATE, '08:00', '16:00'),
    ((SELECT id FROM funcionario WHERE cedula = 22222222), CURRENT_DATE, '09:00', '17:00'),
    ((SELECT id FROM funcionario WHERE cedula = 44444444), CURRENT_DATE, '07:45', '15:45');

-- Un usuario administrador para Juan Perez. Contraseña: admin123
-- (el hash lo genero Django con make_password; todavia no se usa en la app)
INSERT INTO usuario (id_funcionario, hash_password, rol)
SELECT id, 'pbkdf2_sha256$1500000$0qizSoMe5w5Cuqw03q8p4o$UCaSsAwwWLURyL8SEOViTCTakDndFS/jh7fGfIyteN0=', 1 FROM funcionario WHERE cedula = 11111111;

COMMIT;
