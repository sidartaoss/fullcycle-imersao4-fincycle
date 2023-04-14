-- MySQL dump 10.13  Distrib 5.7.41, for Linux (x86_64)
--
-- Host: localhost    Database: fin
-- ------------------------------------------------------
-- Server version	5.7.41

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
-- Table structure for table `Transactions`
--

DROP TABLE IF EXISTS `Transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transactions`
--

LOCK TABLES `Transactions` WRITE;
/*!40000 ALTER TABLE `Transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `Transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `name` varchar(255) NOT NULL,
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `subdomain` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES ('b026393b-c317-445a-8f46-2c32f5af05af','Account 1',-60.00,'tenant1','2023-02-24 12:26:35','2023-02-28 15:59:15'),('e95eb5c1-a486-4d8b-bc65-ede72bb088a4','Account 1',0.00,'tenant1','2023-02-24 02:02:29','2023-02-24 02:02:29');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `account_id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`),
  CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES ('7734fa62-ee4b-4b92-84d3-b92edfdc2126','2021-09-13 00:00:00','2021-09-14 00:00:00',NULL,'pending','b026393b-c317-445a-8f46-2c32f5af05af','2023-02-28 01:30:11','2023-02-28 01:30:11'),('a92d8139-19d4-4bb4-a847-938cf8b9e906','2021-09-27 00:00:00','2021-09-28 00:00:00','http://localhost:3000','complete','b026393b-c317-445a-8f46-2c32f5af05af','2023-02-28 18:04:50','2023-02-28 19:24:18'),('b6da6d25-cfb9-4830-a54a-0a76f4fd454e','2021-01-01 00:00:00','2021-01-02 00:00:00',NULL,'pending','b026393b-c317-445a-8f46-2c32f5af05af','2023-02-24 19:53:55','2023-02-24 19:53:55');
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transaction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction`
--

LOCK TABLES `transaction` WRITE;
/*!40000 ALTER TABLE `transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transactions` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `payment_date` datetime NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `type` varchar(255) NOT NULL,
  `account_id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES ('1214dae9-2f26-439d-84f9-a826b13f7cd3','2021-01-04 00:00:00','Nova conta 4','Descricao 4','category1',30.00,'debit','b026393b-c317-445a-8f46-2c32f5af05af','2023-02-27 14:10:32','2023-02-27 14:10:32'),('329caaab-720b-4fb4-98de-bd67b72b8084','2021-01-02 00:00:00','Nova conta 2','Descricao 2','category1',30.00,'debit','b026393b-c317-445a-8f46-2c32f5af05af','2023-02-24 16:02:29','2023-02-24 16:02:29'),('50667260-f117-4ae3-839b-fef08681afc1','2021-01-05 00:00:00','Nova conta 5','Descricao 5','category1',30.00,'debit','b026393b-c317-445a-8f46-2c32f5af05af','2023-02-28 15:59:15','2023-02-28 15:59:15'),('5dd74ee9-c62e-4c6e-aed8-83484339adb4','2021-01-03 00:00:00','Nova conta 3','Descricao 3','category1',30.00,'debit','b026393b-c317-445a-8f46-2c32f5af05af','2023-02-27 14:05:12','2023-02-27 14:05:12'),('6aa375b5-b495-4d65-aae0-9746b29665c4','2021-01-03 00:00:00','Nova conta 3','Descricao 3','category1',30.00,'debit','b026393b-c317-445a-8f46-2c32f5af05af','2023-02-27 14:06:07','2023-02-27 14:06:07'),('bf6ed3d4-eaf9-45db-b2f8-4f8a11a6ed17','2023-02-02 00:00:00','Sidarta','SSS SSSSS','category1',7777.00,'debit','b026393b-c317-445a-8f46-2c32f5af05af','2023-02-27 05:39:46','2023-02-27 05:39:46');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-02-28 22:54:04
