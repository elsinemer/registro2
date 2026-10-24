-- Base de datos: proyectointegrador
-- Generado a partir de los volcados SQL actuales de las cuatro tablas propias.
-- Compatible con MySQL 8.0. El script reemplaza el contenido de estas cuatro tablas
-- si ya existen; realiza una copia de seguridad antes de ejecutarlo en una base usada.
-- Las tablas auth_* y django_* las crea Django ejecutando: python manage.py migrate

CREATE DATABASE IF NOT EXISTS `proyectointegrador`
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `proyectointegrador`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Elimina solo las tablas propias del proyecto, en orden seguro.
DROP TABLE IF EXISTS `registro`;
DROP TABLE IF EXISTS `usuario`;
DROP TABLE IF EXISTS `horario`;
DROP TABLE IF EXISTS `funcionario`;

-- Estructura de funcionario
CREATE TABLE `funcionario` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cedula` int NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cedula` (`cedula`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Estructura de horario
CREATE TABLE `horario` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_funcionario` int unsigned NOT NULL,
  `fecha` date NOT NULL,
  `entrada` time NOT NULL,
  `salida` time NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_horario_id_funcionario` (`id`,`id_funcionario`),
  KEY `fk_horario_funcionario` (`id_funcionario`),
  CONSTRAINT `fk_horario_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Estructura de registro
CREATE TABLE `registro` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_funcionario` int unsigned NOT NULL,
  `id_horario` int unsigned NOT NULL,
  `desvio` int NOT NULL,
  `motivo` int NOT NULL,
  `marca` varchar(255) DEFAULT NULL,
  `justificacion` varchar(255) NOT NULL DEFAULT '',
  `observaciones` text,
  PRIMARY KEY (`id`),
  KEY `fk_registro_funcionario` (`id_funcionario`),
  KEY `fk_registro_horario_funcionario` (`id_horario`,`id_funcionario`),
  CONSTRAINT `fk_registro_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id`),
  CONSTRAINT `fk_registro_horario_funcionario` FOREIGN KEY (`id_horario`, `id_funcionario`) REFERENCES `horario` (`id`, `id_funcionario`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Estructura de usuario
CREATE TABLE `usuario` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_Funcionario` int unsigned NOT NULL,
  `hash_password` varchar(255) NOT NULL,
  `rol` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_Funcionario` (`id_Funcionario`),
  CONSTRAINT `fk_usuario_funcionario` FOREIGN KEY (`id_Funcionario`) REFERENCES `funcionario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- Datos de ejemplo y prueba incluidos en la base actual.
-- Datos de funcionario
INSERT INTO `funcionario` VALUES (1,90000002,'Bruno Prueba',1),(2,90000003,'Carla Prueba',1),(3,90000004,'Diego Prueba',1),(4,90000005,'Elena Prueba',1),(5,90000006,'Fabian Prueba',1),(6,90000001,'Ana Prueba',1),(7,45536527,'Nemer Elsi',1),(8,90000007,'Espínola Anabela',1),(9,90000008,'Jaime Ana',1),(10,90000009,'Gutiérrez Agustina',1);

-- Datos de horario
INSERT INTO `horario` VALUES (1,1,'2026-10-14','20:10:00','21:00:00'),(2,2,'2026-10-10','10:00:00','18:00:00'),(3,6,'2026-10-10','08:00:00','16:00:00'),(4,3,'2026-10-10','14:00:00','22:00:00'),(5,4,'2026-10-10','15:00:00','23:00:00'),(6,5,'2026-10-10','16:00:00','23:00:00'),(7,7,'2026-10-12','17:30:00','12:00:00'),(112,8,'2026-10-17','08:30:00','12:30:00'),(113,9,'2026-10-17','09:00:00','13:00:00'),(114,10,'2026-10-17','09:00:00','13:00:00'),(115,7,'2026-10-17','08:00:00','12:00:00'),(116,8,'2026-10-19','07:30:00','12:30:00'),(117,9,'2026-10-19','10:00:00','15:00:00'),(118,10,'2026-10-19','11:00:00','16:00:00'),(119,7,'2026-10-19','13:30:00','18:30:00'),(120,8,'2026-10-20','08:00:00','13:00:00'),(121,9,'2026-10-20','08:30:00','13:30:00'),(122,10,'2026-10-20','12:30:00','17:30:00'),(123,7,'2026-10-20','13:00:00','18:00:00'),(124,8,'2026-10-21','09:00:00','14:00:00'),(125,9,'2026-10-21','09:30:00','14:30:00'),(126,10,'2026-10-21','12:00:00','17:00:00'),(127,7,'2026-10-21','14:00:00','19:00:00'),(128,8,'2026-10-22','08:30:00','12:30:00'),(129,9,'2026-10-22','09:00:00','13:00:00'),(130,10,'2026-10-22','09:00:00','13:00:00'),(131,7,'2026-10-22','08:00:00','12:00:00'),(132,8,'2026-10-23','08:30:00','13:30:00'),(133,9,'2026-10-23','09:00:00','14:00:00'),(134,10,'2026-10-23','13:00:00','18:00:00'),(135,7,'2026-10-23','12:00:00','17:00:00'),(136,8,'2026-10-24','07:30:00','12:30:00'),(137,9,'2026-10-24','10:00:00','15:00:00'),(138,10,'2026-10-24','11:00:00','16:00:00'),(139,7,'2026-10-24','13:30:00','18:30:00'),(140,8,'2026-10-26','09:00:00','14:00:00'),(141,9,'2026-10-26','09:30:00','14:30:00'),(142,10,'2026-10-26','12:00:00','17:00:00'),(143,7,'2026-10-26','14:00:00','19:00:00'),(144,8,'2026-10-27','08:30:00','12:30:00'),(145,9,'2026-10-27','09:00:00','13:00:00'),(146,10,'2026-10-27','09:00:00','13:00:00'),(147,7,'2026-10-27','08:00:00','12:00:00'),(148,8,'2026-10-28','08:30:00','13:30:00'),(149,9,'2026-10-28','09:00:00','14:00:00'),(150,10,'2026-10-28','13:00:00','18:00:00'),(151,7,'2026-10-28','12:00:00','17:00:00'),(152,8,'2026-10-29','07:30:00','12:30:00'),(153,9,'2026-10-29','10:00:00','15:00:00'),(154,10,'2026-10-29','11:00:00','16:00:00'),(155,7,'2026-10-29','13:30:00','18:30:00'),(156,8,'2026-10-30','08:00:00','13:00:00'),(157,9,'2026-10-30','08:30:00','13:30:00'),(158,10,'2026-10-30','12:30:00','17:30:00'),(159,7,'2026-10-30','13:00:00','18:00:00'),(160,8,'2026-10-31','09:00:00','14:00:00'),(161,9,'2026-10-31','09:30:00','14:30:00'),(162,10,'2026-10-31','12:00:00','17:00:00'),(163,7,'2026-10-31','14:00:00','19:00:00');

-- Datos de registro
INSERT INTO `registro` VALUES (12,7,115,56,1,'2026-10-17T08:56:00-03:00','Llegada tarde','Upps I did It again'),(13,7,115,-183,2,'2026-10-17T08:57:00-03:00','Otros',''),(14,7,115,172,1,'2026-10-17T10:52:00-03:00','Reunión de profesores',',dksjhbsniu'),(15,7,115,-68,2,'2026-10-17T10:52:00-03:00','Cambio de horario',''),(16,8,112,146,1,'2026-10-17T10:56:00-03:00','Cambio de día y horario de coordinación','');

-- Datos de usuario
INSERT INTO `usuario` VALUES (1,1,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',2),(2,2,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',2),(3,3,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',3),(4,4,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',2),(5,5,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',3),(6,6,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',1),(7,7,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',2);

-- Verificación rápida de las cuatro tablas propias:
SELECT 'funcionario' AS tabla, COUNT(*) AS registros FROM funcionario
UNION ALL SELECT 'horario', COUNT(*) FROM horario
UNION ALL SELECT 'registro', COUNT(*) FROM registro
UNION ALL SELECT 'usuario', COUNT(*) FROM usuario;
