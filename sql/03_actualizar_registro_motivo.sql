-- Ejecutar una sola vez en la base MySQL existente del proyecto.
-- Agrega los campos donde se guardan el motivo seleccionado y su detalle.
ALTER TABLE registro
    ADD COLUMN justificacion VARCHAR(255) NOT NULL DEFAULT '',
    ADD COLUMN observaciones TEXT NULL;
