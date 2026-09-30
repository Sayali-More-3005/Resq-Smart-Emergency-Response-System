-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: resq_db
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `ai_models`
--

DROP TABLE IF EXISTS `ai_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_models` (
  `model_id` int NOT NULL AUTO_INCREMENT,
  `model_name` varchar(100) NOT NULL,
  `algorithm` varchar(100) NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `accuracy` decimal(6,4) DEFAULT NULL,
  `precision_score` decimal(6,4) DEFAULT NULL,
  `recall_score` decimal(6,4) DEFAULT NULL,
  `f1_score` decimal(6,4) DEFAULT NULL,
  `is_selected` tinyint(1) DEFAULT '0',
  `model_file_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`model_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_models`
--

LOCK TABLES `ai_models` WRITE;
/*!40000 ALTER TABLE `ai_models` DISABLE KEYS */;
INSERT INTO `ai_models` VALUES (1,'ResQ Random Forest','Random Forest','1.0',NULL,NULL,NULL,NULL,0,NULL,'2026-09-11 14:25:52'),(2,'ResQ Decision Tree','Decision Tree','1.0',NULL,NULL,NULL,NULL,0,NULL,'2026-09-11 14:25:52'),(3,'ResQ XGBoost','XGBoost','1.0',NULL,NULL,NULL,NULL,0,NULL,'2026-09-11 14:25:52');
/*!40000 ALTER TABLE `ai_models` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_predictions`
--

DROP TABLE IF EXISTS `ai_predictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_predictions` (
  `prediction_id` int NOT NULL AUTO_INCREMENT,
  `incident_id` int NOT NULL,
  `model_id` int DEFAULT NULL,
  `model_name` varchar(100) NOT NULL,
  `predicted_type` varchar(100) DEFAULT NULL,
  `predicted_severity` varchar(50) DEFAULT NULL,
  `confidence` decimal(5,4) DEFAULT NULL,
  `feature_importance` text,
  `xai_method` enum('SHAP','LIME','NONE') DEFAULT 'NONE',
  `explanation` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`prediction_id`),
  KEY `incident_id` (`incident_id`),
  KEY `model_id` (`model_id`),
  CONSTRAINT `ai_predictions_ibfk_1` FOREIGN KEY (`incident_id`) REFERENCES `emergency_incidents` (`incident_id`) ON DELETE CASCADE,
  CONSTRAINT `ai_predictions_ibfk_2` FOREIGN KEY (`model_id`) REFERENCES `ai_models` (`model_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_predictions`
--

LOCK TABLES `ai_predictions` WRITE;
/*!40000 ALTER TABLE `ai_predictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_predictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerts` (
  `alert_id` int NOT NULL AUTO_INCREMENT,
  `incident_id` int NOT NULL,
  `department_id` int NOT NULL,
  `alert_type` enum('NEW_INCIDENT','UPDATE','ESCALATION') DEFAULT 'NEW_INCIDENT',
  `alert_message` text,
  `status` enum('PENDING','SENT','ACKNOWLEDGED','CLOSED') DEFAULT 'PENDING',
  `sent_at` timestamp NULL DEFAULT NULL,
  `acknowledged_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`alert_id`),
  KEY `incident_id` (`incident_id`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `alerts_ibfk_1` FOREIGN KEY (`incident_id`) REFERENCES `emergency_incidents` (`incident_id`) ON DELETE CASCADE,
  CONSTRAINT `alerts_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts`
--

LOCK TABLES `alerts` WRITE;
/*!40000 ALTER TABLE `alerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bystander_requests`
--

DROP TABLE IF EXISTS `bystander_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bystander_requests` (
  `bystander_request_id` int NOT NULL AUTO_INCREMENT,
  `incident_id` int NOT NULL,
  `bystander_name` varchar(100) DEFAULT NULL,
  `bystander_phone` varchar(15) DEFAULT NULL,
  `request_source` enum('LOCK_SCREEN','BYSTANDER') DEFAULT 'BYSTANDER',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bystander_request_id`),
  KEY `incident_id` (`incident_id`),
  CONSTRAINT `bystander_requests_ibfk_1` FOREIGN KEY (`incident_id`) REFERENCES `emergency_incidents` (`incident_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bystander_requests`
--

LOCK TABLES `bystander_requests` WRITE;
/*!40000 ALTER TABLE `bystander_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `bystander_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `department_id` int NOT NULL AUTO_INCREMENT,
  `department_name` varchar(100) NOT NULL,
  `department_type` enum('POLICE','MEDICAL','FIRE','DISASTER') NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'Police Department','POLICE','112','police@resq.local','Main City',1,'2026-09-11 14:25:52'),(2,'Medical Emergency Department','MEDICAL','108','medical@resq.local','Main City',1,'2026-09-11 14:25:52'),(3,'Fire & Rescue Department','FIRE','101','fire@resq.local','Main City',1,'2026-09-11 14:25:52'),(4,'Disaster Management & Rescue Department','DISASTER','1070','disaster@resq.local','Main City',1,'2026-09-11 14:25:52');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emergency_contacts`
--

DROP TABLE IF EXISTS `emergency_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emergency_contacts` (
  `contact_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `contact_name` varchar(100) NOT NULL,
  `relationship` varchar(50) DEFAULT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `is_primary` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`contact_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `emergency_contacts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emergency_contacts`
--

LOCK TABLES `emergency_contacts` WRITE;
/*!40000 ALTER TABLE `emergency_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `emergency_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emergency_incidents`
--

DROP TABLE IF EXISTS `emergency_incidents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emergency_incidents` (
  `incident_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `emergency_type` varchar(100) DEFAULT NULL,
  `description` text,
  `smoke_detected` tinyint(1) DEFAULT '0',
  `temperature` decimal(6,2) DEFAULT NULL,
  `gas_leak` tinyint(1) DEFAULT '0',
  `people_affected` int DEFAULT '0',
  `injured_people` int DEFAULT '0',
  `accident_detected` tinyint(1) DEFAULT '0',
  `crime_detected` tinyint(1) DEFAULT '0',
  `flood_detected` tinyint(1) DEFAULT '0',
  `building_collapse` tinyint(1) DEFAULT '0',
  `severity` enum('LOW','MEDIUM','HIGH','CRITICAL') DEFAULT 'MEDIUM',
  `status` enum('CREATED','CLASSIFIED','DISPATCHED','ACCEPTED','RESPONDING','ARRIVED','RESOLVED','CANCELLED') DEFAULT 'CREATED',
  `request_source` enum('CITIZEN_APP','WRITTEN_REPORT','LOCK_SCREEN','BYSTANDER','VOICE','SHAKE') DEFAULT 'CITIZEN_APP',
  `sos_cancelled` tinyint(1) DEFAULT '0',
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`incident_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `emergency_incidents_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emergency_incidents`
--

LOCK TABLES `emergency_incidents` WRITE;
/*!40000 ALTER TABLE `emergency_incidents` DISABLE KEYS */;
/*!40000 ALTER TABLE `emergency_incidents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incident_departments`
--

DROP TABLE IF EXISTS `incident_departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incident_departments` (
  `incident_department_id` int NOT NULL AUTO_INCREMENT,
  `incident_id` int NOT NULL,
  `department_id` int NOT NULL,
  `priority` enum('LOW','MEDIUM','HIGH','CRITICAL') DEFAULT 'MEDIUM',
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`incident_department_id`),
  UNIQUE KEY `incident_id` (`incident_id`,`department_id`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `incident_departments_ibfk_1` FOREIGN KEY (`incident_id`) REFERENCES `emergency_incidents` (`incident_id`) ON DELETE CASCADE,
  CONSTRAINT `incident_departments_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incident_departments`
--

LOCK TABLES `incident_departments` WRITE;
/*!40000 ALTER TABLE `incident_departments` DISABLE KEYS */;
/*!40000 ALTER TABLE `incident_departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incident_locations`
--

DROP TABLE IF EXISTS `incident_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incident_locations` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `incident_id` int NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `recorded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`location_id`),
  KEY `incident_id` (`incident_id`),
  CONSTRAINT `incident_locations_ibfk_1` FOREIGN KEY (`incident_id`) REFERENCES `emergency_incidents` (`incident_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incident_locations`
--

LOCK TABLES `incident_locations` WRITE;
/*!40000 ALTER TABLE `incident_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `incident_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incident_reports`
--

DROP TABLE IF EXISTS `incident_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incident_reports` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `incident_id` int NOT NULL,
  `prepared_by` int DEFAULT NULL,
  `summary` text,
  `actions_taken` text,
  `casualties` int DEFAULT '0',
  `resources_used` text,
  `report_status` enum('DRAFT','FINAL') DEFAULT 'DRAFT',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`report_id`),
  KEY `incident_id` (`incident_id`),
  KEY `prepared_by` (`prepared_by`),
  CONSTRAINT `incident_reports_ibfk_1` FOREIGN KEY (`incident_id`) REFERENCES `emergency_incidents` (`incident_id`) ON DELETE CASCADE,
  CONSTRAINT `incident_reports_ibfk_2` FOREIGN KEY (`prepared_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incident_reports`
--

LOCK TABLES `incident_reports` WRITE;
/*!40000 ALTER TABLE `incident_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `incident_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incident_status_history`
--

DROP TABLE IF EXISTS `incident_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incident_status_history` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `incident_id` int NOT NULL,
  `old_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  `remarks` text,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `incident_id` (`incident_id`),
  KEY `changed_by` (`changed_by`),
  CONSTRAINT `incident_status_history_ibfk_1` FOREIGN KEY (`incident_id`) REFERENCES `emergency_incidents` (`incident_id`) ON DELETE CASCADE,
  CONSTRAINT `incident_status_history_ibfk_2` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incident_status_history`
--

LOCK TABLES `incident_status_history` WRITE;
/*!40000 ALTER TABLE `incident_status_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `incident_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `incident_id` int DEFAULT NULL,
  `sender_user_id` int DEFAULT NULL,
  `receiver_user_id` int DEFAULT NULL,
  `notification_type` enum('DEPARTMENT_ALERT','CITIZEN_UPDATE','TRUSTED_CONTACT','EMERGENCY_UPDATE','SYSTEM') NOT NULL,
  `title` varchar(150) DEFAULT NULL,
  `message` text,
  `status` enum('PENDING','SENT','READ') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `read_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `incident_id` (`incident_id`),
  KEY `sender_user_id` (`sender_user_id`),
  KEY `receiver_user_id` (`receiver_user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`incident_id`) REFERENCES `emergency_incidents` (`incident_id`) ON DELETE CASCADE,
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `notifications_ibfk_3` FOREIGN KEY (`receiver_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `response_status`
--

DROP TABLE IF EXISTS `response_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `response_status` (
  `response_id` int NOT NULL AUTO_INCREMENT,
  `incident_id` int NOT NULL,
  `department_id` int NOT NULL,
  `responder_id` int DEFAULT NULL,
  `status` enum('ASSIGNED','ACCEPTED','DISPATCHED','ON_THE_WAY','ARRIVED','COMPLETED') DEFAULT 'ASSIGNED',
  `notes` text,
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`response_id`),
  KEY `incident_id` (`incident_id`),
  KEY `department_id` (`department_id`),
  KEY `responder_id` (`responder_id`),
  CONSTRAINT `response_status_ibfk_1` FOREIGN KEY (`incident_id`) REFERENCES `emergency_incidents` (`incident_id`) ON DELETE CASCADE,
  CONSTRAINT `response_status_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE CASCADE,
  CONSTRAINT `response_status_ibfk_3` FOREIGN KEY (`responder_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `response_status`
--

LOCK TABLES `response_status` WRITE;
/*!40000 ALTER TABLE `response_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `response_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_emergency_profiles`
--

DROP TABLE IF EXISTS `user_emergency_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_emergency_profiles` (
  `profile_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `blood_group` varchar(10) DEFAULT NULL,
  `allergies` text,
  `medical_conditions` text,
  `medications` text,
  `emergency_notes` text,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`profile_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `user_emergency_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_emergency_profiles`
--

LOCK TABLES `user_emergency_profiles` WRITE;
/*!40000 ALTER TABLE `user_emergency_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_emergency_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('CITIZEN','RESPONDER','ADMIN') NOT NULL DEFAULT 'CITIZEN',
  `department_id` int DEFAULT NULL,
  `account_status` enum('ACTIVE','INACTIVE','BLOCKED') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-29 22:51:42
