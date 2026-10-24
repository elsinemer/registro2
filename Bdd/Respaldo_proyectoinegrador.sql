-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: proyectointegrador
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add funcionario',7,'add_funcionario'),(26,'Can change funcionario',7,'change_funcionario'),(27,'Can delete funcionario',7,'delete_funcionario'),(28,'Can view funcionario',7,'view_funcionario'),(29,'Can add usuario',8,'add_usuario'),(30,'Can change usuario',8,'change_usuario'),(31,'Can delete usuario',8,'delete_usuario'),(32,'Can view usuario',8,'view_usuario'),(33,'Can add horario',9,'add_horario'),(34,'Can change horario',9,'change_horario'),(35,'Can delete horario',9,'delete_horario'),(36,'Can view horario',9,'view_horario'),(37,'Can add registro',10,'add_registro'),(38,'Can change registro',10,'change_registro'),(39,'Can delete registro',10,'delete_registro'),(40,'Can view registro',10,'view_registro');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(7,'fichadas','funcionario'),(9,'fichadas','horario'),(10,'fichadas','registro'),(8,'fichadas','usuario'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-10-10 15:28:19.998216'),(2,'auth','0001_initial','2026-10-10 15:28:20.577510'),(3,'admin','0001_initial','2026-10-10 15:28:20.757523'),(4,'admin','0002_logentry_remove_auto_add','2026-10-10 15:28:20.767807'),(5,'admin','0003_logentry_add_action_flag_choices','2026-10-10 15:28:20.777169'),(6,'contenttypes','0002_remove_content_type_name','2026-10-10 15:28:20.896454'),(7,'auth','0002_alter_permission_name_max_length','2026-10-10 15:28:20.958995'),(8,'auth','0003_alter_user_email_max_length','2026-10-10 15:28:20.991494'),(9,'auth','0004_alter_user_username_opts','2026-10-10 15:28:21.002478'),(10,'auth','0005_alter_user_last_login_null','2026-10-10 15:28:21.062816'),(11,'auth','0006_require_contenttypes_0002','2026-10-10 15:28:21.065393'),(12,'auth','0007_alter_validators_add_error_messages','2026-10-10 15:28:21.078004'),(13,'auth','0008_alter_user_username_max_length','2026-10-10 15:28:21.157402'),(14,'auth','0009_alter_user_last_name_max_length','2026-10-10 15:28:21.227179'),(15,'auth','0010_alter_group_name_max_length','2026-10-10 15:28:21.259382'),(16,'auth','0011_update_proxy_permissions','2026-10-10 15:28:21.275326'),(17,'auth','0012_alter_user_first_name_max_length','2026-10-10 15:28:21.343570'),(18,'sessions','0001_initial','2026-10-10 15:28:21.380062');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('0mk8ciwl9xg1z6z57cy35eg2p2f1hnpa','e30:1xGG53:MycbcwdMZdY2Z-Pl9ULwe6uqWz5ywpe6wYp_o2GN4Ok','2026-10-26 13:28:41.284104'),('66twrqh31yuz26c2wsqckwe4lyckusgt','e30:1xI4tV:in27yfWnlT8LHaGrQHRTEaXphJHJnoyA6qsADMSWWGg','2026-10-31 13:56:17.925683'),('dwaea7t5hqnvgkab292htp9dgpbtujnl','e30:1xI32X:vvaCanPnYrUhGzJYvjA3FlL-a6dYo-avxDShD_iyU_s','2026-10-31 11:57:29.916370'),('n5spullgvdo1j7rzoawzbiod06hpd27n','.eJwtjr0OgjAURl_FfHNJLuXP3N3Bxcnd1PYiNdCSgiyEdzc1ricnJ2dH7-1g3vKYJTgvYRXwDivuMxow6qap2kZ3UOjFDhlp0m1RUqHre3lmIiYqqGIiKIQ4PZOAcZNJ0ukyLh4KssySjItglBVXWZxMsjn2K0DBybL5CNYdKax-zq4PryRLzHbc_JTnMr7-8XF8AVKTN9o:1xKiqy:YCBcvN7LbYmvOUgu4r3E0Fkzw5hMMrxMCH_6H5TY4o0','2026-11-07 21:00:36.065386'),('r79nw2nks7ixqf4gflhnqog1wloon6uv','e30:1xGG9J:XruTp9Ljpmh8nq6e4dBBvpwAYccxUUoGyYLACzT0jAE','2026-10-26 13:33:05.111682');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `funcionario`
--

DROP TABLE IF EXISTS `funcionario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funcionario` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cedula` int NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cedula` (`cedula`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionario`
--

LOCK TABLES `funcionario` WRITE;
/*!40000 ALTER TABLE `funcionario` DISABLE KEYS */;
INSERT INTO `funcionario` VALUES (1,90000002,'Bruno Prueba',1),(2,90000003,'Carla Prueba',1),(3,90000004,'Diego Prueba',1),(4,90000005,'Elena Prueba',1),(5,90000006,'Fabian Prueba',1),(6,90000001,'Ana Prueba',1),(7,45536527,'Nemer Elsi',1),(8,39966514,'Espínola Anabela',1),(9,34779429,'Jaime Ana',1),(10,55618808,'Gutiérrez Agustina',1);
/*!40000 ALTER TABLE `funcionario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horario`
--

DROP TABLE IF EXISTS `horario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horario`
--

LOCK TABLES `horario` WRITE;
/*!40000 ALTER TABLE `horario` DISABLE KEYS */;
INSERT INTO `horario` VALUES (1,1,'2026-10-14','20:10:00','21:00:00'),(2,2,'2026-10-10','10:00:00','18:00:00'),(3,6,'2026-10-10','08:00:00','16:00:00'),(4,3,'2026-10-10','14:00:00','22:00:00'),(5,4,'2026-10-10','15:00:00','23:00:00'),(6,5,'2026-10-10','16:00:00','23:00:00'),(7,7,'2026-10-12','17:30:00','12:00:00'),(112,8,'2026-10-17','08:30:00','12:30:00'),(113,9,'2026-10-17','09:00:00','13:00:00'),(114,10,'2026-10-17','09:00:00','13:00:00'),(115,7,'2026-10-17','08:00:00','12:00:00'),(116,8,'2026-10-19','07:30:00','12:30:00'),(117,9,'2026-10-19','10:00:00','15:00:00'),(118,10,'2026-10-19','11:00:00','16:00:00'),(119,7,'2026-10-19','13:30:00','18:30:00'),(120,8,'2026-10-20','08:00:00','13:00:00'),(121,9,'2026-10-20','08:30:00','13:30:00'),(122,10,'2026-10-20','12:30:00','17:30:00'),(123,7,'2026-10-20','13:00:00','18:00:00'),(124,8,'2026-10-21','09:00:00','14:00:00'),(125,9,'2026-10-21','09:30:00','14:30:00'),(126,10,'2026-10-21','12:00:00','17:00:00'),(127,7,'2026-10-21','14:00:00','19:00:00'),(128,8,'2026-10-22','08:30:00','12:30:00'),(129,9,'2026-10-22','09:00:00','13:00:00'),(130,10,'2026-10-22','09:00:00','13:00:00'),(131,7,'2026-10-22','08:00:00','12:00:00'),(132,8,'2026-10-23','08:30:00','13:30:00'),(133,9,'2026-10-23','09:00:00','14:00:00'),(134,10,'2026-10-23','13:00:00','18:00:00'),(135,7,'2026-10-23','12:00:00','17:00:00'),(136,8,'2026-10-24','07:30:00','12:30:00'),(137,9,'2026-10-24','10:00:00','15:00:00'),(138,10,'2026-10-24','11:00:00','16:00:00'),(139,7,'2026-10-24','13:30:00','18:30:00'),(140,8,'2026-10-26','09:00:00','14:00:00'),(141,9,'2026-10-26','09:30:00','14:30:00'),(142,10,'2026-10-26','12:00:00','17:00:00'),(143,7,'2026-10-26','14:00:00','19:00:00'),(144,8,'2026-10-27','08:30:00','12:30:00'),(145,9,'2026-10-27','09:00:00','13:00:00'),(146,10,'2026-10-27','09:00:00','13:00:00'),(147,7,'2026-10-27','08:00:00','12:00:00'),(148,8,'2026-10-28','08:30:00','13:30:00'),(149,9,'2026-10-28','09:00:00','14:00:00'),(150,10,'2026-10-28','13:00:00','18:00:00'),(151,7,'2026-10-28','12:00:00','17:00:00'),(152,8,'2026-10-29','07:30:00','12:30:00'),(153,9,'2026-10-29','10:00:00','15:00:00'),(154,10,'2026-10-29','11:00:00','16:00:00'),(155,7,'2026-10-29','13:30:00','18:30:00'),(156,8,'2026-10-30','08:00:00','13:00:00'),(157,9,'2026-10-30','08:30:00','13:30:00'),(158,10,'2026-10-30','12:30:00','17:30:00'),(159,7,'2026-10-30','13:00:00','18:00:00'),(160,8,'2026-10-31','09:00:00','14:00:00'),(161,9,'2026-10-31','09:30:00','14:30:00'),(162,10,'2026-10-31','12:00:00','17:00:00'),(163,7,'2026-10-31','14:00:00','19:00:00');
/*!40000 ALTER TABLE `horario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registro`
--

DROP TABLE IF EXISTS `registro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registro`
--

LOCK TABLES `registro` WRITE;
/*!40000 ALTER TABLE `registro` DISABLE KEYS */;
INSERT INTO `registro` VALUES (12,7,115,56,1,'2026-10-17T08:56:00-03:00','Llegada tarde','Upps I did It again'),(13,7,115,-183,2,'2026-10-17T08:57:00-03:00','Otros',''),(14,7,115,172,1,'2026-10-17T10:52:00-03:00','Reunión de profesores',',dksjhbsniu'),(15,7,115,-68,2,'2026-10-17T10:52:00-03:00','Cambio de horario',''),(16,8,112,146,1,'2026-10-17T10:56:00-03:00','Cambio de día y horario de coordinación',''),(17,7,139,247,1,'2026-10-24T17:37:00-03:00','Llegada anticipada','');
/*!40000 ALTER TABLE `registro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_Funcionario` int unsigned NOT NULL,
  `hash_password` varchar(255) NOT NULL,
  `rol` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_Funcionario` (`id_Funcionario`),
  CONSTRAINT `fk_usuario_funcionario` FOREIGN KEY (`id_Funcionario`) REFERENCES `funcionario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,1,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',2),(2,2,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',2),(3,3,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',3),(4,4,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',2),(5,5,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',3),(6,6,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',1),(7,7,'pbkdf2_sha256$1000000$78e706ba26abdc84$Lv9yMMM3ntQJbWtr0MTdldzG+mlor16sAz38vK0o0no=',2);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-24 20:48:39
