-- MySQL dump 10.13  Distrib 5.7.17, for osx10.12 (x86_64)
--
-- Host: localhost    Database: prompttherapy
-- ------------------------------------------------------
-- Server version	5.7.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `exerciseCompletions`
--

DROP TABLE IF EXISTS `exerciseCompletions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exerciseCompletions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `painInput` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `exerciseId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `exerciseId` (`exerciseId`),
  CONSTRAINT `exercisecompletions_ibfk_1` FOREIGN KEY (`exerciseId`) REFERENCES `exercises` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exerciseCompletions`
--

LOCK TABLES `exerciseCompletions` WRITE;
/*!40000 ALTER TABLE `exerciseCompletions` DISABLE KEYS */;
/*!40000 ALTER TABLE `exerciseCompletions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exercises`
--

DROP TABLE IF EXISTS `exercises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exercises` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `numRepsOrDuration` int(11) NOT NULL,
  `numSets` int(11) NOT NULL,
  `assignedFrequency` int(11) DEFAULT NULL,
  `assignedDuration` int(11) DEFAULT NULL,
  `dateAssigned` date DEFAULT NULL,
  `ptNotes` text,
  `mediaUrl` varchar(255) DEFAULT NULL,
  `streak` int(11) DEFAULT '0',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `patientId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `patientId` (`patientId`),
  CONSTRAINT `exercises_ibfk_1` FOREIGN KEY (`patientId`) REFERENCES `patients` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercises`
--

LOCK TABLES `exercises` WRITE;
/*!40000 ALTER TABLE `exercises` DISABLE KEYS */;
/*!40000 ALTER TABLE `exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `injuries`
--

DROP TABLE IF EXISTS `injuries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `injuries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `injuryFromSurgery` tinyint(1) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `patientId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `patientId` (`patientId`),
  CONSTRAINT `injuries_ibfk_1` FOREIGN KEY (`patientId`) REFERENCES `patients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `injuries`
--

LOCK TABLES `injuries` WRITE;
/*!40000 ALTER TABLE `injuries` DISABLE KEYS */;
/*!40000 ALTER TABLE `injuries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `hash` varchar(255) NOT NULL,
  `proPicUrl` varchar(255) DEFAULT 'https://s3.amazonaws.com/bodysync-photo-upload/Josh+Seides.jpg',
  `surgeryType` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `surgeonName` varchar(255) DEFAULT NULL,
  `isRestrictedFromRom` tinyint(1) DEFAULT '0',
  `forgotToken` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `weight` int(11) DEFAULT NULL,
  `phoneProvider` varchar(255) DEFAULT NULL,
  `surgeryNotes` text,
  `ptNotes` text,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `ptId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `patients_email_unique` (`email`),
  KEY `ptId` (`ptId`),
  CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`ptId`) REFERENCES `pts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ptSessions`
--

DROP TABLE IF EXISTS `ptSessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ptSessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ptId` int(11) NOT NULL,
  `sessionNumber` int(11) NOT NULL,
  `duration` int(11) DEFAULT NULL,
  `patientId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ptSessions`
--

LOCK TABLES `ptSessions` WRITE;
/*!40000 ALTER TABLE `ptSessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ptSessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pts`
--

DROP TABLE IF EXISTS `pts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `hash` varchar(255) NOT NULL,
  `proPicUrl` varchar(255) DEFAULT 'https://s3.amazonaws.com/bodysync-photo-upload/Josh+Seides.jpg',
  `forgotToken` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `phoneProvider` varchar(255) DEFAULT NULL,
  `isAdmin` tinyint(1) DEFAULT '0',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `pts_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pts`
--

LOCK TABLES `pts` WRITE;
/*!40000 ALTER TABLE `pts` DISABLE KEYS */;
INSERT INTO `pts` VALUES (1,'Prompt Admin','$2a$08$2yDwkwaNfQIK3yD9Hyc72upxGR3eliOfC3OYvHsvtJoDUYOfRpWSe','https://s3.amazonaws.com/bodysync-photo-upload/Josh+Seides.jpg',NULL,'joey@gmail.com',NULL,NULL,NULL,1,'2017-06-18 20:18:03','2017-06-18 20:18:03');
/*!40000 ALTER TABLE `pts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `romMetricMeasures`
--

DROP TABLE IF EXISTS `romMetricMeasures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `romMetricMeasures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `degreeValue` float NOT NULL,
  `nextGoal` float DEFAULT NULL,
  `dayOfNextGoal` date DEFAULT NULL,
  `dayMeasured` date NOT NULL,
  `endRangeGoal` float DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `romMetricId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `romMetricId` (`romMetricId`),
  CONSTRAINT `rommetricmeasures_ibfk_1` FOREIGN KEY (`romMetricId`) REFERENCES `romMetrics` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `romMetricMeasures`
--

LOCK TABLES `romMetricMeasures` WRITE;
/*!40000 ALTER TABLE `romMetricMeasures` DISABLE KEYS */;
/*!40000 ALTER TABLE `romMetricMeasures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `romMetrics`
--

DROP TABLE IF EXISTS `romMetrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `romMetrics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `startRange` float DEFAULT NULL,
  `endRangeGoal` float NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `injuryId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `injuryId` (`injuryId`),
  CONSTRAINT `rommetrics_ibfk_1` FOREIGN KEY (`injuryId`) REFERENCES `injuries` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `romMetrics`
--

LOCK TABLES `romMetrics` WRITE;
/*!40000 ALTER TABLE `romMetrics` DISABLE KEYS */;
/*!40000 ALTER TABLE `romMetrics` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-06-18 20:18:38
