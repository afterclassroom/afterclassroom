-- MySQL dump 10.11
--
-- Host: localhost    Database: wwwafte_afterclassroom
-- ------------------------------------------------------
-- Server version	5.0.67-community

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
-- Table structure for table `activities`
--

DROP TABLE IF EXISTS `activities`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `activities` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `action` varchar(50) default NULL,
  `item_id` int(11) default NULL,
  `item_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `activities`
--

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
INSERT INTO `activities` VALUES (1,6,'post',1,'Post','2009-04-02 04:17:33'),(2,4,'post',2,'Post','2009-04-02 07:43:51'),(3,4,'post',3,'Post','2009-04-02 08:03:30'),(4,4,'post',4,'Post','2009-04-02 08:09:49'),(5,4,'post',5,'Post','2009-04-02 08:14:49'),(6,4,'post',6,'Post','2009-04-02 08:16:49'),(7,4,'post',7,'Post','2009-04-02 08:20:39'),(8,4,'post',8,'Post','2009-04-02 08:22:14'),(9,4,'post',9,'Post','2009-04-02 08:28:21'),(10,4,'post',10,'Post','2009-04-02 08:36:39'),(11,4,'post',11,'Post','2009-04-02 08:38:37'),(12,4,'post',12,'Post','2009-04-02 08:55:16'),(13,4,'post',13,'Post','2009-04-02 09:08:11'),(14,4,'post',14,'Post','2009-04-02 09:17:29'),(15,4,'post',15,'Post','2009-04-02 09:24:20'),(16,4,'post',16,'Post','2009-04-02 09:42:23'),(17,4,'post',17,'Post','2009-04-02 09:52:13'),(18,4,'post',18,'Post','2009-04-03 01:57:56'),(19,4,'post',19,'Post','2009-04-03 02:10:14'),(20,6,'post',20,'Post','2009-04-03 02:14:49'),(21,4,'post',21,'Post','2009-04-03 02:16:39'),(22,6,'post',22,'Post','2009-04-03 02:21:53'),(23,4,'post',23,'Post','2009-04-03 02:22:47'),(25,6,'post',25,'Post','2009-04-03 02:32:48'),(26,4,'post',26,'Post','2009-04-03 02:37:11'),(27,4,'post',27,'Post','2009-04-03 02:45:39'),(28,4,'post',28,'Post','2009-04-03 02:50:25'),(29,4,'post',29,'Post','2009-04-03 02:55:06'),(30,4,'post',30,'Post','2009-04-03 09:24:17'),(31,4,'post',31,'Post','2009-04-03 09:27:58'),(32,4,'post',32,'Post','2009-04-04 01:46:21'),(33,4,'post',33,'Post','2009-04-04 01:52:05'),(34,4,'post',34,'Post','2009-04-04 01:54:33'),(35,4,'post',35,'Post','2009-04-04 02:01:43'),(36,4,'post',36,'Post','2009-04-04 02:08:38'),(37,4,'post',37,'Post','2009-04-04 02:12:47'),(38,4,'post',38,'Post','2009-04-04 02:16:44'),(39,4,'post',39,'Post','2009-04-04 02:20:06'),(40,4,'post',40,'Post','2009-04-04 02:51:09'),(41,4,'post',41,'Post','2009-04-04 02:56:20'),(42,4,'post',42,'Post','2009-04-04 03:06:26'),(43,4,'post',43,'Post','2009-04-04 03:23:46'),(44,4,'post',44,'Post','2009-04-04 03:28:32'),(45,4,'post',45,'Post','2009-04-04 03:32:37'),(46,4,'post',46,'Post','2009-04-04 03:36:57'),(47,4,'post',47,'Post','2009-04-04 03:43:15'),(48,4,'post',48,'Post','2009-04-04 03:47:12'),(49,4,'post',49,'Post','2009-04-04 03:59:10'),(50,4,'post',50,'Post','2009-04-04 04:00:49'),(51,4,'photo',1,'Photo','2009-04-04 06:57:54'),(52,4,'photo',2,'Photo','2009-04-04 06:59:50'),(53,4,'photo',3,'Photo','2009-04-04 07:01:11'),(54,4,'photo',4,'Photo','2009-04-04 07:19:14'),(55,4,'music',1,'Music','2009-04-04 07:23:34'),(56,4,'music',2,'Music','2009-04-04 07:26:46'),(57,4,'music',3,'Music','2009-04-04 07:32:14'),(58,4,'video',1,'Video','2009-04-04 07:35:18'),(59,4,'video',2,'Video','2009-04-04 07:36:14'),(60,4,'video',3,'Video','2009-04-04 07:40:09'),(61,4,'story',1,'Story','2009-04-04 07:42:09'),(62,4,'updated_avatar',NULL,NULL,'2009-04-04 07:50:30'),(63,8,'post',51,'Post','2009-04-04 20:49:34'),(64,6,'updated_avatar',NULL,NULL,'2009-04-07 01:44:58'),(65,6,'story',2,'Story','2009-04-09 02:48:06'),(66,6,'story',3,'Story','2009-04-09 02:56:41'),(67,1,'story',4,'Story','2009-04-13 20:21:21'),(68,1,'updated_profile',NULL,NULL,'2009-04-15 02:40:08'),(69,1,'post',52,'Post','2009-04-21 04:59:58'),(70,6,'photo',5,'Photo','2009-04-22 01:53:27'),(71,1,'story',5,'Story','2009-04-24 21:20:25');
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `awareness_issues`
--

DROP TABLE IF EXISTS `awareness_issues`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `awareness_issues` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `awareness_issues`
--

LOCK TABLES `awareness_issues` WRITE;
/*!40000 ALTER TABLE `awareness_issues` DISABLE KEYS */;
INSERT INTO `awareness_issues` VALUES (1,'Issue 1'),(2,'Issue 2'),(3,'Issue 3'),(4,'Issue 4'),(5,'Issue 5'),(6,'Issue 6'),(7,'Issue 7'),(8,'Issue 8'),(9,'Issue 9'),(10,'Issue 10');
/*!40000 ALTER TABLE `awareness_issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `awareness_issues_post_awarenesses`
--

DROP TABLE IF EXISTS `awareness_issues_post_awarenesses`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `awareness_issues_post_awarenesses` (
  `post_awareness_id` int(11) NOT NULL,
  `awareness_issue_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `awareness_issues_post_awarenesses`
--

LOCK TABLES `awareness_issues_post_awarenesses` WRITE;
/*!40000 ALTER TABLE `awareness_issues_post_awarenesses` DISABLE KEYS */;
INSERT INTO `awareness_issues_post_awarenesses` VALUES (1,1),(2,2),(3,1);
/*!40000 ALTER TABLE `awareness_issues_post_awarenesses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cities` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `state_id` int(11) NOT NULL,
  `country_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=612 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `cities`
--

LOCK TABLES `cities` WRITE;
/*!40000 ALTER TABLE `cities` DISABLE KEYS */;
INSERT INTO `cities` VALUES (1,'Montgomery',1,214),(2,'Nomal',1,214),(3,'Athens',1,214),(4,'Auburn',1,214),(5,'Birmingham',1,214),(6,'Selma',1,214),(7,'Jacksonville',1,214),(8,'Marion',1,214),(9,'Fairfield',1,214),(10,'Huntsville',1,214),(11,'Mobile',1,214),(12,'Tuscaloosa',1,214),(13,'Talladega',1,214),(14,'Troy',1,214),(15,'Midland',1,214),(16,'Tuskegee',1,214),(17,'Daphne',1,214),(18,'Montevallo',1,214),(19,'Florence',1,214),(20,'Livingston',1,214),(21,'Glennallen',2,214),(22,'Anchorage',2,214),(23,'Fairbanks',2,214),(24,'Juneau',2,214),(25,'Mesa',3,214),(26,'Phoenix',3,214),(27,'Tempe',3,214),(28,'Tucson',3,214),(29,'Prescott',3,214),(30,'Prescott Valley',3,214),(31,'Flagstaff',3,214),(32,'Little Rock',4,214),(33,'Jonesboro',4,214),(34,'Russellville',4,214),(35,'Conway',4,214),(36,'Searcy',4,214),(37,'Arkadelphia',4,214),(38,'Siloam Springs',4,214),(39,'Batesville',4,214),(40,'Magnolia',4,214),(41,'Fayetteville',4,214),(42,'Fort',4,214),(43,'Monticello',4,214),(44,'Pine Bluff',4,214),(45,'Clarksville',4,214),(46,'Walnut Ridge',4,214),(47,'San Diego',5,214),(48,'Culver',5,214),(49,'Pasadena',5,214),(50,'Azusa',5,214),(51,'Scotts Valley',5,214),(52,'Anaheim',5,214),(53,'La Mirada',5,214),(54,'Riverside',5,214),(55,'San Francisco',5,214),(56,'Valencia',5,214),(57,'Thousand Oaks',5,214),(58,'Escondido',5,214),(59,'Long Beach',5,214),(60,'Bakersfield',5,214),(61,'Vallejo',5,214),(62,'San Luis Obispo',5,214),(63,'Pomona',5,214),(64,'Camarillo',5,214),(65,'Chico',5,214),(66,'Carson',5,214),(67,'Hayward',5,214),(68,'Fresno',5,214),(69,'Fullerton',5,214),(70,'Northridge',5,214),(71,'Sacramento',5,214),(72,'San Bernardino',5,214),(73,'San Marcos',5,214),(74,'Arcata',5,214),(75,'San Jose',5,214),(76,'Rohnert Park',5,214),(77,'Orange',5,214),(78,'Los Angeles',5,214),(79,'Berkeley',5,214),(80,'Clatemont',5,214),(81,'Claremont',5,214),(82,'Sunnyvale',5,214),(83,'Irvine',5,214),(84,'San Rafael',5,214),(85,'Santa Barbara',5,214),(86,'Oakland',5,214),(87,'Stockton',5,214),(88,'Palo Alto',5,214),(89,'San Dimas',5,214),(90,'Loma Linda',5,214),(91,'Rancho Palos Verdes',5,214),(92,'Santa Clarita',5,214),(93,'Atherton',5,214),(94,'Monterey',5,214),(95,'Belmont',5,214),(96,'Angwin',5,214),(97,'Carpinteria',5,214),(98,'Santa Monica',5,214),(99,'Moraga',5,214),(100,'El Cajon',5,214),(101,'Santa Clara',5,214),(102,'Redding',5,214),(103,'Aliso Viejo',5,214),(104,'Stanford',5,214),(105,'Santa Paula',5,214),(106,'Davis',5,214),(107,'Merced',5,214),(108,'La Jolla',5,214),(109,'Santa Cruz',5,214),(110,'La Verne',5,214),(111,'Santa Rosa',5,214),(112,'Redlands',5,214),(113,'Costa Mesa',5,214),(114,'Montecito',5,214),(115,'Whittier',5,214),(116,'Santa Ana',5,214),(117,'Rocklin',5,214),(118,'Burbank',5,214),(119,'Alamosa',6,214),(120,'Denver',6,214),(121,'Greenwood Vlg',6,214),(122,'Lakewood',6,214),(123,'Colorado Springs',6,214),(124,'Golden',6,214),(125,'Fort Collins',6,214),(126,'Pueblo',6,214),(127,'Littleton',6,214),(128,'Durango',6,214),(129,'Centennial',6,214),(130,'Grand Junction',6,214),(131,'Boulder',6,214),(132,'Greeley',6,214),(133,'Gunnison',6,214),(134,'New Haven',7,214),(135,'New Britain',7,214),(136,'Waterbury',7,214),(137,'New London',7,214),(138,'Fairfield',7,214),(139,'Hartford',7,214),(140,'Cromwell',7,214),(141,'Hamburg',7,214),(142,'Hamden',7,214),(143,'West Hartford',7,214),(144,'NewHaven',7,214),(145,'Bridgeport',7,214),(146,'Storrs',7,214),(147,'West Haven',7,214),(148,'Middletown',7,214),(149,'Danbury',7,214),(150,'Dover',8,214),(151,'Wilmington',8,214),(152,'Newark',8,214),(153,'New Castle',8,214),(154,'Washington',9,214),(155,'Graceville',10,214),(156,'Miami',10,214),(157,'Leesburg',10,214),(158,'Daytona Beach',10,214),(159,'Doral',10,214),(160,'Marianna',10,214),(161,'Clearwater',10,214),(162,'Orlando',10,214),(163,'St Petersburg',10,214),(164,'Fort Myers',10,214),(165,'Jacksonville',10,214),(166,'St Augustine',10,214),(167,'Tampa',10,214),(168,'Boca Raton',10,214),(169,'Kissimmee',10,214),(170,'Temple Terrace',10,214),(171,'Punta Gorda',10,214),(172,'Melbourne',10,214),(173,'Tallahassee',10,214),(174,'Panama',10,214),(175,'Hobe Sound',10,214),(176,'Naples',10,214),(177,'Sarasota',10,214),(178,'West Palm Beach',10,214),(179,'Davie',10,214),(180,'Winter Park',10,214),(181,'St Leo',10,214),(182,'Seminole',10,214),(183,'Opa Locka',10,214),(184,'Boynton Beach',10,214),(185,'Deerfield Beach',10,214),(186,'Lakeland',10,214),(187,'Deland',10,214),(188,'Trinity',10,214),(189,'Hurlburt Field',10,214),(190,'Gainesville',10,214),(191,'Coral Gables',10,214),(192,'Petersburg',10,214),(193,'Pensacola',10,214),(194,'Lake Wales',10,214),(195,'Babson Park',10,214),(196,'Laie',12,214),(197,'Honolulu',12,214),(198,'Hilo',12,214),(199,'Pearl ',12,214),(200,'Boise',13,214),(201,'Rexburg',13,214),(202,'Caldwell',13,214),(203,'Pocatello',13,214),(204,'Lewiston',13,214),(205,'Nampa',13,214),(206,'Moscow',13,214),(207,'Chicago',14,214),(208,'Schaumburg',14,214),(209,'Rock Island',14,214),(210,'Aurora',14,214),(211,'Lisle',14,214),(212,'Carlinville',14,214),(213,'Quincy',14,214),(214,'Peoria',14,214),(215,'River Forest',14,214),(216,'Addison',14,214),(217,'Charleston',14,214),(218,'Elmhurst',14,214),(219,'Eureka',14,214),(220,'Evanston',14,214),(221,'University Park',14,214),(222,'Greenville',14,214),(223,'Skokie',14,214),(224,'Jacksonville',14,214),(225,'Normal',14,214),(226,'Bloomington',14,214),(227,'Elgin',14,214),(228,'Galesburg',14,214),(229,'Lincolnshire Woods',14,214),(230,'Lake Forest',14,214),(231,'Danville',14,214),(232,'Romeoville',14,214),(233,'Lincoln',14,214),(234,'Lebanon',14,214),(235,'Downers Grove',14,214),(236,'Decatur',14,214),(237,'Monmouth',14,214),(238,'Lombard',14,214),(239,'Naperville',14,214),(240,'Dekalb',14,214),(241,'Bourbonnais',14,214),(242,'Elsah',14,214),(243,'Orland Park',14,214),(244,'Rockford',14,214),(245,'North Chicago',14,214),(246,'Springfield',14,214),(247,'Waukegan',14,214),(248,'Carbondale',14,214),(249,'Edwardsville',14,214),(250,'Palos Heights',14,214),(251,'Bannockburn',14,214),(252,'Urbana',14,214),(253,'Joliet',14,214),(254,'Oak Park',14,214),(255,'Wheaton',14,214),(256,'Waterloo',16,214),(257,'Clinton',16,214),(258,'Algona',16,214),(259,'Newton',16,214),(260,'Pella',16,214),(261,'Dubuque',16,214),(262,'Cedar Rapids',16,214),(263,'Mount Vernon',16,214),(264,'Des Moines',16,214),(265,'Epworth',16,214),(266,'Sioux Center',16,214),(267,'Ankeny',16,214),(268,'Lamoni',16,214),(269,'Grinnell',16,214),(270,'Ames',16,214),(271,'Mt Pleasant',16,214),(272,'Omaha',16,214),(273,'Decorah',16,214),(274,'Fairfield',16,214),(275,'Sioux',16,214),(276,'Orange',16,214),(277,'Davenport',16,214),(278,'Indianola',16,214),(279,'Iowa ',16,214),(280,'Cedar Falls',16,214),(281,'Forest ',16,214),(282,'Waverly',16,214),(283,'Oskaloosa',16,214),(284,'Baldwin ',17,214),(285,'Atchison',17,214),(286,'Lindsborg',17,214),(287,'North Newton',17,214),(288,'Shawnee',17,214),(289,'McPherson',17,214),(290,'Kansas ',17,214),(291,'Hays',17,214),(292,'Wichita',17,214),(293,'Lawrence',17,214),(294,'Manhattan',17,214),(295,'Salina',17,214),(296,'Olathe',17,214),(297,'Ottawa',17,214),(298,'Pittsburg',17,214),(299,'Winfield',17,214),(300,'Sterling',17,214),(301,'Hillsboro',17,214),(302,'Ft. Leavenworth',17,214),(303,'Leavenworth',17,214),(304,'Topeka',17,214),(305,'Pippa Passes',18,214),(306,'Wilmore',18,214),(307,'Louisville',18,214),(308,'Berea',18,214),(309,'Owensboro',18,214),(310,'Campbellsville',18,214),(311,'Danville',18,214),(312,'Pineville',18,214),(313,'Richmond',18,214),(314,'Georgetown',18,214),(315,'Grayson',18,214),(316,'Jackson',18,214),(317,'Frankfort',18,214),(318,'Lexington',18,214),(319,'Columbia',18,214),(320,'Russellville',18,214),(321,'Midway',18,214),(322,'Morehead',18,214),(323,'Murray',18,214),(324,'Highland Heights',18,214),(325,'Pikeville',18,214),(326,'St Catharine',18,214),(327,'Crestview Hills',18,214),(328,'Barbourville',18,214),(329,'Williamsburg',18,214),(330,'Bowling Green',18,214),(331,'Shreveport',19,214),(332,'New Orleans',19,214),(333,'Grambling',19,214),(334,'Pineville',19,214),(335,'Baton Rouge',19,214),(336,'Alexandria',19,214),(337,'Ruston',19,214),(338,'Lake Charles',19,214),(339,'Thibodaux',19,214),(340,'Natchitoches',19,214),(341,'Hammond',19,214),(342,'Monroe',19,214),(343,'Lafayette',19,214),(344,'Baltimore',21,214),(345,'Bowie',21,214),(346,'Laurel',21,214),(347,'Wye Mills',21,214),(348,'Takoma Park',21,214),(349,'Frostburg',21,214),(350,'Frederick',21,214),(351,'Westminster',21,214),(352,'Emmitsburg',21,214),(353,'Silver Spring',21,214),(354,'Annapolis',21,214),(355,'Maryland',21,214),(356,'Salisbury',21,214),(357,'Towson',21,214),(358,'Bethesda',21,214),(359,'College Park',21,214),(360,'Princess Anne',21,214),(361,'Chestertown',21,214),(362,'Stevenson',21,214),(363,'Lewiston',20,214),(364,'Brunswick',20,214),(365,'Waterville',20,214),(366,'Bar Harbor',20,214),(367,'Bangor',20,214),(368,'Portland',20,214),(369,'Castine',20,214),(370,'Maine ',20,214),(371,'Unity',20,214),(372,'Augusta',20,214),(373,'Farmington',20,214),(374,'Fort Kent',20,214),(375,'Machias',20,214),(376,'Orono',20,214),(377,'Presque Isle',20,214),(378,'Springfield',22,214),(379,'Amherst',22,214),(380,'Newton',22,214),(381,'Paxton',22,214),(382,'Worcester',22,214),(383,'Lancaster',22,214),(384,'Babson Park',22,214),(385,'Longmeadow',22,214),(386,'Leicester',22,214),(387,'Boston',22,214),(388,'Waltham',22,214),(389,'Chestnut Hill',22,214),(390,'Brookline',22,214),(391,'Bridgewater',22,214),(392,'Cambridge',22,214),(393,'Quincy',22,214),(394,'Chicopee',22,214),(395,'Beverly',22,214),(396,'Fitchburg',22,214),(397,'Framingham',22,214),(398,'Wenham',22,214),(399,'South Hamilton',22,214),(400,'Petersham',22,214),(401,'Brighton',22,214),(402,'Auburndale',22,214),(403,'North Adams',22,214),(404,'Buzzards Bay',22,214),(405,'West Roxbury',22,214),(406,'Andover',22,214),(407,'South Hadley',22,214),(408,'Southborough',22,214),(409,'Weston',22,214),(410,'Salem',22,214),(411,'Great Barrington',22,214),(412,'Northampton',22,214),(413,'Easton',22,214),(414,'North Dartmouth',22,214),(415,'Lowell',22,214),(416,'Wellesley',22,214),(417,'Norton',22,214),(418,'Williamstown',22,214),(419,'Richfield',24,214),(420,'Minneapolis',24,214),(421,'Mankato',24,214),(422,'Saint Paul',24,214),(423,'Northfield',24,214),(424,'St. Joseph',24,214),(425,'Duluth',24,214),(426,'St Paul',24,214),(427,'Moorhead',24,214),(428,'Rochester',24,214),(429,'St. Bonifacius',24,214),(430,'Saint Peter',24,214),(431,'Center City',24,214),(432,'St. Paul',24,214),(433,'New Ulm',24,214),(434,'Bemidji',24,214),(435,'Marshall',24,214),(436,'Saint Cloud',24,214),(437,'Winona',24,214),(438,'Roseville',24,214),(439,'Bloomington',24,214),(440,'Owatonna',24,214),(441,'Lake Elmo',24,214),(442,'Collegeville',24,214),(443,'Crookston',24,214),(444,'Morris',24,214),(445,'Kirksville',26,214),(446,'St Louis',26,214),(447,'Springfield',26,214),(448,'Kansas',26,214),(449,'Moberly',26,214),(450,'Fayette',26,214),(451,'Point Lookout',26,214),(452,'Rolla',26,214),(453,'Conception',26,214),(454,'St. Louis',26,214),(455,'Canton',26,214),(456,'Webster Groves',26,214),(457,'Clayton',26,214),(458,'Saint Louis',26,214),(459,'Hannibal',26,214),(460,'Jefferson ',26,214),(461,'St Charles',26,214),(462,'Chesterfield',26,214),(463,'Fenton',26,214),(464,'Creve Coeur',26,214),(465,'Joplin',26,214),(466,'Marshall',26,214),(467,'St Joseph',26,214),(468,'Maryville',26,214),(469,'Parkville',26,214),(470,'Cape Girardeau',26,214),(471,'Bolivar',26,214),(472,'Columbia',26,214),(473,'Warrensburg',26,214),(474,'Fulton',26,214),(475,'Liberty',26,214),(476,'Keene',30,214),(477,'Chester',30,214),(478,'New London',30,214),(479,'Nashua',30,214),(480,'Hanover',30,214),(481,'Manchester',30,214),(482,'Concord',30,214),(483,'Henniker',30,214),(484,'Plymouth',30,214),(485,'Durham',30,214),(486,'Ely',29,214),(487,'Incline Village',29,214),(488,'Las Vegas',29,214),(489,'Reno',29,214),(490,'Santa Fe',32,214),(491,'Portales',32,214),(492,'Socorro',32,214),(493,'Rio Rancho',32,214),(494,'Albuquerque',32,214),(495,'Hobbs',32,214),(496,'Silver ',32,214),(497,'Woodbridge',31,214),(498,'Bloomfield',31,214),(499,'Caldwell',31,214),(500,'Hackettstown',31,214),(501,'Trenton',31,214),(502,'Morristown',31,214),(503,'Madison',31,214),(504,'Lodi',31,214),(505,'Lakewood',31,214),(506,'Union',31,214),(507,'West Long Branch',31,214),(508,'Montclair',31,214),(509,'Jersey ',31,214),(510,'Newark',31,214),(511,'Princeton',31,214),(512,'Mahwah',31,214),(513,'Pomona',31,214),(514,'Glassboro',31,214),(515,'Camden',31,214),(516,'New Bruswick/Piscataway',31,214),(517,'South Orange',31,214),(518,'Hoboken',31,214),(519,'Edison',31,214),(520,'Wayne',31,214),(521,'Adrian',23,214),(522,'Albion',23,214),(523,'Alma',23,214),(524,'Berrien Springs',23,214),(525,'Grand Rapids',23,214),(526,'Owosso',23,214),(527,'Mount Pleasant',23,214),(528,'Howell',23,214),(529,'Detroit',23,214),(530,'Ann Arbor',23,214),(531,'Bloomfield Hills',23,214),(532,'Ypsilanti',23,214),(533,'Big Rapids',23,214),(534,'Hancock',23,214),(535,'Wyoming',23,214),(536,'Lansing',23,214),(537,'Hillsdale',23,214),(538,'Holland',23,214),(539,'Kalamazoo',23,214),(540,'Flint',23,214),(541,'Sault Ste Marie',23,214),(542,'Southfield',23,214),(543,'Livonia',23,214),(544,'Farmington Hills',23,214),(545,'East Lansing',23,214),(546,'Greenville',23,214),(547,'Battle Creek',23,214),(548,'Marquette',23,214),(549,'Cedar Hill',23,214),(550,'Rochester',23,214),(551,'Olivet',23,214),(552,'Chesterfield',23,214),(553,'Lambertville',23,214),(554,'Chelsea',23,214),(555,'Dearborn',23,214),(556,'Troy',23,214),(557,'Raymond',25,214),(558,'Jackson',25,214),(559,'Blue Mountain',25,214),(560,'Cleveland',25,214),(561,'Kosciusko',25,214),(562,'Clinton',25,214),(563,'Miss State',25,214),(564,'Columbus',25,214),(565,'Greenwood',25,214),(566,'Holly Springs',25,214),(567,'Tougaloo',25,214),(568,'University',25,214),(569,'Hattiesburg',25,214),(570,'Gulfport',25,214),(571,'Helena',27,214),(572,'Bozeman',27,214),(573,'Billings',27,214),(574,'Havre',27,214),(575,'Pablo',27,214),(576,'Great Falls',27,214),(577,'Missoula',27,214),(578,'Butte',27,214),(579,'Dillon',27,214),(580,'Bellevue',28,214),(581,'Chadron',28,214),(582,'Omaha',28,214),(583,'Seward',28,214),(584,'Blair',28,214),(585,'Crete',28,214),(586,'Hastings',28,214),(587,'Fremont',28,214),(588,'Norfolk',28,214),(589,'Lincoln',28,214),(590,'Peru',28,214),(591,'Kearney',28,214),(592,'Wayne',28,214),(593,'York',28,214),(594,'Boone',34,214),(595,'Wilson',34,214),(596,'Greensboro',34,214),(597,'Brevard',34,214),(598,'Concord',34,214),(599,'Buies Creek',34,214),(600,'Salisbury',34,214),(601,'Murfreesboro',34,214),(602,'Davidson',34,214),(603,'Durham',34,214),(604,'Greenville',34,214),(605,'Elizabeth ',34,214),(606,'Fayetteville',34,214),(607,'Boiling Springs',34,214),(608,'High Point',34,214),(609,'Charlotte',34,214),(610,'Dobson',34,214),(611,'Hickory',34,214);
/*!40000 ALTER TABLE `cities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(50) default '',
  `comment` varchar(255) default '',
  `created_at` datetime NOT NULL,
  `commentable_id` int(11) NOT NULL default '0',
  `commentable_type` varchar(15) NOT NULL default '',
  `user_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `fk_comments_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,'','Comment','2009-04-03 03:20:12',1,'Post',6),(2,'','Comment 1','2009-04-03 03:20:24',1,'Post',6),(3,'','Comment 2','2009-04-03 03:20:29',1,'Post',6),(4,'','Comment 3','2009-04-03 03:20:37',1,'Post',6),(5,'','need to work more on this part.','2009-04-21 04:55:01',4,'Story',1),(6,'','i don\'t like this website','2009-04-24 21:20:41',4,'Story',1);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `countries` (
  `id` int(11) NOT NULL auto_increment,
  `iso` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `printable_name` varchar(255) default NULL,
  `iso3` varchar(255) default NULL,
  `numcode` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=227 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES (1,'AF','AFGHANISTAN','Afghanistan','AFG',4),(2,'AL','ALBANIA','Albania','ALB',8),(3,'DZ','ALGERIA','Algeria','DZA',12),(4,'AS','AMERICAN SAMOA','American Samoa','ASM',16),(5,'AD','ANDORRA','Andorra','AND',20),(6,'AO','ANGOLA','Angola','AGO',24),(7,'AI','ANGUILLA','Anguilla','AIA',660),(8,'AG','ANTIGUA AND BARBUDA','Antigua and Barbuda','ATG',28),(9,'AR','ARGENTINA','Argentina','ARG',32),(10,'AM','ARMENIA','Armenia','ARM',51),(11,'AW','ARUBA','Aruba','ABW',533),(12,'AU','AUSTRALIA','Australia','AUS',36),(13,'AT','AUSTRIA','Austria','AUT',40),(14,'AZ','AZERBAIJAN','Azerbaijan','AZE',31),(15,'BS','BAHAMAS','Bahamas','BHS',44),(16,'BH','BAHRAIN','Bahrain','BHR',48),(17,'BD','BANGLADESH','Bangladesh','BGD',50),(18,'BB','BARBADOS','Barbados','BRB',52),(19,'BY','BELARUS','Belarus','BLR',112),(20,'BE','BELGIUM','Belgium','BEL',56),(21,'BZ','BELIZE','Belize','BLZ',84),(22,'BJ','BENIN','Benin','BEN',204),(23,'BM','BERMUDA','Bermuda','BMU',60),(24,'BT','BHUTAN','Bhutan','BTN',64),(25,'BO','BOLIVIA','Bolivia','BOL',68),(26,'BA','BOSNIA AND HERZEGOVINA','Bosnia and Herzegovina','BIH',70),(27,'BW','BOTSWANA','Botswana','BWA',72),(28,'BR','BRAZIL','Brazil','BRA',76),(29,'BN','BRUNEI DARUSSALAM','Brunei Darussalam','BRN',96),(30,'BG','BULGARIA','Bulgaria','BGR',100),(31,'BF','BURKINA FASO','Burkina Faso','BFA',854),(32,'BI','BURUNDI','Burundi','BDI',108),(33,'KH','CAMBODIA','Cambodia','KHM',116),(34,'CM','CAMEROON','Cameroon','CMR',120),(35,'CA','CANADA','Canada','CAN',124),(36,'CV','CAPE VERDE','Cape Verde','CPV',132),(37,'KY','CAYMAN ISLANDS','Cayman Islands','CYM',136),(38,'CF','CENTRAL AFRICAN REPUBLIC','Central African Republic','CAF',140),(39,'TD','CHAD','Chad','TCD',148),(40,'CL','CHILE','Chile','CHL',152),(41,'CN','CHINA','China','CHN',156),(42,'CO','COLOMBIA','Colombia','COL',170),(43,'KM','COMOROS','Comoros','COM',174),(44,'CG','CONGO','Congo','COG',178),(45,'CD','CONGO, THE DEMOCRATIC REPUBLIC OF THE','Congo, the Democratic Republic of the','COD',180),(46,'CK','COOK ISLANDS','Cook Islands','COK',184),(47,'CR','COSTA RICA','Costa Rica','CRI',188),(48,'CI','COTE D\'IVOIRE','Cote D\'Ivoire','CIV',384),(49,'HR','CROATIA','Croatia','HRV',191),(50,'CU','CUBA','Cuba','CUB',192),(51,'CY','CYPRUS','Cyprus','CYP',196),(52,'CZ','CZECH REPUBLIC','Czech Republic','CZE',203),(53,'DK','DENMARK','Denmark','DNK',208),(54,'DJ','DJIBOUTI','Djibouti','DJI',262),(55,'DM','DOMINICA','Dominica','DMA',212),(56,'DO','DOMINICAN REPUBLIC','Dominican Republic','DOM',214),(57,'EC','ECUADOR','Ecuador','ECU',218),(58,'EG','EGYPT','Egypt','EGY',818),(59,'SV','EL SALVADOR','El Salvador','SLV',222),(60,'GQ','EQUATORIAL GUINEA','Equatorial Guinea','GNQ',226),(61,'ER','ERITREA','Eritrea','ERI',232),(62,'EE','ESTONIA','Estonia','EST',233),(63,'ET','ETHIOPIA','Ethiopia','ETH',231),(64,'FK','FALKLAND ISLANDS (MALVINAS)','Falkland Islands (Malvinas)','FLK',238),(65,'FO','FAROE ISLANDS','Faroe Islands','FRO',234),(66,'FJ','FIJI','Fiji','FJI',242),(67,'FI','FINLAND','Finland','FIN',246),(68,'FR','FRANCE','France','FRA',250),(69,'GF','FRENCH GUIANA','French Guiana','GUF',254),(70,'PF','FRENCH POLYNESIA','French Polynesia','PYF',258),(71,'GA','GABON','Gabon','GAB',266),(72,'GM','GAMBIA','Gambia','GMB',270),(73,'GE','GEORGIA','Georgia','GEO',268),(74,'DE','GERMANY','Germany','DEU',276),(75,'GH','GHANA','Ghana','GHA',288),(76,'GI','GIBRALTAR','Gibraltar','GIB',292),(77,'GR','GREECE','Greece','GRC',300),(78,'GL','GREENLAND','Greenland','GRL',304),(79,'GD','GRENADA','Grenada','GRD',308),(80,'GP','GUADELOUPE','Guadeloupe','GLP',312),(81,'GU','GUAM','Guam','GUM',316),(82,'GT','GUATEMALA','Guatemala','GTM',320),(83,'GN','GUINEA','Guinea','GIN',324),(84,'GW','GUINEA-BISSAU','Guinea-Bissau','GNB',624),(85,'GY','GUYANA','Guyana','GUY',328),(86,'HT','HAITI','Haiti','HTI',332),(87,'VA','HOLY SEE (VATICAN CITY STATE)','Holy See (Vatican City State)','VAT',336),(88,'HN','HONDURAS','Honduras','HND',340),(89,'HK','HONG KONG','Hong Kong','HKG',344),(90,'HU','HUNGARY','Hungary','HUN',348),(91,'IS','ICELAND','Iceland','ISL',352),(92,'IN','INDIA','India','IND',356),(93,'ID','INDONESIA','Indonesia','IDN',360),(94,'IR','IRAN, ISLAMIC REPUBLIC OF','Iran, Islamic Republic of','IRN',364),(95,'IQ','IRAQ','Iraq','IRQ',368),(96,'IE','IRELAND','Ireland','IRL',372),(97,'IL','ISRAEL','Israel','ISR',376),(98,'IT','ITALY','Italy','ITA',380),(99,'JM','JAMAICA','Jamaica','JAM',388),(100,'JP','JAPAN','Japan','JPN',392),(101,'JO','JORDAN','Jordan','JOR',400),(102,'KZ','KAZAKHSTAN','Kazakhstan','KAZ',398),(103,'KE','KENYA','Kenya','KEN',404),(104,'KI','KIRIBATI','Kiribati','KIR',296),(105,'KP','KOREA, DEMOCRATIC PEOPLE\'S REPUBLIC OF','Korea, Democratic People\'s Republic of','PRK',408),(106,'KR','KOREA, REPUBLIC OF','Korea, Republic of','KOR',410),(107,'KW','KUWAIT','Kuwait','KWT',414),(108,'KG','KYRGYZSTAN','Kyrgyzstan','KGZ',417),(109,'LA','LAO PEOPLE\'S DEMOCRATIC REPUBLIC','Lao People\'s Democratic Republic','LAO',418),(110,'LV','LATVIA','Latvia','LVA',428),(111,'LB','LEBANON','Lebanon','LBN',422),(112,'LS','LESOTHO','Lesotho','LSO',426),(113,'LR','LIBERIA','Liberia','LBR',430),(114,'LY','LIBYAN ARAB JAMAHIRIYA','Libyan Arab Jamahiriya','LBY',434),(115,'LI','LIECHTENSTEIN','Liechtenstein','LIE',438),(116,'LT','LITHUANIA','Lithuania','LTU',440),(117,'LU','LUXEMBOURG','Luxembourg','LUX',442),(118,'MO','MACAO','Macao','MAC',446),(119,'MK','MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF','Macedonia, the Former Yugoslav Republic of','MKD',807),(120,'MG','MADAGASCAR','Madagascar','MDG',450),(121,'MW','MALAWI','Malawi','MWI',454),(122,'MY','MALAYSIA','Malaysia','MYS',458),(123,'MV','MALDIVES','Maldives','MDV',462),(124,'ML','MALI','Mali','MLI',466),(125,'MT','MALTA','Malta','MLT',470),(126,'MH','MARSHALL ISLANDS','Marshall Islands','MHL',584),(127,'MQ','MARTINIQUE','Martinique','MTQ',474),(128,'MR','MAURITANIA','Mauritania','MRT',478),(129,'MU','MAURITIUS','Mauritius','MUS',480),(130,'MX','MEXICO','Mexico','MEX',484),(131,'FM','MICRONESIA, FEDERATED STATES OF','Micronesia, Federated States of','FSM',583),(132,'MD','MOLDOVA, REPUBLIC OF','Moldova, Republic of','MDA',498),(133,'MC','MONACO','Monaco','MCO',492),(134,'MN','MONGOLIA','Mongolia','MNG',496),(135,'MS','MONTSERRAT','Montserrat','MSR',500),(136,'MA','MOROCCO','Morocco','MAR',504),(137,'MZ','MOZAMBIQUE','Mozambique','MOZ',508),(138,'MM','MYANMAR','Myanmar','MMR',104),(139,'NA','NAMIBIA','Namibia','NAM',516),(140,'NR','NAURU','Nauru','NRU',520),(141,'NP','NEPAL','Nepal','NPL',524),(142,'NL','NETHERLANDS','Netherlands','NLD',528),(143,'AN','NETHERLANDS ANTILLES','Netherlands Antilles','ANT',530),(144,'NC','NEW CALEDONIA','New Caledonia','NCL',540),(145,'NZ','NEW ZEALAND','New Zealand','NZL',554),(146,'NI','NICARAGUA','Nicaragua','NIC',558),(147,'NE','NIGER','Niger','NER',562),(148,'NG','NIGERIA','Nigeria','NGA',566),(149,'NU','NIUE','Niue','NIU',570),(150,'NF','NORFOLK ISLAND','Norfolk Island','NFK',574),(151,'MP','NORTHERN MARIANA ISLANDS','Northern Mariana Islands','MNP',580),(152,'NO','NORWAY','Norway','NOR',578),(153,'OM','OMAN','Oman','OMN',512),(154,'PK','PAKISTAN','Pakistan','PAK',586),(155,'PW','PALAU','Palau','PLW',585),(156,'PA','PANAMA','Panama','PAN',591),(157,'PG','PAPUA NEW GUINEA','Papua New Guinea','PNG',598),(158,'PY','PARAGUAY','Paraguay','PRY',600),(159,'PE','PERU','Peru','PER',604),(160,'PH','PHILIPPINES','Philippines','PHL',608),(161,'PN','PITCAIRN','Pitcairn','PCN',612),(162,'PL','POLAND','Poland','POL',616),(163,'PT','PORTUGAL','Portugal','PRT',620),(164,'PR','PUERTO RICO','Puerto Rico','PRI',630),(165,'QA','QATAR','Qatar','QAT',634),(166,'RE','REUNION','Reunion','REU',638),(167,'RO','ROMANIA','Romania','ROM',642),(168,'RU','RUSSIAN FEDERATION','Russian Federation','RUS',643),(169,'RW','RWANDA','Rwanda','RWA',646),(170,'SH','SAINT HELENA','Saint Helena','SHN',654),(171,'KN','SAINT KITTS AND NEVIS','Saint Kitts and Nevis','KNA',659),(172,'LC','SAINT LUCIA','Saint Lucia','LCA',662),(173,'PM','SAINT PIERRE AND MIQUELON','Saint Pierre and Miquelon','SPM',666),(174,'VC','SAINT VINCENT AND THE GRENADINES','Saint Vincent and the Grenadines','VCT',670),(175,'WS','SAMOA','Samoa','WSM',882),(176,'SM','SAN MARINO','San Marino','SMR',674),(177,'ST','SAO TOME AND PRINCIPE','Sao Tome and Principe','STP',678),(178,'SA','SAUDI ARABIA','Saudi Arabia','SAU',682),(179,'SN','SENEGAL','Senegal','SEN',686),(180,'SC','SEYCHELLES','Seychelles','SYC',690),(181,'SL','SIERRA LEONE','Sierra Leone','SLE',694),(182,'SG','SINGAPORE','Singapore','SGP',702),(183,'SK','SLOVAKIA','Slovakia','SVK',703),(184,'SI','SLOVENIA','Slovenia','SVN',705),(185,'SB','SOLOMON ISLANDS','Solomon Islands','SLB',90),(186,'SO','SOMALIA','Somalia','SOM',706),(187,'ZA','SOUTH AFRICA','South Africa','ZAF',710),(188,'ES','SPAIN','Spain','ESP',724),(189,'LK','SRI LANKA','Sri Lanka','LKA',144),(190,'SD','SUDAN','Sudan','SDN',736),(191,'SR','SURINAME','Suriname','SUR',740),(192,'SJ','SVALBARD AND JAN MAYEN','Svalbard and Jan Mayen','SJM',744),(193,'SZ','SWAZILAND','Swaziland','SWZ',748),(194,'SE','SWEDEN','Sweden','SWE',752),(195,'CH','SWITZERLAND','Switzerland','CHE',756),(196,'SY','SYRIAN ARAB REPUBLIC','Syrian Arab Republic','SYR',760),(197,'TW','TAIWAN, PROVINCE OF CHINA','Taiwan, Province of China','TWN',158),(198,'TJ','TAJIKISTAN','Tajikistan','TJK',762),(199,'TZ','TANZANIA, UNITED REPUBLIC OF','Tanzania, United Republic of','TZA',834),(200,'TH','THAILAND','Thailand','THA',764),(201,'TG','TOGO','Togo','TGO',768),(202,'TK','TOKELAU','Tokelau','TKL',772),(203,'TO','TONGA','Tonga','TON',776),(204,'TT','TRINIDAD AND TOBAGO','Trinidad and Tobago','TTO',780),(205,'TN','TUNISIA','Tunisia','TUN',788),(206,'TR','TURKEY','Turkey','TUR',792),(207,'TM','TURKMENISTAN','Turkmenistan','TKM',795),(208,'TC','TURKS AND CAICOS ISLANDS','Turks and Caicos Islands','TCA',796),(209,'TV','TUVALU','Tuvalu','TUV',798),(210,'UG','UGANDA','Uganda','UGA',800),(211,'UA','UKRAINE','Ukraine','UKR',804),(212,'AE','UNITED ARAB EMIRATES','United Arab Emirates','ARE',784),(213,'GB','UNITED KINGDOM','United Kingdom','GBR',826),(214,'US','UNITED STATES','United States','USA',840),(215,'UY','URUGUAY','Uruguay','URY',858),(216,'UZ','UZBEKISTAN','Uzbekistan','UZB',860),(217,'VU','VANUATU','Vanuatu','VUT',548),(218,'VE','VENEZUELA','Venezuela','VEN',862),(219,'VN','VIET NAM','Viet Nam','VNM',704),(220,'VG','VIRGIN ISLANDS, BRITISH','Virgin Islands, British','VGB',92),(221,'VI','VIRGIN ISLANDS, U.S.','Virgin Islands, U.s.','VIR',850),(222,'WF','WALLIS AND FUTUNA','Wallis and Futuna','WLF',876),(223,'EH','WESTERN SAHARA','Western Sahara','ESH',732),(224,'YE','YEMEN','Yemen','YEM',887),(225,'ZM','ZAMBIA','Zambia','ZMB',894),(226,'ZW','ZIMBABWE','Zimbabwe','ZWE',716);
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_categories`
--

DROP TABLE IF EXISTS `department_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `department_categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `department_categories`
--

LOCK TABLES `department_categories` WRITE;
/*!40000 ALTER TABLE `department_categories` DISABLE KEYS */;
INSERT INTO `department_categories` VALUES (1,'AGRICULTURE AGRICULTURE OPERATIONS AND RELATED SCIENCES'),(2,'NATURAL RESOURCES AND CONSERVATION'),(3,'COMMUNICATION JOURNALISM AND RELATED PROGRAMS'),(4,'COMPUTER AND INFORMATION SCIENCES AND SUPPORT SERVICES'),(5,'EDUCATION'),(6,'ENGINEERING'),(7,'FOREIGN LANGUAGES LITERATURES AND LINGUISTICS'),(8,'FAMILY AND CONSUMER SCIENCES/HUMAN SCIENCES'),(9,'LEGAL PROFESSIONS AND STUDIES'),(10,'ENGLISH LANGUAGE AND LITERATURE/LETTERS'),(11,'LIBERAL ARTS AND SCIENCES STUDIES AND HUMANITIES'),(12,'BIOLOGICAL AND BIOMEDICAL SCIENCES'),(13,'MATHEMATICS AND STATISTICS'),(14,'MULTI/INTERDISCIPLINARY STUDIES'),(15,'PARKS RECREATION LEISURE AND FITNESS STUDIES'),(16,'THEOLOGY AND RELIGIOUS VOCATIONS'),(17,'PHYSICAL SCIENCES'),(18,'PSYCHOLOGY'),(19,'PUBLIC ADMINISTRATION AND SOCIAL SERVICE PROFESSIONS'),(20,'SOCIAL SCIENCES'),(21,'VISUAL AND PERFORMING ARTS'),(22,'HEALTH PROFESSIONS AND RELATED CLINICAL SCIENCES'),(23,'BUSINESS MANAGEMENT MARKETING AND RELATED SUPPORT SERVICES'),(24,'HISTORY'),(25,'COMMUNICATIONS TECHNOLOGIES/TECHNICIANS AND SUPPORT SERVICES'),(26,'COMMUNICATION JOURNALISM AND RELATED PROGRAMS'),(27,'AREA ETHNIC CULTURAL AND GENDER STUDIES'),(28,'PHILOSOPHY AND RELIGIOUS STUDIES'),(29,'SECURITY AND PROTECTIVE SERVICES'),(30,'ENGINEERING TECHNOLOGIES/TECHNICIANS');
/*!40000 ALTER TABLE `department_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `departments` (
  `id` int(11) NOT NULL auto_increment,
  `department_category_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,1,'agribusiness/agricultural business operations'),(2,1,'food science'),(3,1,'animal sciences'),(4,1,'agriculture agriculture operations and related sciences'),(5,1,'plant sciences'),(6,1,'city/urban'),(7,1,'community'),(8,1,'regional planning'),(9,2,'environmental science'),(10,2,'forestry'),(11,3,'communication studies/speech communication and rhetoric'),(12,3,'journalism'),(13,3,'digital communication and media/multimedia'),(14,3,'public relations/image management'),(15,3,'environmental studies'),(16,3,'communication and media studies'),(17,3,'mass communication/media studies'),(18,4,'information technology'),(19,4,'computer science'),(20,4,'computer and information sciences'),(21,4,'information science/studies'),(22,5,'special education and teaching'),(23,5,'special education and teaching'),(24,5,'junior high/intermediate/middle school education and teaching'),(25,5,'secondary education and teaching'),(26,5,'art teacher education'),(27,5,'English/language arts teacher education'),(28,5,'foreign language teacher education'),(29,5,'mathematics teacher education'),(30,5,'music teacher education'),(31,5,'physical education teaching and coaching'),(32,5,'science teacher education/general science teacher education'),(33,5,'social studies teacher education'),(34,5,'biology teacher education'),(35,5,'computer graphics'),(36,5,'history teacher education'),(37,5,'education'),(38,5,'teacher education'),(39,5,'social science teacher education'),(40,5,'health teacher education'),(41,5,'educational leadership and administration'),(42,5,'education/teaching of individuals with speech or language impairments'),(43,5,'early childhood education and teaching'),(44,5,'reading teacher education'),(45,5,'elementary education and teaching'),(46,6,'engineering science'),(47,6,'civil engineering'),(48,6,'mechanical engineering'),(49,7,'Spanish language and literature'),(50,7,'French language and literature'),(51,7,'German language and literature'),(52,7,'classics and classical languages'),(53,7,'literatures'),(54,7,'linguistics'),(55,8,'human development and family studies'),(56,8,'family and consumer sciences/human sciences'),(57,9,'pre-law studies'),(58,10,'English language and literature'),(59,10,'creative writing'),(60,11,'liberal arts and sciences/liberal studies'),(61,11,'humanities/humanistic studies'),(62,12,'biology/biological sciences'),(63,12,'biochemistry'),(64,13,'mathematics'),(65,14,'international/global studies'),(66,14,'multi/interdisciplinary studies'),(67,14,'biological and physical sciences'),(68,14,'neuroscience'),(69,15,'health and physical education'),(70,15,'kinesiology and exercise science'),(71,15,'sport and fitness administration/management'),(72,16,'Bible/biblical studies'),(73,16,'missions/missionary studies and missiology'),(74,16,'youth ministry'),(75,16,'pastoral counseling and specialized ministries'),(76,16,'theology and religious vocations'),(77,17,'chemistry'),(78,17,'geology/earth science'),(79,17,'physics'),(80,17,'astrophysics'),(81,18,'psychology'),(82,18,'clinical psychology'),(83,18,'counseling psychology'),(84,19,'social work'),(85,20,'political science and government'),(86,20,'social sciences'),(87,20,'sociology'),(88,20,'anthropology'),(89,20,'economics'),(90,20,'international relations and affairs'),(91,21,'interior design'),(92,21,'graphic design'),(93,21,'drama and dramatics/theater arts'),(94,21,'fine/studio arts'),(95,21,'arts management'),(96,21,'music'),(97,21,'piano and organ'),(98,21,'commercial and advertising art'),(99,21,'voice and opera'),(100,21,'industrial design'),(101,21,'fashion/apparel design'),(102,21,'illustration'),(103,21,'fine arts and art studies'),(104,21,'photography'),(105,21,'art/art studies'),(106,21,'cinematography and film/video production'),(107,21,'dance'),(108,21,'visual and performing arts'),(109,22,'speech-language pathology/pathologist'),(110,22,'health/medical preparatory programs'),(111,22,'nursing/registered nurse training (R.N. A.S.N. B.S.N. M.S.N.)'),(112,22,'dietetics/dietitian (R.D.)'),(113,22,'audiology/audiologist and speech-language pathology/pathologist'),(114,22,'pre-medicine/pre-medical studies'),(115,22,'pre-pharmacy studies'),(116,22,'pre-dentistry studies'),(117,22,'pre-veterinary studies'),(118,23,'business administration and management'),(119,23,'accounting'),(120,23,'finance'),(121,23,'information resources management/cio training'),(122,23,'marketing/marketing management'),(123,23,'business'),(124,23,'management'),(125,23,'marketing'),(126,23,'related support services'),(127,23,'international business'),(128,23,'business/commerce'),(129,24,'history'),(130,25,'animation'),(131,25,'interactive technology'),(132,25,'video graphics'),(133,25,'radio and television broadcasting technology/technician'),(134,26,'advertising'),(135,26,'communication studies/speech communication and rhetoric'),(136,27,'Latin American studies'),(137,27,'Japanese studies'),(138,27,'African studies'),(139,27,'women\'s studies'),(140,28,'philosophy'),(141,28,'religion/religious studies'),(142,29,'criminal justice/safety studies'),(143,29,'criminal justice/law enforcement administration'),(144,30,'civil engineering technology/technician'),(145,30,'electrical and electronic engineering technologies/technicians'),(146,30,'industrial technology/technician'),(147,30,'mechanical-engineering-related technologies/technicians');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments_schools`
--

DROP TABLE IF EXISTS `departments_schools`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `departments_schools` (
  `school_id` int(11) NOT NULL,
  `department_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `departments_schools`
--

LOCK TABLES `departments_schools` WRITE;
/*!40000 ALTER TABLE `departments_schools` DISABLE KEYS */;
INSERT INTO `departments_schools` VALUES (2,1),(2,2),(2,3),(2,4),(2,5),(2,10),(2,20),(2,25),(2,26),(2,30),(2,31),(2,37),(2,41),(2,42),(2,43),(2,44),(2,45),(2,47),(2,48),(2,56),(2,58),(2,62),(2,64),(2,77),(2,79),(2,81),(2,82),(2,83),(2,84),(2,85),(2,87),(2,89),(2,105),(2,109),(2,118),(2,119),(2,120),(2,122),(2,128),(2,133),(2,144),(2,145),(2,146),(2,147),(3,19),(3,21),(3,25),(3,30),(3,31),(3,43),(3,45),(3,58),(3,62),(3,64),(3,77),(3,79),(3,81),(3,84),(3,85),(3,87),(3,93),(3,96),(3,105),(3,118),(3,119),(3,120),(3,122),(3,129),(3,135),(3,142),(6,3),(6,5),(6,9),(6,10),(6,12),(6,14),(6,20),(6,25),(6,27),(6,28),(6,29),(6,30),(6,31),(6,32),(6,37),(6,38),(6,39),(6,40),(6,41),(6,43),(6,45),(6,47),(6,48),(6,49),(6,50),(6,51),(6,62),(6,64),(6,84),(6,85),(6,87),(6,88),(6,89),(6,91),(6,93),(6,94),(6,96),(6,100),(6,111),(6,113),(6,118),(6,119),(6,120),(6,122),(6,127),(6,129),(6,140),(7,11),(7,25),(7,45),(7,58),(7,60),(7,81),(7,85),(7,87),(7,105),(7,111),(7,118),(7,119),(7,120),(7,128),(7,129),(7,142),(9,43),(9,45),(9,118),(10,12),(10,20),(10,24),(10,25),(10,31),(10,32),(10,33),(10,34),(10,36),(10,37),(10,38),(10,39),(10,45),(10,52),(10,53),(10,54),(10,56),(10,57),(10,58),(10,60),(10,61),(10,62),(10,64),(10,69),(10,72),(10,73),(10,74),(10,76),(10,81),(10,86),(10,87),(10,93),(10,94),(10,96),(10,110),(10,114),(10,115),(10,116),(10,117),(10,118),(10,119),(10,120),(10,123),(10,124),(10,125),(10,129),(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(1,17),(1,18),(1,19),(1,20),(1,21),(1,22),(1,24),(1,25),(1,29),(1,33),(1,35),(1,39),(1,42),(1,43),(1,44),(1,45),(1,48),(1,50),(1,52),(1,53),(1,54),(1,56),(1,58),(1,59),(1,60),(1,61),(1,62),(1,63),(1,72),(1,73),(1,74),(1,75),(1,76),(1,78),(1,79),(1,81),(1,82),(1,83),(1,85),(1,86),(1,88),(1,90),(1,92),(1,93),(1,97),(1,100),(1,101),(1,102),(1,103),(1,104),(1,109),(1,110),(1,111),(1,112),(1,114);
/*!40000 ALTER TABLE `departments_schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `education_categories`
--

DROP TABLE IF EXISTS `education_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `education_categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `education_categories`
--

LOCK TABLES `education_categories` WRITE;
/*!40000 ALTER TABLE `education_categories` DISABLE KEYS */;
INSERT INTO `education_categories` VALUES (1,'Study Group'),(2,'Class'),(3,'Lecture'),(4,'Office Hours'),(5,'Workshop'),(6,'Year Book'),(7,'Test Schedule'),(8,'Midterm Schedule'),(9,'Exam Schedule'),(10,'Scholarship'),(11,'Honor List'),(12,'Counselor Schedule');
/*!40000 ALTER TABLE `education_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `favorites` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `post_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
INSERT INTO `favorites` VALUES (1,6,1,'2009-04-02 07:04:36','2009-04-02 07:04:36'),(2,8,23,'2009-04-03 20:55:34','2009-04-03 20:55:34'),(3,4,42,'2009-04-04 07:53:25','2009-04-04 07:53:25'),(4,4,50,'2009-04-04 07:58:37','2009-04-04 07:58:37'),(5,6,42,'2009-04-04 08:55:25','2009-04-04 08:55:25'),(6,8,51,'2009-04-04 20:49:54','2009-04-04 20:49:54'),(7,1,40,'2009-04-15 02:47:38','2009-04-15 02:47:38'),(8,1,50,'2009-04-15 23:19:08','2009-04-15 23:19:08');
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `functional_experiences`
--

DROP TABLE IF EXISTS `functional_experiences`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `functional_experiences` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `functional_experiences`
--

LOCK TABLES `functional_experiences` WRITE;
/*!40000 ALTER TABLE `functional_experiences` DISABLE KEYS */;
INSERT INTO `functional_experiences` VALUES (1,'Accounting','2009-04-02 02:50:16','2009-04-02 02:50:16');
/*!40000 ALTER TABLE `functional_experiences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `housing_categories`
--

DROP TABLE IF EXISTS `housing_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `housing_categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `housing_categories`
--

LOCK TABLES `housing_categories` WRITE;
/*!40000 ALTER TABLE `housing_categories` DISABLE KEYS */;
INSERT INTO `housing_categories` VALUES (1,'Room for share'),(2,'Apartment for rent'),(3,'House for rent'),(4,'Summer rental');
/*!40000 ALTER TABLE `housing_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `housing_categories_post_housings`
--

DROP TABLE IF EXISTS `housing_categories_post_housings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `housing_categories_post_housings` (
  `housing_category_id` int(11) NOT NULL,
  `post_housing_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `housing_categories_post_housings`
--

LOCK TABLES `housing_categories_post_housings` WRITE;
/*!40000 ALTER TABLE `housing_categories_post_housings` DISABLE KEYS */;
INSERT INTO `housing_categories_post_housings` VALUES (1,1),(1,2);
/*!40000 ALTER TABLE `housing_categories_post_housings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip_countries`
--

DROP TABLE IF EXISTS `ip_countries`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ip_countries` (
  `id` int(11) NOT NULL auto_increment,
  `ip_address` varchar(255) default NULL,
  `ip_code` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `ip_countries`
--

LOCK TABLES `ip_countries` WRITE;
/*!40000 ALTER TABLE `ip_countries` DISABLE KEYS */;
/*!40000 ALTER TABLE `ip_countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_types`
--

DROP TABLE IF EXISTS `job_types`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `job_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `job_types`
--

LOCK TABLES `job_types` WRITE;
/*!40000 ALTER TABLE `job_types` DISABLE KEYS */;
INSERT INTO `job_types` VALUES (1,'Full-time Permanent'),(2,'Full-time Temporary'),(3,'Part-time Permanent'),(4,'Part-time Temporary'),(5,'Contractor/Consultant'),(6,'Internship'),(7,'Other');
/*!40000 ALTER TABLE `job_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_types_post_jobs`
--

DROP TABLE IF EXISTS `job_types_post_jobs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `job_types_post_jobs` (
  `post_job_id` int(11) NOT NULL,
  `job_type_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `job_types_post_jobs`
--

LOCK TABLES `job_types_post_jobs` WRITE;
/*!40000 ALTER TABLE `job_types_post_jobs` DISABLE KEYS */;
INSERT INTO `job_types_post_jobs` VALUES (1,1),(2,2),(3,1),(4,3),(5,1),(6,3),(6,4),(7,1),(9,3),(9,4),(10,1),(10,2),(8,1),(8,2);
/*!40000 ALTER TABLE `job_types_post_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL auto_increment,
  `sender_id` int(11) default NULL,
  `recipient_id` int(11) default NULL,
  `sender_deleted` tinyint(1) default '0',
  `recipient_deleted` tinyint(1) default '0',
  `subject` varchar(255) default NULL,
  `body` text,
  `read_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `music_albums`
--

DROP TABLE IF EXISTS `music_albums`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `music_albums` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `music_albums`
--

LOCK TABLES `music_albums` WRITE;
/*!40000 ALTER TABLE `music_albums` DISABLE KEYS */;
INSERT INTO `music_albums` VALUES (1,4,'pop album','2009-04-04 07:20:43','2009-04-04 07:20:43');
/*!40000 ALTER TABLE `music_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `musics`
--

DROP TABLE IF EXISTS `musics`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `musics` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `music_album_id` int(11) NOT NULL,
  `title` varchar(255) default NULL,
  `description` text,
  `who_can_see` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `music_attach_file_name` varchar(255) default NULL,
  `music_attach_content_type` varchar(255) default NULL,
  `music_attach_file_size` int(11) default NULL,
  `music_attach_updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `musics`
--

LOCK TABLES `musics` WRITE;
/*!40000 ALTER TABLE `musics` DISABLE KEYS */;
INSERT INTO `musics` VALUES (1,4,1,'All 4 One_ I Swear','All 4 One_ I Swear',0,'2009-04-04 07:23:34','2009-04-04 07:23:34','All 4 One_ I Swear.mp3','audio/mpeg',4180069,NULL),(2,4,1,'Alone (Beegees)','Alone (Beegees)',0,'2009-04-04 07:26:46','2009-04-04 07:26:46','Alone (Beegees).Mp3','audio/mpeg',4640760,NULL),(3,4,1,'ALWAYS COCA COLA () F1','ALWAYS COCA COLA () F1',0,'2009-04-04 07:32:14','2009-04-04 07:32:14','ALWAYS COCA COLA () F1.MP3','audio/mpeg',2081216,NULL);
/*!40000 ALTER TABLE `musics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `party_types`
--

DROP TABLE IF EXISTS `party_types`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `party_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `party_types`
--

LOCK TABLES `party_types` WRITE;
/*!40000 ALTER TABLE `party_types` DISABLE KEYS */;
INSERT INTO `party_types` VALUES (1,'Clubbing'),(2,'In house'),(3,'Par'),(4,'Poker'),(5,'Birthday'),(6,'Chill out'),(7,'Poker party'),(8,'Halloween party'),(9,'Formal dance'),(10,'Potluck');
/*!40000 ALTER TABLE `party_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `party_types_post_parties`
--

DROP TABLE IF EXISTS `party_types_post_parties`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `party_types_post_parties` (
  `post_party_id` int(11) NOT NULL,
  `party_type_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `party_types_post_parties`
--

LOCK TABLES `party_types_post_parties` WRITE;
/*!40000 ALTER TABLE `party_types_post_parties` DISABLE KEYS */;
INSERT INTO `party_types_post_parties` VALUES (1,5),(2,2);
/*!40000 ALTER TABLE `party_types_post_parties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photo_albums`
--

DROP TABLE IF EXISTS `photo_albums`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `photo_albums` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `photo_albums`
--

LOCK TABLES `photo_albums` WRITE;
/*!40000 ALTER TABLE `photo_albums` DISABLE KEYS */;
INSERT INTO `photo_albums` VALUES (1,4,'picture','2009-04-04 06:56:44','2009-04-04 06:56:44'),(2,1,'My Photo','2009-04-15 02:39:09','2009-04-15 02:39:09'),(3,1,'My picture','2009-04-19 19:00:59','2009-04-19 19:00:59'),(4,6,'Me','2009-04-22 01:52:59','2009-04-22 01:52:59');
/*!40000 ALTER TABLE `photo_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `photos` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `photo_album_id` int(11) NOT NULL,
  `title` varchar(255) default NULL,
  `description` text,
  `who_can_see` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `photo_attach_file_name` varchar(255) default NULL,
  `photo_attach_content_type` varchar(255) default NULL,
  `photo_attach_file_size` int(11) default NULL,
  `photo_attach_updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `photos`
--

LOCK TABLES `photos` WRITE;
/*!40000 ALTER TABLE `photos` DISABLE KEYS */;
INSERT INTO `photos` VALUES (1,4,1,'Blue hills','Blue hills',0,'2009-04-04 06:57:54','2009-04-04 06:57:54','Blue hills.jpg','image/jpeg',28521,NULL),(2,4,1,'Sunset','Sunset',1,'2009-04-04 06:59:50','2009-04-04 06:59:50','Sunset.jpg','image/jpeg',71189,NULL),(3,4,1,'Water lilies','Water lilies',0,'2009-04-04 07:01:11','2009-04-04 07:01:11','Water lilies.jpg','image/jpeg',83794,NULL),(4,4,1,'Winter','Winter',0,'2009-04-04 07:19:14','2009-04-04 07:19:14','Winter.jpg','image/jpeg',105542,NULL),(5,6,4,'Me','Description',0,'2009-04-22 01:53:27','2009-04-22 01:53:27','Hình ảnh0047.jpg','image/jpeg',130628,NULL);
/*!40000 ALTER TABLE `photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_awarenesses`
--

DROP TABLE IF EXISTS `post_awarenesses`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `post_awarenesses` (
  `id` int(11) NOT NULL auto_increment,
  `post_id` int(11) NOT NULL,
  `campaign_start` datetime default NULL,
  `campaign_end` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post_awarenesses`
--

LOCK TABLES `post_awarenesses` WRITE;
/*!40000 ALTER TABLE `post_awarenesses` DISABLE KEYS */;
INSERT INTO `post_awarenesses` VALUES (1,47,NULL,NULL),(2,48,NULL,NULL),(3,52,NULL,NULL);
/*!40000 ALTER TABLE `post_awarenesses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_books`
--

DROP TABLE IF EXISTS `post_books`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `post_books` (
  `id` int(11) NOT NULL auto_increment,
  `post_id` int(11) NOT NULL,
  `price` varchar(255) NOT NULL,
  `currency` varchar(255) default NULL,
  `accept_payment` varchar(255) default NULL,
  `shipping_method_id` int(11) NOT NULL,
  `in_stock` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post_books`
--

LOCK TABLES `post_books` WRITE;
/*!40000 ALTER TABLE `post_books` DISABLE KEYS */;
INSERT INTO `post_books` VALUES (1,1,'No','USD','Cash',1,''),(2,2,'23','USD','Cash',2,''),(3,3,'33','USD','Cash',3,''),(4,4,'45','USD','Paypal',1,''),(5,5,'23','CAD','Paypal',3,''),(6,6,'34','CAD','Master Card',2,''),(7,7,'55','USD','Cash',3,''),(8,8,'55','CAD','Paypal',1,''),(9,9,'21','CAD','Cash',2,''),(10,10,'22','USD','Cash',1,''),(11,11,'34','USD','Cash',3,'');
/*!40000 ALTER TABLE `post_books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_categories`
--

DROP TABLE IF EXISTS `post_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `post_categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post_categories`
--

LOCK TABLES `post_categories` WRITE;
/*!40000 ALTER TABLE `post_categories` DISABLE KEYS */;
INSERT INTO `post_categories` VALUES (1,'Assignments'),(2,'Tests'),(3,'Projects'),(4,'Exams'),(5,'Education'),(6,'Tutors'),(7,'Books'),(8,'Jobs'),(9,'Party'),(10,'Student Awareness'),(11,'Housing'),(12,'Team Up');
/*!40000 ALTER TABLE `post_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_educations`
--

DROP TABLE IF EXISTS `post_educations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `post_educations` (
  `id` int(11) NOT NULL auto_increment,
  `post_id` int(11) NOT NULL,
  `education_category_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post_educations`
--

LOCK TABLES `post_educations` WRITE;
/*!40000 ALTER TABLE `post_educations` DISABLE KEYS */;
INSERT INTO `post_educations` VALUES (1,40,1),(2,41,1),(3,42,4);
/*!40000 ALTER TABLE `post_educations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_housings`
--

DROP TABLE IF EXISTS `post_housings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `post_housings` (
  `id` int(11) NOT NULL auto_increment,
  `post_id` int(11) NOT NULL,
  `rent` varchar(255) NOT NULL,
  `currency` varchar(255) default NULL,
  `street` varchar(255) default NULL,
  `intersection` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post_housings`
--

LOCK TABLES `post_housings` WRITE;
/*!40000 ALTER TABLE `post_housings` DISABLE KEYS */;
INSERT INTO `post_housings` VALUES (1,30,'250','USD','','','',''),(2,31,'581','USD','','','','');
/*!40000 ALTER TABLE `post_housings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_jobs`
--

DROP TABLE IF EXISTS `post_jobs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `post_jobs` (
  `id` int(11) NOT NULL auto_increment,
  `post_id` int(11) NOT NULL,
  `prepare_post` tinyint(1) default NULL,
  `responsibilities` text NOT NULL,
  `required_skills` text NOT NULL,
  `desirable_skills` text NOT NULL,
  `edu_experience_require` text NOT NULL,
  `compensation` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post_jobs`
--

LOCK TABLES `post_jobs` WRITE;
/*!40000 ALTER TABLE `post_jobs` DISABLE KEYS */;
INSERT INTO `post_jobs` VALUES (1,12,0,'no','CPA and significant public accounting experience are required.\r\n15+ Years of experience in public accounting, currently holds a senior\r\nlevel position in public accounting firm.\r\nCommercial and Architectural and Engineering experience is a plus.\r\nFirm is comprised of 8 partners, 8 principals, and 100 full-time employees.','no','no','Salary $200,000-$300,000 DOE Bonus $20,000-$100,000 depending on firm’s profitability'),(2,13,0,'no','no','no','no',''),(3,14,0,'no','no','no','no',''),(4,15,0,'no','no','no','no',''),(5,16,0,'Candidates must be able to Prepare and analyze bulk asbestos samples,\r\nMaintain TEM and all machines\r\n Flexible with hours, we are a sister company to an Environmental consulting firm who does 24/7 emergency response. ',' Bachelors’ degree in Geology, Microbiology or other related field\r\n                Experience only\r\n                Will also be helping with other office tasks ','no','no',''),(6,17,0,'- Computer and internet connectivity access.\r\n- Basic understanding of SEO/SEM practices and principles  ','Self-motivation; this is a remote position\r\nBe creative, critical, and articulate\r\nGood understanding of Social Media\r\nBe able to reach out to other blogger\'s to get guest posted.\r\nHave strong research/analysis skills. Check facts well.\r\nAbility to meet deadlines without fail\r\nExcellent grammar and written communication skills\r\nWillingness to learn a new application to publish blogs.\r\nVery basic HTML understanding\r\nAbility to handle delegated tasks','no','no','Rates will vary but will generally range from $10-18 USD per post with word ranging from 350-500 minimum words and we have flexibility to post 2 to 5 articles per week.'),(7,18,0,'no','no','no','no','Liberal Arts majors will enjoy priority, linguistics / Literature, Education/ Medicine Age: 25—50'),(8,19,0,'no','no','no','no',''),(9,21,0,'My name is Joshua Cuthbert, the recruitment office of J & J LIMITED, producer of various clothing materials, batiks, assorted fabrics and traditional costume.we are into investment generally.we wish to notify you on a job opening in the U.S. as a company representative. Please reply only if you will like to work from home part-time and get paid weekly without leaving or it affecting your present job.J&J LIMITED needs a book-keeper in the states, so i want to know if you will like to work online ','no','no','no',''),(10,23,0,'no','no','no','no',''),(11,51,0,'Working with people','Working with people','Working with people','Working with people','$2000');
/*!40000 ALTER TABLE `post_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_parties`
--

DROP TABLE IF EXISTS `post_parties`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `post_parties` (
  `id` int(11) NOT NULL auto_increment,
  `post_id` int(11) NOT NULL,
  `start_time` datetime default NULL,
  `end_time` datetime default NULL,
  `location` varchar(255) NOT NULL,
  `street` varchar(255) NOT NULL,
  `intersection` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post_parties`
--

LOCK TABLES `post_parties` WRITE;
/*!40000 ALTER TABLE `post_parties` DISABLE KEYS */;
INSERT INTO `post_parties` VALUES (1,45,'2009-09-15 10:31:10','2009-09-15 14:31:00','123','abc','','xyz'),(2,46,'2009-10-20 10:34:00','2009-04-04 01:35:00','123','abc','','xyz');
/*!40000 ALTER TABLE `post_parties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_party_rsvps`
--

DROP TABLE IF EXISTS `post_party_rsvps`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `post_party_rsvps` (
  `id` int(11) NOT NULL auto_increment,
  `post_party_id` int(11) default NULL,
  `where` varchar(255) default NULL,
  `when` datetime default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `tel` varchar(255) default NULL,
  `message` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post_party_rsvps`
--

LOCK TABLES `post_party_rsvps` WRITE;
/*!40000 ALTER TABLE `post_party_rsvps` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_party_rsvps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_teamups`
--

DROP TABLE IF EXISTS `post_teamups`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `post_teamups` (
  `id` int(11) NOT NULL auto_increment,
  `post_id` int(11) NOT NULL,
  `teamup_category_id` int(11) NOT NULL,
  `opportunity_type` varchar(255) default NULL,
  `position_title` varchar(255) default NULL,
  `expected_time_commit` varchar(255) default NULL,
  `functional_experience_id` int(11) default NULL,
  `compensation_offered` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post_teamups`
--

LOCK TABLES `post_teamups` WRITE;
/*!40000 ALTER TABLE `post_teamups` DISABLE KEYS */;
INSERT INTO `post_teamups` VALUES (1,49,5,'','','1',1,'Cash'),(2,50,4,'','','1',1,'None');
/*!40000 ALTER TABLE `post_teamups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_tutors`
--

DROP TABLE IF EXISTS `post_tutors`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `post_tutors` (
  `id` int(11) NOT NULL auto_increment,
  `post_id` int(11) default NULL,
  `tutoring_rate` varchar(255) default NULL,
  `per` varchar(255) default NULL,
  `currency` varchar(255) default NULL,
  `from` datetime default NULL,
  `to` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post_tutors`
--

LOCK TABLES `post_tutors` WRITE;
/*!40000 ALTER TABLE `post_tutors` DISABLE KEYS */;
INSERT INTO `post_tutors` VALUES (1,43,'25','Hour','USD',NULL,NULL),(2,44,'20','Hour','USD',NULL,NULL);
/*!40000 ALTER TABLE `post_tutors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `post_category_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `school_id` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `use_this_email` tinyint(1) default NULL,
  `telephone` varchar(255) default NULL,
  `allow_comment` tinyint(1) default '1',
  `allow_response` tinyint(1) default '1',
  `allow_rate` tinyint(1) default '1',
  `allow_download` tinyint(1) default '1',
  `type_name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `attach_file_name` varchar(255) default NULL,
  `attach_content_type` varchar(255) default NULL,
  `attach_file_size` int(11) default NULL,
  `attach_updated_at` datetime default NULL,
  `count_view` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (1,6,7,'A College Student\'s Guide to Computers in Education ','This short book is for undergraduate and graduate college and university students, and for others thinking about enrolling in higher education courses. The information and ideas presented will help you to obtain an education that will be useful to you throughout your life in our rapidly changing Information Age world.',1,21,'',0,'',1,1,1,1,NULL,'2009-04-02 04:17:33','2009-04-03 03:14:51',NULL,NULL,NULL,NULL,3),(2,4,7,'The Civilization of China ','by Herbert A. Giles\r\nPublisher: Historical Text Archive 1990\r\nISBN/ASIN: 8132029321\r\nISBN-13: 9788132029328\r\nNumber of pages: 116\r\n\r\nThe aim of this work is to suggest a rough outline of Chinese civilization from the earliest times down to the present period of rapid and startling transition. It has been written, primarily, for readers who know little or nothing of China, in the hope that it may succeed in alluring them to a wider and more methodical survey.',7,129,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-02 07:43:51','2009-04-02 07:45:29',NULL,NULL,NULL,NULL,1),(3,4,7,'Sams Teach Yourself Microsoft SQL Server 7 in 21 Days ','by Richard Waymire, Rick Sawtell\r\n\r\nPublisher: Sams 1998\r\nISBN/ASIN: 0672312905\r\nISBN-13: 9780672312908\r\nNumber of pages: 800\r\n\r\nDescription:\r\nThe book introduces you to every aspect of Microsoft\'s flagship back-end database engine. Organized with a FAQ-like summary at the end of every chapter, the book familiarizes you with all the features and even brings you up to expert level on a few of them. Waymire and Sawtell explain how to install the software under Windows NT Server 4. After a quick synopsis of the tools and utilities on the SQL Server CD-ROM, the authors walk you through the process of creating databases and establishing accounts for the people and processes that will access them.',7,11,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-02 08:03:30','2009-04-02 08:03:30',NULL,NULL,NULL,NULL,0),(4,4,7,'A Text-book of the History of Architecture','A Text-book of the History of Architecture\r\nby Alfred D. F. Hamlin\r\n\r\nPublisher: Longmans, Green, & Co. 1909\r\nISBN/ASIN: B001F308OY\r\nNumber of pages: 323\r\n\r\nDescription:\r\nThe aim of this work has been to sketch the various periods and styles of architecture with the broadest possible strokes, and to mention, with such brief characterization as seemed permissible or necessary, the most important works of each period or style. Extreme condensation in presenting the leading facts of architectural history has been necessary, and much that would rightly claim place in a larger work has been omitted here.',7,129,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-02 08:09:49','2009-04-02 08:09:49',NULL,NULL,NULL,NULL,0),(5,4,7,'American Urban Architecture: Catalysts in the Design of Cities ','American Urban Architecture: Catalysts in the Design of Cities\r\nby Wayne Attoe, Donn Logan\r\n\r\nPublisher: University of California Press 1992\r\nISBN/ASIN: 0520081056\r\nISBN-13: 9780520081055\r\nNumber of pages: 208\r\n\r\nDescription:\r\nConceiving of urban design in terms of architectural actions and reactions, Attoe and Logan propose a theory of \"catalytic architecture\" better suited to specifically American circumstances than the largely European models developed in the last thirty years for the remaking of cities. After exploring instances of failed attempts to impose European visions on American cities, the authors examine urban design successes that illustrate the principles and goals of catalytic architecture.',7,105,'ani@gmail.com',1,'',1,1,1,1,NULL,'2009-04-02 08:14:49','2009-04-02 08:14:49',NULL,NULL,NULL,NULL,0),(6,4,7,'Romantic Castles and Palaces: As Seen and Described by Famous Writers ','Romantic Castles and Palaces: As Seen and Described by Famous Writers\r\nby Esther Singleton\r\n\r\nPublisher: Dodd, Mead & Company 1901\r\nISBN/ASIN: B000J54YZ8\r\n\r\nDescription:\r\nThis is a collection of essays on forty-eight pretty spectacular castles and palaces from around the world. The authors are Sir Walter Scott, Alexandre Dumas, Robert Louis Stevenson, Nathaniel Hawthorne, and many more. The pictures were taken before the book was published in 1901. How these structures appeared over 100 years ago is of some interest, for comparison with their modern appearance.',7,11,'ani@gmail.com',1,'',1,1,1,1,NULL,'2009-04-02 08:16:49','2009-04-02 08:16:49',NULL,NULL,NULL,NULL,0),(7,4,7,'Book-Keeping and Accounting for Small Business ','Book-Keeping and Accounting for Small Business\r\nby Peter Taylor\r\n\r\nPublisher: How to Books 2008\r\nISBN/ASIN: 1857038789\r\nISBN-13: 9781857038781\r\nNumber of pages: 260\r\n\r\nDescription:\r\nAccounts are just as important as any other aspect of a business, and can be crucial to its prosperity and even survival. In \"doing the books\" you will be at the very heart of the business, with your hands on the controls. You will be involved in the management of its assets and liabilities, its expenses and its profit margins. The more control you have over these, and the records and figurework on which they are based, the better you will be able to control your own business.',7,119,'ani@gmail.com',1,'',1,1,1,1,NULL,'2009-04-02 08:20:39','2009-04-02 08:20:39',NULL,NULL,NULL,NULL,0),(8,4,7,'Mastering Book-Keeping','Mastering Book-Keeping\r\nby Peter Marshall\r\n\r\nPublisher: How to Books 2006\r\nISBN/ASIN: 1845280725\r\nISBN-13: 9781845280727\r\nNumber of pages: 245\r\n\r\nDescription:\r\nThis popular book has helped thousands of people to learn book-keeping. It explains the principles of book-keeping, including the bank reconciliation, extracting a trial balance, writing up the petty cash book, accruals and prepayments, accounting for VAT, setting up a Limited Company, compiling a balance sheet, accounting for doubtful debts, etc.',7,119,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-02 08:22:14','2009-04-02 08:22:14',NULL,NULL,NULL,NULL,0),(9,4,7,'How to Make a Complete Map of Every Thought you Think ','How to Make a Complete Map of Every Thought you Think\r\nby Lion Kimbro\r\n\r\n2003\r\nNumber of pages: 131\r\n\r\nDescription:\r\nThis book is about how to make a complete map of everything you think for as long as you like. Keeping a map of all your thoughts has a \"freezing\" effect on the mind. It takes a lot of (albeit pleasurable) work, but produces nothing but SIGHT. If you do the things described in this book, you will be IMMOBILIZED for the duration of your commitment.',7,81,'ani@gmail.com',1,'',1,1,1,1,NULL,'2009-04-02 08:28:21','2009-04-02 08:28:21',NULL,NULL,NULL,NULL,0),(10,4,7,'How We Got Here: A Slightly Irreverent History of Technology and Markets ','How We Got Here: A Slightly Irreverent History of Technology and Markets\r\nby Andy Kessler\r\n\r\nPublisher: Collins Business 2005\r\nISBN/ASIN: 0060840978\r\nISBN-13: 9780060840976\r\nNumber of pages: 272\r\n\r\nDescription:\r\nBest-selling author Andy Kessler ties up the loose ends from his provocative book, Running Money, with this history of breakthrough technology and the markets that funded them. Expanding on themes first raised in his tour de force, Running Money, Andy Kessler unpacks the entire history of Silicon Valley and Wall Street, from the Industrial Revolution to computers, communications, money, gold and stock markets. These stories cut (by an unscrupulous editor) from the original manuscript were intended as a primer on the ways in which new technologies develop from unprofitable curiosities to essential investments. Indeed, How We Got Here is the book Kessler wishes someone had handed him on his',7,11,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-02 08:36:39','2009-04-13 20:29:01',NULL,NULL,NULL,NULL,2),(11,4,7,'In Search of Insight ','In Search of Insight\r\nby Charles Nicholls\r\n\r\nPublisher: SeeWhy Software 2006\r\nNumber of pages: 43\r\n\r\nDescription:\r\nThe traditional data warehouse has enabled significant advances in the use of information, but its underlying architectural approach is now being questioned. It\'s architecture limits the ability to optimize every business process by embedding BI capabilities within. We need to look to event driven, continuous in-process analytics to replace batch driven reporting on processes after the fact. In short, how can we build smarter business processes which give organizations competitive advantage? How can we build the intelligent business? This eBook sets out to answer this question, and to provide a roadmap setting out how we can get there. It\'s called BI 2.0.',7,11,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-02 08:38:37','2009-04-21 18:00:59',NULL,NULL,NULL,NULL,2),(12,4,8,'Audit Partner/Principal - ASAP - Boston','Position:  Audit Partner / Principal\r\nLocation:  Boston, MA\r\nSalary:  200K – 300K Plus Bonus\r\nBenefits:  Yes\r\nRelocation:  No',7,119,'',0,'',1,1,1,1,NULL,'2009-04-02 08:55:16','2009-04-02 08:55:16',NULL,NULL,NULL,NULL,0),(13,4,8,'Financial Reporting Analyst, Atlanta','Large Atlanta based corporation has need for degreed accountant with solid financial reporting experience. This position will assist with the filing of SEC reports as well as accounting research activities and other financial reporting matters. Prior SEC reporting experience preferred. The ideal candidate will have two plus years of Big 4 public accounting audit experience. Candidate must have CPA or be on a CPA track. ',7,119,'',1,'',1,1,1,1,NULL,'2009-04-02 09:08:11','2009-04-02 09:08:11',NULL,NULL,NULL,NULL,0),(14,4,8,'Full-time English Teachers - Bujeon-dong, Busanjin-gu, Busan City 614-030, South Korea',' Full-time English Teachers Wanted at Herald Media Busan Global Village, South Korea\r\nHerald Media Busan Global Village is an English-educating semi-public school, located Bujeon-dong, Busanjin-gu, Busan City, South Korea. It is not like usual private hagwons, but a semi-public school subsidized by Busan City Government and operated by the Herald Media, which publishes the Korea Herald, Korea\'s No. 1 English Newspaper.\r\n- Working hours: 8 working hours 9 a.m. - 6 p.m.\r\n \r\n- Job description: Teaching',7,58,'',0,'',1,1,1,1,NULL,'2009-04-02 09:17:29','2009-04-02 09:17:29',NULL,NULL,NULL,NULL,0),(15,4,8,'Part Time Dance Instructor - Charlotte','New studio is seeking part-time employment. Instructors are needed in the following disciplines:\r\n\r\nBallet – strong technical background required\r\nHip Hop – skilled choreographer required\r\nTumbling - strong technical background required\r\nOther – we would love to expand our offerings. If you have an idea for a dance class, we would love to hear from you!\r\n',7,11,'',0,'',1,1,1,1,NULL,'2009-04-02 09:24:20','2009-04-04 02:33:01',NULL,NULL,NULL,NULL,0),(16,4,8,'TEM Analyst - Denver, CO','This position is full time for a TEM Analyst. River North Environmental testing is a full service asbestos lab. ',7,60,'',0,'',1,1,1,1,NULL,'2009-04-02 09:42:23','2009-04-04 02:37:12',NULL,NULL,NULL,NULL,0),(17,4,8,'Financial Analyst Blog/Economist Writer - - US','no',7,58,'',0,'',1,1,1,1,NULL,'2009-04-02 09:52:13','2009-04-04 02:36:40',NULL,NULL,NULL,NULL,0),(18,4,8,'a full time lecturer needed in Dalian Medical University','Dalian Medical University lies in liaoning.It is hiring a full time lecturer.High salary is offered to right applicants.If you are interested in it,you need to qualify following conditions : 0ne positions, We are looking for teachers with a university degree and at least one-year teaching experience or a degree with TESL certificate but no teaching experience; Over two year natively or abroad and Native English speakers from America, U.K., Canada, Australia, New Zealand or Ireland and etc.Libera',7,58,'',0,'',1,1,1,1,NULL,'2009-04-03 01:57:56','2009-04-04 02:35:53',NULL,NULL,NULL,NULL,0),(19,4,8,'Sales Service Manager  (USA, Los Angeles) ','Joining to our Fair Mail Program for employees you’ll have $1,900 per month as a based salary (after 2months trial period) + $25 per each finished order (from the very moment of your start). The progress of your salary is shown in your account at http://www.charcc.com in real time. You can get money from your account every month via WU or PayPal on your choice.',7,81,'',0,'',1,1,1,1,NULL,'2009-04-03 02:10:14','2009-04-04 02:40:18',NULL,NULL,NULL,NULL,0),(20,6,3,'Online Catering Ordering site for national chain','I am looking for a reputable company with experience to design and build an online catering ordering website for a national restaurant chain.',1,18,'',0,'',1,1,1,1,'Projects','2009-04-03 02:14:49','2009-04-03 02:14:49',NULL,NULL,NULL,NULL,0),(21,4,8,'PART TIME JOB POSITION!!!! (Los Angeles)','no',7,45,'',1,'',1,1,1,1,NULL,'2009-04-03 02:16:39','2009-04-04 02:35:09',NULL,NULL,NULL,NULL,0),(22,6,3,'Tourism Destination Portal','We\'re seeking a destination portal solution. A templated solution which allows us to manage destination content with rich media and has built-in social networking capabilities.',1,21,'',0,'',1,1,1,1,'Projects','2009-04-03 02:21:53','2009-04-03 02:21:53',NULL,NULL,NULL,NULL,0),(23,4,8,'Opportunity for Sales Professionals: Web Services','One of the leading Web Services provider, Vinove (www.vinove.com) is looking for a Business development professional in the US. As a full time employee, you will be able to bootstrap the entire business development process in the US market and provide post sales support as well. Minimum 2 years of relevant experience in selling IT services and technical competency will give you an edge over other job applicants.',7,25,'',0,'',1,1,1,1,NULL,'2009-04-03 02:22:47','2009-04-17 19:46:06',NULL,NULL,NULL,NULL,3),(25,6,3,'A Resources For Community Of Webmasters ','I\'m having a project, I just run it as beta for now. It\'s a website that shows people the web navigations (css, flash, DHTML menu). They can copy/paste the source code, download the source file and use it for their website for free. To sum up, it\'s a website navigations library for webmasters.\r\n\r\nI\'m looking for partners who can join me, add more resources, manage the site with me. Join as a group and we will develop it to a large source site. Now I\'m the only person runs this site. It\'s serious project. For people, for community.',1,18,'',0,'',1,1,1,1,'Projects','2009-04-03 02:32:48','2009-04-03 02:32:48',NULL,NULL,NULL,NULL,0),(26,4,2,' Announcing the recognition of IELTS by the UK Border Agency  ','Home Office for Tier 2 of the points based system (PBS) which comes in to effect on 27th November 2008',7,105,'',0,'',1,1,1,1,'Tests','2009-04-03 02:37:11','2009-04-04 02:46:36','press_release_London_27_nov_2008.doc','application/msword',239616,NULL,0),(27,4,2,'English Testing Advice for Studying in the USA','The TOEFL test is considered the global standard for English language proficiency. By scoring well on the TOEFL test, you will be eligible for admission to virtually any school in the world, including top colleges and universities in the United States. In fact, more than 6,000 universities and institutions in 110 countries accept the TOEFL test as part of their rigorous admissions criteria. Registering is easy, but test centers do fill up quickly. To locate a test center near you, go to Click HereTOEFLGoAnywhere.org and select from more than 4,300 TOEFL test centers around the globe.',7,87,'',0,'',1,1,1,1,'Tests','2009-04-03 02:45:39','2009-04-04 02:46:06',NULL,NULL,NULL,NULL,0),(28,4,2,'Payroll policy in the USA','Complete the sentence\r\nhttp://www.english-test.net/esl/learn/english/grammar/ai108/esl-test.php',7,58,'',0,'',1,1,1,1,'Tests','2009-04-03 02:50:25','2009-04-03 02:50:25',NULL,NULL,NULL,NULL,0),(29,4,2,'All-Star - Book 1 (Beginning) - USA Post-Test Study Guide ','by Linda Lee, Stephen Sloan, Jean Bernard, Grace Tanaka, Kristin Sherman',7,85,'',0,'',1,1,1,1,'Tests','2009-04-03 02:55:06','2009-04-04 02:45:16',NULL,NULL,NULL,NULL,0),(30,4,11,'Jaqi','Location: Berlin, Germany\r\nJaqi is looking to live with : Female roommates\r\nJaqi is : NOT a smoker\r\nJaqi does : NOT require a private bath\r\nJaqi does : need to be next to public transportation\r\nJaqi does : NOT have a pet',7,81,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-03 09:24:17','2009-04-06 16:46:12',NULL,NULL,NULL,NULL,1),(31,4,11,'Gaia','Location: Macungie, PA USA\r\nRoom Information\r\nGaia is seeking: Female only roommates\r\nPets are: NOT accepted\r\nSmokers are: accepted\r\nLease is: negotiable\r\nSecurity deposit is: required\r\nPublic transportation is: available\r\nRoom is: NOT furnished\r\nRoom does: have a private bathroom\r\n',7,129,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-03 09:27:58','2009-04-13 20:26:32',NULL,NULL,NULL,NULL,4),(32,4,1,'Homework tips for Parents','Homework has been a part of students’ lives since the\r\nbeginning of formal schooling in the United States.\r\nHowever, the practice has sometimes been accepted and\r\nother times rejected, both by educators and parents. This\r\nhas happened because homework can have both positive\r\nand negative effects on children\'s learning and attitudes\r\ntoward school.',7,85,'',0,'',1,1,1,1,'Assignments','2009-04-04 01:46:21','2009-04-04 02:05:54','homeworktips.pdf','application/pdf',172796,NULL,1),(33,4,1,' The Edutopia Poll','No more pencils, no more books? Not so for many students, who are increasingly expected to complete homework assignments over the summer -- anything from reading lists to essays to intricate math problems. The practice is intended to combat the summer learning loss that affects all students. Though proponents argue that summer homework helps students maintain their academic skills, many students and their families resent mandatory work over vacation. In fact, in 2005, a Wisconsin teen sued his math teacher, the school district, and the state department of education, arguing that his school was outside of its rights to assign work before his class technically began. (The suit was dismissed.) Is summer homework an unfair burden to place on families, or is it a reasonable response to summer learning loss? Tell us what you think!',7,111,'',0,'',1,1,1,1,'Assignments','2009-04-04 01:52:05','2009-04-04 02:26:07',NULL,NULL,NULL,NULL,2),(34,4,1,'Social Issues','This web page has been created to meet the needs of Multnomah County middle and high school students researching current social issues from multiple perspectives.',7,11,'',0,'',1,1,1,1,'Assignments','2009-04-04 01:54:33','2009-04-04 02:25:21',NULL,NULL,NULL,NULL,1),(35,4,1,'Education, home, revision, homework, learning, exam, tutor, GCSE ...','Study Revision: Revise, home learning, course work, maths, tutoring, German, French, English essays & exams\r\n\r\nhttp://www.silversurfers.net/education-revision.html',7,105,'',0,'',1,1,1,1,'Assignments','2009-04-04 02:01:43','2009-04-04 02:24:32',NULL,NULL,NULL,NULL,0),(36,4,1,'A Teacher’s Guide to Homework Tips for ',' \r\nThis document was prepared by Harris M. Cooper under contract ED-02-PO-0332 and \r\nRussell M. Gersten under contract ED-02-PO-0559 to the U.S. Department of Education. \r\n \r\nThis report does not necessarily reflect the position or the policy of the Department, and \r\nno official endorsement by the Department should be inferred. \r\n \r\n ',7,45,'',0,'',1,1,1,1,'Assignments','2009-04-04 02:08:38','2009-04-04 02:08:38','homework-speaker.pdf','application/pdf',192828,NULL,0),(37,4,1,' HOMEWORK … A LESSON IN FRUSTRATION ','HOMEWORK … A LESSON IN FRUSTRATION \r\nThe Gathered View- September-November 1999  \r\nby Barb Dorn, PWSA (USA) President, and Executive Director, PWSA of Wisconsin \r\n\r\nOver the past eight years, I have learned to hate the concept of homework for my son who has PWS.  He \r\nis now entering eighth grade.  It has only been within the past two years that  I have been successful in \r\nstopping this practice.  It was either stop it or allow it to destroy our family time.  The following editorial \r\narticle is my family’s view on this common educational practice.  As my son grew older, the challenges of \r\nhomework grew more intense.  There may be students who have PWS and families who do not face this \r\nchallenge.  But for those of us who do … this article is for you. ',7,25,'',1,'',1,1,1,1,'Assignments','2009-04-04 02:12:47','2009-04-20 00:45:00','Homework-ED-01.pdf','application/pdf',69121,NULL,1),(38,4,1,'FHAO Daily Lesson Plan 1st 9wks (WP)','Facing  History  and  Ourselves:    Daily  Lesson  Plans\r\nFirst  Nine  Weeks:  8/11  -  10/10',7,129,'',0,'',1,1,1,1,'Assignments','2009-04-04 02:16:44','2009-04-21 17:43:37','FHAO Daily Lesson Plan 1st 9wks (WP).pdf','application/pdf',59197,NULL,3),(39,4,1,'EFFECTIVE \"HOMEWORK-FREE\" BME PHYSIOLOGY INSTRUCTION','I. INTRODUCTION\r\nThe hypothesis of this study is that learning of systems\r\nphysiology concepts including  neurophysiology is more\r\neffective and efficient when in-class quizzes and activities\r\nwith instant feedback are used in place of traditional learning\r\nactivities including homework.  While the author found no\r\npublished references regarding the use of homework for\r\nphysiology instruction, a review [1] of 84 experiments that\r\ndealt with homework in general revealed that 34 experiments\r\nsupported the use of homework over other learning methods\r\nand 49 experiments found similar achievement using\r\nhomework and other methods of learning.',7,87,'',0,'',1,1,1,1,'Assignments','2009-04-04 02:20:06','2009-04-24 16:32:35','BMES_007.pdf','application/pdf',76079,NULL,6),(40,4,5,'Lessons from K-12 Distance Education in the U.S.A., 1986-2008','Distance education for elementary and secondary school students in North America has \r\ngrown and evolved over a century from mail-based correspondence courses for small \r\nnumbers of geographically dispersed learners to the millions of learners now using online \r\ncourses in virtual schools. This article focuses on effective practices emerging from the \r\nmodern electronic generation of K-12 distance education programs existing in the United \r\nStates between 1986 and 2008. ',7,45,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-04 02:51:09','2009-04-15 23:18:35','ArticleCCavanaugh.pdf','application/pdf',116280,NULL,3),(41,4,5,'Global Campaign for Education– US  ','Fact Sheet:   \r\n \r\nThe Global Education Crisis \r\n',7,25,'ani@gmail.com',1,'',1,1,1,1,NULL,'2009-04-04 02:56:20','2009-04-04 02:56:20','GCE-USA-Media-FactSheet.pdf','application/pdf',71346,NULL,0),(42,4,5,'U.S. Department of Education Budget Office','Welcome to the Budget home page of the United States Department of Education. Provides information on the FY 2008 President\'s Education Budget Request',7,105,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-04 03:06:26','2009-04-17 00:47:13',NULL,NULL,NULL,NULL,8),(43,4,6,'Exceptional Pay for Exceptional Tutors','A rapidly growing private tutoring company is seeking devoted professionals with excellent communication skills to work one-on-one with students in their homes or other convenient locations. Currently, we have PART TIME opportunities for tutors with subject expertise in ACT, MATH, PHYSICS, CHEMISTRY, ENGLISH and ELEMENTARY EDUCATION in the North Shore, Chicago and Hinsdale areas.  As a tutor, you will enjoy competitive compensation and flexible afternoon, evening and/or weekend scheduling. Pay begins at $25 per hour ( or higher) depending on qualifications, plus a travel stipend. Performance-based hourly increases, paid training and an exceptional support network of professionals are just a few of the many reasons to join our dynamic team! If you enjoy motivating students and are able to demonstrate relevant background knowledge and teaching skills, please send an email outlining your ex',7,142,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-04 03:23:46','2009-04-17 19:46:29',NULL,NULL,NULL,NULL,2),(44,4,6,'Part-Time Tutor','Location: Fairfax County, VA 20124 ( map it!Map it )\r\nEmployee Type: Part-Time Employee\r\nIndustry: Education - Teaching - Administration\r\nJob Type: Education\r\nEducation: 4 Year Degree\r\nExperience: Not Specified\r\n\r\n',7,129,'ani@gmail.com',1,'',1,1,1,1,NULL,'2009-04-04 03:28:32','2009-04-24 21:14:00',NULL,NULL,NULL,NULL,1),(45,4,9,'Happy Birthday','15/9/1986',7,120,'',0,'',1,1,1,1,NULL,'2009-04-04 03:32:37','2009-04-04 03:32:37',NULL,NULL,NULL,NULL,0),(46,4,9,'My mother\'s Birthday','I love my mother',7,118,'',0,'',1,1,1,1,NULL,'2009-04-04 03:36:57','2009-04-27 01:45:08',NULL,NULL,NULL,NULL,1),(47,4,10,'HORIKAWA JUNKO(Sangyoidai Sangyohoken Daisankangogaku)   MAJIMA YUKIE(Sangyoidai Sangyohoken Daisankangogaku)   ISHIHARA ITSUKO(Sangyoidai Sangyohoken Daisankangogaku)   ','Students Awareness of Health Teaching: Evaluation of \"Health Education\" Course and the Occupational Health Nursing Practice.\r\nThe \"health education\" course is an important part of the baccalaureate curriculum in nursing. It is essential to teach students effective health education in a client oriented way. In order to improve the quality and content of this course, we extracted students descriptions from records of 44 students who had carried out group health education during nursing practice for the occupational health nursing course. We then analyzed students written sentences on their views concerning health teaching. After sentence analysis, we categorized these concepts into groups and titled them.',7,60,'',0,'',1,1,1,1,NULL,'2009-04-04 03:43:15','2009-04-17 23:28:47',NULL,NULL,NULL,NULL,3),(48,4,10,'American Association of Colleges of Pharmacy','Awareness of Public Health and Pharmacy Careers in High School Students.\r\nIn partnership with the George Washington High School for Health Careers and Science, located in a predominantly Hispanic area of New York City, the Touro College of Pharmacy initiated a new elective course on medications and their use for the second semester of the 2007-2008 school year. The partnership will increase awareness of the profession of pharmacy among the high school students and the teachers advising them. The course was designed to introduce students to areas of medication use from a multicultural perspective, with details on specific applications in the US healthcare system. High school seniors comprise around ninety percent of the class',7,111,'',0,'',1,1,1,1,NULL,'2009-04-04 03:47:12','2009-04-15 07:28:47',NULL,NULL,NULL,NULL,2),(49,4,12,'Baseball team AUM','Baseball team\r\nAuburn University at Montgomery',7,128,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-04 03:59:10','2009-04-15 02:43:14',NULL,NULL,NULL,NULL,2),(50,4,12,'Football team AUM','Football team\r\nAuburn University at Montgomery',7,81,'ani@gmail.com',0,'',1,1,1,1,NULL,'2009-04-04 04:00:49','2009-04-27 01:44:15',NULL,NULL,NULL,NULL,9),(51,8,8,'Student Employee','Hello',3,19,'johnhuynh04@gmail.com',1,'',1,1,1,1,NULL,'2009-04-04 20:49:34','2009-04-17 19:46:02',NULL,NULL,NULL,NULL,2),(52,1,10,'hello','No much',3,31,'',1,'',1,1,1,1,NULL,'2009-04-21 04:59:58','2009-04-21 04:59:58',NULL,NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rates`
--

DROP TABLE IF EXISTS `rates`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rates` (
  `id` int(11) NOT NULL auto_increment,
  `post_id` int(11) default NULL,
  `rateable_id` int(11) default NULL,
  `rateable_type` varchar(255) default NULL,
  `stars` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_rates_on_post_id` (`post_id`),
  KEY `index_rates_on_rateable_id` (`rateable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `rates`
--

LOCK TABLES `rates` WRITE;
/*!40000 ALTER TABLE `rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `roles_users` (
  `role_id` int(11) default NULL,
  `user_id` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
INSERT INTO `roles_users` VALUES (1,1);
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20081023115224'),('20081027080254'),('20090112044548'),('20090112083851'),('20090112093503'),('20090113071646'),('20090113071804'),('20090114013615'),('20090123043341'),('20090130081804'),('20090131024111'),('20090131024615'),('20090131025159'),('20090131034034'),('20090203142742'),('20090205043852'),('20090206143555'),('20090211085610'),('20090212074920'),('20090212075551'),('20090212080116'),('20090212080541'),('20090212080629'),('20090212080711'),('20090212080902'),('20090212081320'),('20090212081646'),('20090212082001'),('20090212082209'),('20090212083147'),('20090212084215'),('20090212085335'),('20090212085608'),('20090212090550'),('20090212091310'),('20090212091724'),('20090212092443'),('20090212092947'),('20090212093421'),('20090212095326'),('20090212095754'),('20090212095827'),('20090212095950'),('20090212100320'),('20090212100512'),('20090212100610'),('20090216020705'),('20090217030149'),('20090217044108'),('20090218135539'),('20090222083000'),('20090222090614'),('20090227151602'),('20090318035301'),('20090318100039'),('20090318145444'),('20090318145618'),('20090318145723'),('20090321021554'),('20090321021811'),('20090321022000'),('20090321022210'),('20090321022555'),('20090321022933'),('20090324042952'),('20090326041835'),('20090326043213'),('20090401095209'),('20090402021422'),('20090430043138'),('20090430101854');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schools`
--

DROP TABLE IF EXISTS `schools`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schools` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `city_id` int(11) NOT NULL,
  `type_school` varchar(255) NOT NULL,
  `website` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `schools`
--

LOCK TABLES `schools` WRITE;
/*!40000 ALTER TABLE `schools` DISABLE KEYS */;
INSERT INTO `schools` VALUES (1,'Air University',1,'University','http://www.maxwell.af.mil/au/'),(2,'Alabama A&M University',2,'University','http://www.aamu.edu/'),(3,'Alabama State University',1,'University','http://www.alasu.edu/'),(4,'Amridge University ',1,'University','http://www.amridgeuniversity.edu/'),(5,'Athens State University',3,'University','http://www.athens.edu/'),(6,'Auburn University',4,'University','http://www.auburn.edu/'),(7,'Auburn University at Montgomery',1,'University','http://www.aum.edu/'),(8,'Birmingham-Southern College',5,'College','http://www.bsc.edu/'),(9,'Concordia  College-Selma',6,'College','http://www.concordiaselma.edu/'),(10,'Faulkner University',1,'University','http://www.faulkner.edu/'),(11,'Huntingdon College',1,'College','http://www.huntingdon.edu/'),(12,'Jacksonville State University ',7,'University','http://www.jsu.edu/'),(13,'Judson University ',8,'University','http://www.judson.edu/'),(14,'Miles College',9,'College','http://www.miles.edu/'),(15,'Oakwood University',10,'University','http://www.oakwood.edu/'),(16,'Samford University',5,'University','http://www.samford.edu/'),(17,'Southeastern Bible College ',5,'College','http://www.sebc.edu/'),(18,'Spring Hill College ',11,'College','http://www.shc.edu/'),(19,'Stillman College',12,'College','http://www.stillman.edu/'),(20,'Talladega College',13,'College','http://www.talladega.edu/'),(21,'Troy University (Main campus)',14,'University','http://www.troy.edu/'),(22,'Troy University (Dothan campus)',15,'University','http://dothan.troy.edu/'),(23,'Troy University (Montgomery campus)',1,'University','http://montgomery.troy.edu/'),(24,'Tuskegee University',16,'University','http://www.tuskegee.edu/'),(25,'United States Sports Academy ',17,'College','http://www.ussa.edu/'),(26,'University of Alabama System (Birmingham)',12,'University','http://www.uab.edu/'),(27,'University of Alabama System (Huntsville)',5,'University','http://www.uah.edu/'),(28,'University of Alabama System (Tuscaloosa Main campus)',10,'University','http://www.ua.edu/'),(29,'University of Mobile',11,'University','http://www.umobile.edu/'),(30,'University of Montevallo',18,'University','http://www.montevallo.edu/'),(31,'University of North Alabama ',19,'University','http://www.una.edu/'),(32,'University of South Alabama',11,'University','http://www.usouthal.edu/'),(33,'University of West Alabama',20,'University','http://www.uwa.edu/'),(34,'Alaska Bible College',21,'College','http://www.akbible.edu/'),(35,'Alaska Pacific University',22,'University','http://www.alaskapacific.edu/'),(36,'University of Alaska System (Anchorage)',22,'University','http://www.uaa.alaska.edu/'),(37,'University of Alaska System (Fairbanks)',23,'University','http://www.uaf.edu/'),(38,'University of Alaska System (Southeast)',24,'University','http://www.uas.alaska.edu/'),(39,'A.T. Still University of Health Sciences',25,'University','http://www.atsu.edu/'),(40,'American Indian College of Assemblies of God',26,'College','http://www.aicag.edu/'),(41,'Arizona State University ',27,'University','http://www.asu.edu/'),(42,'Arizona State University Polytehnic Campus  ',25,'University','http://www.poly.asu.edu/'),(43,'Arizona State university at the West Campus ',26,'University','http://www.west.asu.edu/'),(44,'Art Center Design College',28,'College','http://www.theartcenter.edu/'),(45,'DeVry University-Phoenix ',26,'University','http://www.phx.devry.edu/'),(46,'Embry-Riddle Aeronautical University',29,'University','http://www.erau.edu/'),(47,'Grand Canyon University ',26,'University','http://www.gcu.edu/'),(48,'Northcentral University',30,'University','http://www.ncu.edu/'),(49,'Northern Arizona University',31,'University','http://www.nau.edu/'),(50,'Prescott College',29,'College','http://www.prescott.edu/'),(51,'Southwestern College',26,'College','http://www.swcaz.edu/'),(52,'Thunderbird School of Global Management',26,'College','http://www.thunderbird.edu/'),(53,'University of Arizona',28,'University','http://www.arizona.edu/'),(54,'University of Phoenix',26,'University','http://www.phoenix.edu/'),(55,'Western International University',26,'University','http://www.wintu.edu/'),(56,'Arkansas Baptist College',32,'College','http://www.arkansasbaptist.edu/'),(57,'Arkansas State University',33,'University','http://www.astate.edu/'),(58,'Arkansas Tech University',34,'University','http://www.atu.edu/'),(59,'Central Baptist College',35,'College','http://www.cbc.edu/'),(60,'Harding University',36,'University','http://www.harding.edu/'),(61,'Henderson State University',35,'University','http://www.hsu.edu/'),(62,'Hendrix College',37,'College','http://www.hendrix.edu/'),(63,'John Brown University',38,'University','http://www.jbu.edu/'),(64,'Lyon College',39,'College','http://www.lyon.edu/'),(65,'Ouachita Baptist University',37,'University','http://www.obu.edu/'),(66,'Philander Smith College ',32,'College','http://www.philander.edu/'),(67,'Southern Aekansas University',40,'University','http://www.saumag.edu/'),(68,'University of Arkansas System',32,'University','http://www.uasys.edu/'),(69,'University of Arkansas System (Fayetteville)',41,'University','http://www.uark.edu/'),(70,'University of Arkansas System (Fort Smith)',42,'University','http://www.uafortsmith.edu/'),(71,'University of Arkansas System (Little Rock)',32,'University','http://www.ualr.edu/'),(72,'University of Arkansas System (Medical Sciences)',32,'University','http://www.uams.edu/'),(73,'University of Arkansas System (Monticello)',43,'University','http://www.uamont.edu/'),(74,'University of Arkansas System (Pine Bluff)',44,'University','http://www.uapb.edu/'),(75,'University of Central Arkansas',35,'University','http://www.uca.edu/'),(76,'University of the Ozarks ',45,'University','http://www.ozarks.edu/'),(77,'Williams Baptist College',46,'College','http://www.wbcoll.edu/'),(78,'Alliiant International University',47,'University','http://www.alliant.edu/'),(79,'Antioch University-Los Angeles ',48,'University','http://www.antiochla.edu/'),(80,'Art Center Design College',49,'College','http://www.artcenter.edu/'),(81,'Azusa Pacific University ',50,'University','http://www.apu.edu/'),(82,'Bethany College ',51,'College','http://www.bethany.edu/'),(83,'Bethesda Christian University',52,'University','http://www.bcu.edu/'),(84,'Biola University',53,'University','http://www.biola.edu/'),(85,'California Baptist University',54,'University','http://www.calbaptist.edu/'),(86,'California College of the Arts',55,'College','http://www.cca.edu/'),(87,'California Institute of the Arts ',56,'College','http://www.calarts.edu/'),(88,'California institute of Integral Studies ',55,'College','http://www.ciis.edu/'),(89,'California Institute of Technology',49,'College','http://www.caltech.edu/'),(90,'California Lutheran University',57,'University','http://www.callutheran.edu/'),(91,'California Pacific University ',58,'University','http://www.cpu.edu/'),(92,'Callifornia State University Systems ',59,'University','http://www.calstate.edu/'),(93,'Bakersfiled ',60,'College','http://www.csub.edu/'),(94,'California Maritime Academy',61,'College','http://www.csum.edu/'),(95,'California Polytechnic University San Lui Obispo ',62,'University','http://www.calpoly.edu/'),(96,'California State Polytechnic University Pomona',63,'University','http://www.csupomona.edu/'),(97,'Channel Islands',64,'College','http://www.csuci.edu/'),(98,'Chico',65,'College','http://www.csuchico.edu/'),(99,'Dominguez Hills ',66,'College','http://www.csudh.edu/'),(100,'East Bay ',67,'College','http://www.csueastbay.edu/'),(101,'Frenso',68,'College','http://www.csufresno.edu/'),(102,'Fullerton',69,'College','http://www.fullerton.edu/'),(103,'Long Beach ',59,'College','http://www.csulb.edu/'),(104,'Northridge',70,'College','http://www.csun.edu/'),(105,'Sacramento',71,'College','http://www.csus.edu/'),(106,'San Bernardio',72,'College','http://www.csusb.edu/'),(107,'San Marcos ',73,'College','http://www.csusm.edu/'),(108,'Humboldt State University ',74,'University','http://www.humboldt.edu/'),(109,'San Diego State University ',47,'University','http://www.sdsu.edu/'),(110,'San Francisco State University',55,'University','http://www.sfsu.edu/'),(111,'San Jose State University',75,'University','http://www.sjsu.edu/'),(112,'Sonoma State University',76,'University','http://www.sonoma.edu/'),(113,'Chapman University ',77,'University','http://www.chapman.edu/'),(114,'Charles R. Drew University of Medicine z& Science',78,'University','http://www.cdrewu.edu/'),(115,'Church Divinity School of Pacific ',79,'College','http://www.cdsp.edu/'),(116,'Clatemont Consortiym of College ',80,'College','http://www.claremont.edu/'),(117,'Claremont Graduate University',81,'University','http://www.cgu.edu/'),(118,'Claremont Mc Kenna College',81,'College','http://www.cgu.edu/'),(119,'Harvey Mudd College',81,'College','http://www.hmc.edu/'),(120,'Keck Graduate Institute of Applied Life Sciences',81,'College','http://www.kgi.edu/'),(121,'Pitzer College',81,'College','http://www.pitzer.edu/'),(122,'Pomona College ',81,'College','http://www.pomona.edu/'),(123,'Scripps College ',81,'College','http://www.scrippscollege.edu/'),(124,'Cogswell Polytechnical College',82,'College','http://www.cogswell.edu/'),(125,'Concordia University-Irvine ',83,'University','http://www.cui.edu/'),(126,'DeVry University-Long Beach',59,'University','http://www.lb.devry.edu/'),(127,'DeVry University-Pomona ',63,'University','http://www.pom.devry.edu/'),(128,'Dominican School of Philosophy & Theology',79,'College','http://www.dspt.edu/'),(129,'Dominican University of California',84,'University','http://www.dominican.edu/'),(130,'Fielding Graduate Institute ',85,'College','http://www.fielding.edu/'),(131,'Franciscan School of Theology',79,'College','http://www.fst.edu/'),(132,'Fresno Pacific University',68,'University','http://www.fresno.edu/'),(133,'Fuller Theological Seminary',49,'College','http://www.fuller.edu/'),(134,'Golden Gate University',55,'University','http://www.ggu.edu/'),(135,'Graduate theological Union',79,'College','http://www.gtu.edu/'),(136,'Holy Names University',86,'University','http://www.hnu.edu/'),(137,'Hope International University',69,'University','http://www.hiu.edu/'),(138,'humphreys College',87,'College','http://www.humphreys.edu/'),(139,'Institute of Transpersonal Psychology',88,'College','http://www.itp.edu/'),(140,'Jesuit School of Theology at Berkley',79,'College','http://www.jstb.edu/'),(141,'La Sierra University',54,'University','http://www.lasierra.edu/'),(142,'Life Pacific College',89,'College','http://www.lifepacific.edu/'),(143,'Lincoln University',86,'University','http://www.lincolnuca.edu/'),(144,'Loma Linda University ',90,'University','http://www.llu.edu/'),(145,'Loyola Marymount University',78,'University','http://www.lmu.edu/'),(146,'Marymount College',91,'College','http://www.marymountpv.edu/'),(147,'The Master\'s College',92,'College','http://www.masters.edu/'),(148,'Menlo College',93,'College','http://www.menlo.edu/'),(149,'Mills College ',86,'College','http://www.mills.edu/'),(150,'Monterey Institute of International Studies',94,'College','http://www.miis.edu/'),(151,'Mount Saint Mary\'s College ',78,'College','http://www.msmc.la.edu/'),(152,'National Hispanic University',75,'University','http://www.nhu.edu/'),(153,'National University',47,'University','http://www.nu.edu/'),(154,'Naval Postgraduate School ',94,'College','http://www.nps.navy.mil/'),(155,'Notre Dame de Namur University',95,'University','http://www.ndnu.edu/'),(156,'Occidental College',78,'College','http://www.oxy.edu/'),(157,'Otis College of Art & Design',78,'College','http://www.otis.edu/'),(158,'Pacific Oaks College ',49,'College','http://www.pacificoaks.edu/'),(159,'Pacific Union College ',96,'College','http://www.puc.edu/'),(160,'Pacifica Graduate Institute ',97,'College','http://pacifica.edu/'),(161,'Pardee RAND  Graduate School',98,'College','http://www.prgs.edu/'),(162,'Patten College',86,'College','http://www.patten.edu/'),(163,'Pepperdine University',86,'College','http://www.pepperdine.edu/'),(164,'Platt College',47,'College','http://www.platt.edu/'),(165,'Point Loma Nazarene University ',47,'College','http://www.pointloma.edu/'),(166,'Saint  Mary\'s College of California',99,'College','http://www.stmarys-ca.edu/'),(167,'Samuel Merrit College ',86,'College','http://www.samuelmerritt.edu/'),(168,'San Diego Christian College ',100,'College','http://www.sdcc.edu/'),(169,'Santa Clara University ',101,'University','http://www.scu.edu/'),(170,'Saybrook Graduete School & Research Center ',55,'College','http://www.saybrook.edu/'),(171,'Simpson University ',102,'University','http://www.simpsonuniversity.edu/'),(172,'Soka University of America ',103,'University','http://www.soka.edu/'),(173,'Southern California Institute of Architecture',78,'College','http://www.sciarc.edu/'),(174,'Southwestern University School of Law ',78,'University','http://www.swlaw.edu/'),(175,'Stanford University',104,'University','http://www.stanford.edu/'),(176,'Thomas Aquinas College ',105,'College','http://www.thomasaquinas.edu/'),(177,'University of California System ',86,'University','http://www.ucop.edu/'),(178,'University of California Berkeley ',86,'University','http://www.berkeley.edu/'),(179,'University of California Davis ',106,'University','http://www.ucdavis.edu/'),(180,'University of California Hastings College of the Law ',55,'University','http://www.uchastings.edu/'),(181,'University of California Irvine',83,'University','http://www.uci.edu/'),(182,'University of California Los Angeles ',78,'University','http://www.ucla.edu/'),(183,'University of California Merced ',107,'University','http://www.ucmerced.edu/'),(184,'University of California Riverside',54,'University','http://www.ucr.edu/'),(185,'University of California San Diego',108,'University','http://www.ucsd.edu/'),(186,'University of California San Francisco',55,'University','http://www.ucsf.edu/'),(187,'University of California Santa Barbara',85,'University','http://www.ucsb.edu/'),(188,'University of California Santa Cruz',109,'University','http://www.ucsc.edu/'),(189,'American Jewish University ',78,'University','http://www.ajula.edu/'),(190,'University of La Verne ',110,'University','http://www.ulv.edu/'),(191,'University of Nothern California',111,'University','http://www.uncm.edu/'),(192,'University of the Pacific',87,'University','http://www.pacific.edu/'),(193,'University of Redlands',112,'University','http://www.redlands.edu/'),(194,'University of San Diego',47,'University','http://www.sandiego.edu/'),(195,'University of San Francisco',55,'University','http://www.usfca.edu/'),(196,'University of Southern California ',113,'University','http://www.usc.edu/'),(197,'Vanguard University of Southern California ',113,'University','http://www.vanguard.edu/'),(198,'Western State University College of Law ',69,'University','http://www.wsulaw.edu/'),(199,'Western University of Health Sciences',63,'University','http://www.westernu.edu/'),(200,'Westminster Seminary California ',58,'College','http://www.wscal.edu/'),(201,'Westmont College',114,'College','http://www.westmont.edu/'),(202,'Whittier College',115,'College','http://www.whittier.edu/'),(203,'William Howard Taft University',116,'University','http://www.taftu.edu/'),(204,'William Jessup University ',117,'University','http://www.jessup.edu/'),(205,'Woodbury University ',118,'University','http://www.woodbury.edu/'),(206,'Adams State College ',119,'College','http://www.adams.edu/'),(207,'Art Institute of Colorado',120,'College','http://www.artinstitutes.edu/denver/'),(208,'College for Financial Planning ',121,'College','http://www.cffp.edu/'),(209,'Colorado Christian University ',122,'University','http://www.ccu.edu/'),(210,'Colorado College ',123,'College','http://www.coloradocollege.edu/'),(211,'Colorado School of Mines',124,'College','http://www.mines.edu/'),(212,'Colorado State University ',125,'University','http://www.colostate.edu/'),(213,'Colorado State University - Pueblo',126,'University','http://www.colostate-pueblo.edu/'),(214,'Colorado Technical University',123,'University','http://www.coloradotech.edu/'),(215,'Denver Seminary',127,'College','http://www.denverseminary.edu/'),(216,'Fort Lewis College',128,'College','http://www.fortlewis.edu/'),(217,'Iliff School of Theology',120,'College','http://www.iliff.edu/'),(218,'Jones Intenational University ',129,'University','http://www.jonesinternational.edu/'),(219,'Mesa State College',130,'College','http://www.mesastate.edu/'),(220,'Metropolitan State College of Denver',120,'College','http://www.mscd.edu/'),(221,'Naropa University',131,'University','http://www.naropa.edu/'),(222,'National Theatre Conservatory',120,'College','http://www.denvercenter.org/page.cfm?xid=23842027/'),(223,'Nazarene Bible College ',123,'College','http://www.nbc.edu/'),(224,'Regis University ',120,'University','http://www.regis.edu/'),(225,'Rocky Mountain College of Art & Design ',122,'College','http://www.rmcad.edu/'),(226,'University of Colorado System',120,'University','http://www.cu.edu/'),(227,'University of Colorado at Boulder ',131,'University','http://www.colorado.edu/'),(228,'University of Colorado at Colorado Springs ',123,'University','http://www.uccs.edu/'),(229,'University of Colorado at Denver',120,'University','http://www.cudenver.edu/'),(230,'University of Colorado Denver Health Sciences Center',120,'University','http://www.uchsc.edu/'),(231,'University of Denver',120,'University','http://www.du.edu/'),(232,'University of Nothern Colorado',132,'University','http://www.unco.edu/'),(233,'University of the Rockies ',123,'University','http://www.rockies.edu/'),(234,'Western State College of Colorado',133,'College','http://www.western.edu/'),(235,'Albertus Magnus College',134,'College',NULL),(236,'Central Connecticut State University',135,'University',NULL),(237,'Charter Oak State College ',136,'College',NULL),(238,'Connecticut College',137,'College',NULL),(239,'Fairfield University ',138,'University',NULL),(240,'Hartford Seminary ',139,'College',NULL),(241,'Holy Apostles College & Seminary ',140,'College',NULL),(242,'Lyme Academy College of Fine Arts ',141,'College',NULL),(243,'Mitchell College',137,'College',NULL),(244,'Post University ',136,'University',NULL),(245,'Quinnipiac University',142,'University',NULL),(246,'Sacred Heart University ',138,'University',NULL),(247,'Saint Joseph College',143,'College',NULL),(248,'Suothern Connecticut State University',144,'University',NULL),(249,'Trinity College',139,'College',NULL),(250,'United States Coast Guard Academy',137,'College',NULL),(251,'University of Bridgeport ',145,'University',NULL),(252,'University of Connecticut ',146,'University',NULL),(253,'University of Hartford',143,'University',NULL),(254,'University of New Haven',147,'University',NULL),(255,'Wesleyan University',148,'University',NULL),(256,'Western Connecticut State University ',149,'University',NULL),(257,'Yale University',134,'University',NULL),(258,'Delaware State University',150,'University',NULL),(259,'Goldey-Beacom College',151,'College',NULL),(260,'University of Delaware ',152,'University',NULL),(261,'Wesley College',150,'College',NULL),(262,'Wilmington University',153,'University',NULL),(263,'American University ',154,'University',NULL),(264,'The Catholic University of America ',154,'University',NULL),(265,'Corcoran College of Art & Design ',154,'College',NULL),(266,'Dominican House of Studies',154,'College',NULL),(267,'Gallaudet University',154,'University',NULL),(268,'George Washington University ',154,'University',NULL),(269,'Georgetown University',154,'University',NULL),(270,'Howard University',154,'University',NULL),(271,'Institute of World Politics',154,'College',NULL),(272,'Joint Military Intelligence College',154,'College',NULL),(273,'National Defense University ',154,'University',NULL),(274,'Southeastern University ',154,'University',NULL),(275,'Strayer University ',154,'University',NULL),(276,'Trinity University ',154,'University',NULL),(277,'University of the District of Columbia ',154,'University',NULL),(278,'Washington Theological Union',154,'College',NULL),(279,'Wesley theological Seminary ',154,'College',NULL),(280,'The Baptist College of Florida',155,'College',NULL),(281,'Barry University ',156,'University',NULL),(282,'Beacon College',157,'College',NULL),(283,'Bethune-Cookman College',158,'College',NULL),(284,'Carlos Albizu University-Miami',159,'University',NULL),(285,'Chipola College',160,'College',NULL),(286,'Clearwater Christian College',161,'College',NULL),(287,'Daytona State College',158,'College',NULL),(288,'Devry University-Orlando',162,'University',NULL),(289,'Eckerd College',163,'College',NULL),(290,'Edison State College',164,'College',NULL),(291,'Edward Waters College ',165,'College',NULL),(292,'Embry-Riddle Aeronautical University',158,'University',NULL),(293,'Flagler College',166,'College',NULL),(294,'Florida Agricultual & Mechanical University ',167,'University',NULL),(295,'Florida Atlantic University ',168,'University',NULL),(296,'Florida Christian College',169,'College',NULL),(297,'Florida College',170,'College',NULL),(298,'Florida Gulf Coast University ',171,'University',NULL),(299,'Florida Hospital College of Health Sciences',162,'College',NULL),(300,'Florida Institute of Technology ',172,'College',NULL),(301,'Florida International University ',156,'University',NULL),(302,'Florida Memorial University ',156,'University',NULL),(303,'Florida Southern College',162,'College',NULL),(304,'Florida State University ',173,'University',NULL),(305,'Florida State University Panama City Campus ',174,'University',NULL),(306,'Hobe Sound Bible College ',175,'College',NULL),(307,'Hodges University ',176,'University',NULL),(308,'Jacksonville University ',165,'University',NULL),(309,'Jones College',156,'College',NULL),(310,'Keiser University ',158,'University',NULL),(311,'Lynn University ',168,'University',NULL),(312,'Miami International University of Art & Design ',156,'University',NULL),(313,'New College of Florida',177,'College',NULL),(314,'Northwood University ',178,'University',NULL),(315,'Nova Southeastern University ',179,'University',NULL),(316,'Palm Beach Atlantic University ',178,'University',NULL),(317,'Ringling School of Art & Design ',177,'College',NULL),(318,'Rollins College ',180,'College',NULL),(319,'Sain John Vianney College Seminary ',156,'College',NULL),(320,'Saint Leo College ',181,'College',NULL),(321,'Saint Petersburg College ',182,'College',NULL),(322,'Saint Thomas University ',183,'University',NULL),(323,'Saint Vincent de Paul Regional Seminary ',184,'College',NULL),(324,'South Florida Bible College & Theological Seminary ',185,'College',NULL),(325,'Southeastern University ',186,'University',NULL),(326,'Stetson University ',187,'University',NULL),(327,'Trinity College of Florida',188,'College',NULL),(328,'Troy State University-Florida Region ',189,'University',NULL),(329,'University of Central Florida ',162,'University',NULL),(330,'University of Florida ',190,'University',NULL),(331,'niversity of Maimi',191,'University',NULL),(332,'University of North Florida ',165,'University',NULL),(333,'University of South Florida ',167,'University',NULL),(334,'University of South Florida-Saint Petersburg',192,'University',NULL),(335,'University of Tampa ',167,'University',NULL),(336,'University of West florida ',193,'University',NULL),(337,'Warner Southern College',194,'College',NULL),(338,'Webber International University ',195,'University',NULL),(339,'Brigham Young University -Hawaii',196,'University',NULL),(340,'Chaminade University ',197,'University',NULL),(341,'Hawaii Pacific University ',197,'University',NULL),(342,'University of Hawaii System',197,'University',NULL),(343,'University of Hawaii Hilo ',198,'University',NULL),(344,'University of Hawaii Manoa ',197,'University',NULL),(345,'University of Hawaii West Oahu ',199,'University',NULL),(346,'Boise State University ',200,'University',NULL),(347,'Brigham Young University -Idaho',201,'University',NULL),(348,'The College of Idaho',202,'College',NULL),(349,'Idaho State University ',203,'University',NULL),(350,'Lewis-Clark State College ',204,'College',NULL),(351,'Northwest Nazarene University ',205,'University',NULL),(352,'University of Idaho ',206,'University',NULL),(353,'Adler School of Professional Physhology ',207,'College',NULL),(354,'American College of Education ',207,'College',NULL),(355,'Argosy University ',208,'University',NULL),(356,'Augustana College',209,'College',NULL),(357,'Aurora University ',210,'University',NULL),(358,'Benedictine University ',211,'University',NULL),(359,'Blackburn College ',212,'College',NULL),(360,'Blessing-Reiman College of Nursing ',213,'College',NULL),(361,'Bradley University ',214,'University',NULL),(362,'Catholic Theological Union ',207,'College',NULL),(363,'The Chicago Schoolof Professional Phychology ',207,'College',NULL),(364,'Chicago State University ',207,'University',NULL),(365,'Chicago Theological Seminary',207,'College',NULL),(366,'Columbia College Chicago ',207,'College',NULL),(367,'Concordia University-Chicago',215,'University',NULL),(368,'Depaul University ',207,'University',NULL),(369,'DeVry University ',207,'University',NULL),(370,'DeVry University-DuPage ',216,'University',NULL),(371,'Dominican University ',215,'University',NULL),(372,'East-West University ',207,'University',NULL),(373,'Eastern Illinois University ',217,'University',NULL),(374,'Ellis University ',207,'University',NULL),(375,'Elmhurst Colleg',218,'College',NULL),(376,'Erikson Institute',207,'College',NULL),(377,'Eureka College',219,'College',NULL),(378,'Garret-Evangelical Theological Seminary ',220,'College',NULL),(379,'Governors State University ',221,'University',NULL),(380,'Greenville College ',222,'College',NULL),(381,'Hebrew Theological College ',223,'College',NULL),(382,'Illinois College',224,'College',NULL),(383,'Illinois College of Optometry',207,'College',NULL),(384,'Illinois Institute of Art-Chicago',207,'College',NULL),(385,'Illinois Institute of Art-Schaumburg ',208,'College',NULL),(386,'Illimois Institute of Technology ',207,'College',NULL),(387,'Illinois State University ',225,'College',NULL),(388,'Illinois Wesleyan University ',226,'University',NULL),(389,'Institute for Clinical Social Work ',207,'College',NULL),(390,'John Marshall Law School',207,'College',NULL),(391,'Judson University ',227,'University',NULL),(392,'Kendall College',220,'College',NULL),(393,'Knowledge System Institute ',223,'College',NULL),(394,'Knox College',228,'College',NULL),(395,'Lake Forest College ',229,'College',NULL),(396,'Lake Forest Graduate School of Management ',230,'College',NULL),(397,'Lakeview Ocllege of Nursing ',231,'College',NULL),(398,'Lewis University ',232,'University',NULL),(399,'Lexington College ',207,'College',NULL),(400,'lincoln Christian Collge & Seminary',233,'College',NULL),(401,'Lincoln College',233,'College',NULL),(402,'Loyola University Chicago',207,'University',NULL),(403,'Lutheran School of Theology at Chicago ',207,'College',NULL),(404,'MacMurray Collge ',224,'College',NULL),(405,'McCormick Theological Seminary',207,'College',NULL),(406,'McKendree University ',234,'University',NULL),(407,'Midstate College ',214,'College',NULL),(408,'Midwestern University ',235,'University',NULL),(409,'Millikin University ',236,'University',NULL),(410,'Monmouth College',237,'College',NULL),(411,'Moody Bible Institute',207,'College',NULL),(412,'National University of Health Sciences',238,'University',NULL),(413,'National-Louis University ',227,'University',NULL),(414,'North Central Collge',239,'College',NULL),(415,'North Park University ',207,'University',NULL),(416,'Northeastern Illinois University ',207,'University',NULL),(417,'Northern Baptist Theological Seminary ',238,'University',NULL),(418,'Northern Illinois University',240,'University',NULL),(419,'Northwestern University ',220,'University',NULL),(420,'Olivet Nazarene University',241,'University',NULL),(421,'Principia College',242,'College',NULL),(422,'Quincy University',213,'University',NULL),(423,'Robert Morris College',243,'College',NULL),(424,'Rockford College',244,'College',NULL),(425,'Roosvelt University ',207,'University',NULL),(426,'Rosalind Franklin University of Medicine & Science',245,'University',NULL),(427,'Rush University ',207,'University',NULL),(428,'Saint Athony College of Nursing',244,'College',NULL),(429,'Saint Augustine College',207,'College',NULL),(430,'Saint Francis Medical Center College of Nursing',214,'College',NULL),(431,'Saint John\'s College',246,'College',NULL),(432,'Saint Xavier University ',207,'University',NULL),(433,'School of the Art Institute of Chicago',207,'College',NULL),(434,'Seabury-Weastern Theological Seminary',220,'College',NULL),(435,' Shimer College',247,'College',NULL),(436,'Southern Illinois Univversity Systems',248,'University',NULL),(437,'Southern Illinois University Carbondale',248,'University',NULL),(438,'Southern Illinois University Edwardsville',249,'University',NULL),(439,'Spertus Institute of Jewish Studies ',207,'College',NULL),(440,'Trinity Christian College',250,'College',NULL),(441,'Trinity College of Nursing & Health Sciences ',209,'College',NULL),(442,'Trinity International University ',251,'University',NULL),(443,'University of Chicago ',207,'University',NULL),(444,'University of Illinois System',252,'University',NULL),(445,'University of Illinois at Chicago',207,'University',NULL),(446,'University of Illinois at Springfield',246,'University',NULL),(447,'University of Saint Francis',253,'University',NULL),(448,'Vandercook College of Music',207,'College',NULL),(449,'West Suburban College of Nursing ',254,'College',NULL),(450,'Wheaton College',255,'College',NULL),(451,'Allen College',256,'College',NULL),(452,'Ashford University ',257,'University',NULL),(453,'Briar Cliff University ',258,'University',NULL),(454,'Buena Vista University ',259,'University',NULL),(455,'Central College',260,'College',NULL),(456,'Clarke College',261,'College',NULL),(457,'Coe College',262,'College',NULL),(458,'Cornell College',263,'College',NULL),(459,'Des Moines University-Osteopathic Medical Center',264,'University',NULL),(460,'Divine Word College',265,'College',NULL),(461,'Dordt College',266,'College',NULL),(462,'Drake University ',264,'University',NULL),(463,'Emmaus Bible College',261,'College',NULL),(464,'Faith Baptist Bible College & Theological Seminary ',267,'College',NULL),(465,'Graceland University',268,'University',NULL),(466,'Grand View University ',264,'University',NULL),(467,'Grinnnell College',269,'College',NULL),(468,'Iowa State University ',270,'University',NULL),(469,'Iowa Wesleyan College ',271,'College',NULL),(470,'Kaplan University ',272,'University',NULL),(471,'Loras College ',261,'College',NULL),(472,'Luther College ',273,'College',NULL),(473,'Maharishi University of Management ',274,'University',NULL),(474,'Mercy College of Health Sciences ',264,'College',NULL),(475,'Morningside College',275,'College',NULL),(476,'Mount Mercy College',262,'College',NULL),(477,'Northwestern College',276,'College',NULL),(478,'Palmer College of Chiropractic',277,'College',NULL),(479,'Saint Ambrose University ',277,'University',NULL),(480,'Simpson College ',278,'College',NULL),(481,'University of Dubuque',261,'University',NULL),(482,'University of Iowa ',279,'University',NULL),(483,'University of Northern Iowa',280,'University',NULL),(484,'Upper Iowa University ',256,'University',NULL),(485,'Waldorf College',281,'College',NULL),(486,'Wartburg College',282,'College',NULL),(487,'Wartburg Theological Seminary ',261,'College',NULL),(488,'William Penn University ',283,'University',NULL),(489,'Baker University ',284,'University',NULL),(490,'Benedictine College',285,'College',NULL),(491,'Bathany College',286,'College',NULL),(492,'Bethel College',287,'College',NULL),(493,'Central Baptist Theological Seminary ',288,'College',NULL),(494,'Central Christian College of Kansas',289,'College',NULL),(495,'Cleveland Chiropractic College',290,'College',NULL),(496,'Fort Hays State University ',291,'University',NULL),(497,'Friends University ',292,'University',NULL),(498,'Haskell Indian Nations University ',293,'University',NULL),(499,'Kansas State University',294,'University',NULL),(500,'Kansas State University-Salina College of Technology & Aviation ',295,'College',NULL),(501,'Kansas Wesleyan University ',295,'University',NULL),(502,'Manhatten Christian College',294,'College',NULL),(503,'McPherson College',289,'College',NULL),(504,'MidAmerica Nazarene College',296,'College',NULL),(505,'Newman University ',292,'University',NULL),(506,'Ottawa University',297,'University',NULL),(507,'Pittsburg University ',298,'University',NULL),(508,'Southwestern College',299,'College',NULL),(509,'Sterling College',300,'College',NULL),(510,'Tabor College',301,'College',NULL),(511,'United States Army Command & General Staff Collge',302,'College',NULL),(512,'University of Kansas',293,'University',NULL),(513,'University of Kansas Medical Center',290,'University',NULL),(514,'University of Saint Mary',303,'University',NULL),(515,'Washburn University ',304,'University',NULL),(516,'Wichita State University',292,'University',NULL),(517,'Alice Lloyd College',305,'College',NULL),(518,'Asbury College',306,'College',NULL),(519,'Asbury Theological Seminary ',306,'College',NULL),(520,'Bellarmine University ',307,'University',NULL),(521,'Berea College',308,'College',NULL),(522,'Brescial University ',309,'University',NULL),(523,'Campbellsville University',310,'University',NULL),(524,'Centre College',311,'College',NULL),(525,'Clear Creek Baptist Bible College',312,'College',NULL),(526,'Eastern Kentucky University',313,'University',NULL),(527,'Goergetown College ',314,'College',NULL),(528,'Kentucky Christian University ',315,'University',NULL),(529,'Kentucky mountain Bible College',316,'College',NULL),(530,'Kentucky State University ',317,'University',NULL),(531,'Kentucky Wesleyan College',309,'College',NULL),(532,'Lexinton Theological Seminary ',318,'College',NULL),(533,'Lindsey Wilson College',319,'College',NULL),(534,'Mid-Continent College',320,'College',NULL),(535,'Midway College',321,'College',NULL),(536,'Morehead State University ',322,'University',NULL),(537,'Murry State University ',323,'University',NULL),(538,'Northern Kentucky University ',324,'University',NULL),(539,'Pikeville College',325,'College',NULL),(540,'Saint Catharine College',326,'College',NULL),(541,'Southern Baptist Theological Seminary ',307,'College',NULL),(542,'Spalding University ',307,'University',NULL),(543,'Sullivan University ',307,'University',NULL),(544,'Thomas More College',327,'College',NULL),(545,'Transylvania University ',318,'University',NULL),(546,'Union College',328,'College',NULL),(547,'University of Kentucky',318,'University',NULL),(548,'University of Louisville',307,'University',NULL),(549,'University of the Cumberlands',329,'University',NULL),(550,'Western Kentucky University ',330,'University',NULL),(551,'Centenary College of Louisiana',331,'College',NULL),(552,'Dillard University ',332,'University',NULL),(553,'Grambling State University ',333,'University',NULL),(554,'Louisiana College',334,'College',NULL),(555,'Louisiana State University System',335,'University',NULL),(556,'Louisiana State University Alexandria',336,'University',NULL),(557,'Louisiana State University Baton Rouge ',335,'University',NULL),(558,'Louisiana State University Health Sciences Center',331,'University',NULL),(559,'Louisiana State University Shreveport',331,'University',NULL),(560,'University of New Orleans',332,'University',NULL),(561,'Louisiana Tech University ',337,'University',NULL),(562,'Loyola University New Orleans ',332,'University',NULL),(563,'McNeese State University ',338,'University',NULL),(564,'Nicholls State University ',339,'University',NULL),(565,'New Orleans Baptist Theological Seminary ',332,'College',NULL),(566,'Northewestern State University of Louisiana ',340,'University',NULL),(567,'Our Lady of Holy Cross College',332,'College',NULL),(568,'Our Lady of the Lake College',335,'College',NULL),(569,'Southeastern Louisiana University ',341,'University',NULL),(570,'Southern University System ',335,'University',NULL),(571,'Southern University Baton Rouge',335,'University',NULL),(572,'Southern University New Orleans',332,'University',NULL),(573,'Tulane University ',332,'University',NULL),(574,'University of Louisiana System ',335,'University','http://www.ulsystem.net/'),(575,'University of Louisiana at Monroe',342,'University',NULL),(576,'University of Louisiana Lafayette',343,'University',NULL),(577,'Xavier University of Louisiana ',332,'University',NULL),(578,'Baltimore Hebrew University',344,'University',NULL),(579,'Baltimore International College',344,'College',NULL),(580,'Bowie State University ',345,'University',NULL),(581,'Capitol College',346,'College',NULL),(582,'Chesapeake College',347,'College',NULL),(583,'College of Notre Dame of Maryland ',344,'College',NULL),(584,'Columbia Union College',348,'College',NULL),(585,'Coppin State University ',344,'University',NULL),(586,'Goucher College',344,'College',NULL),(587,'Frostburg State University',349,'University',NULL),(588,'Hood College',350,'College',NULL),(589,'Johns Hopkins University',344,'University',NULL),(590,'Loyola College',344,'College',NULL),(591,'Maryland Institute College of Art',344,'College',NULL),(592,'McDaniel College',351,'College',NULL),(593,'Morgan State University ',344,'University',NULL),(594,'Mount Saint Mary\'s University ',352,'University',NULL),(595,'National Labor College',353,'College',NULL),(596,'Saint John\'s College-Annapolis ',354,'College',NULL),(597,'Saint John\'s College of Maryland',355,'College',NULL),(598,'Saint Mary\'s Seminary & University',344,'University',NULL),(599,'Salisbury University ',356,'University',NULL),(600,'Soujourner-Douglass College',344,'College',NULL),(601,'Tai Sophia Institute ',346,'College',NULL),(602,'Towson University ',357,'University',NULL),(603,'The Uniformed Services University of the Health Sciences',358,'University',NULL),(604,'University of Baltimore ',344,'University',NULL),(605,'University of Maryland System',344,'University',NULL),(606,'University of Maryland Baltimore',344,'University',NULL),(607,'University of Maryland Baltimore County',344,'University',NULL),(608,'University of Maryland College Park',359,'University',NULL),(609,'University of Maryland Eastern Shore',360,'University',NULL),(610,'University of Maryland University College',344,'University',NULL),(611,'Washington Bible College',354,'College',NULL),(612,'Washington College',361,'College',NULL),(613,'Villa Julie College',362,'College',NULL),(614,'Bates College',363,'College',NULL),(615,'Bowdoin College',364,'College',NULL),(616,'Colby College',365,'College',NULL),(617,'College of the Atlantic',366,'College',NULL),(618,'Husson College',367,'College',NULL),(619,'Maine College of Art ',368,'College',NULL),(620,'Maine Maritime Academy',369,'College',NULL),(621,'Saint Joseph\'s College',370,'College',NULL),(622,'Thomas College',365,'College',NULL),(623,'Unity College',371,'College',NULL),(624,'University of Maine System',367,'University',NULL),(625,'University of Maine at Augasta',372,'University',NULL),(626,'University of Maine Farmington',373,'University',NULL),(627,'University of Maine Fort Kent ',374,'University',NULL),(628,'University of Maine Machias',375,'University',NULL),(629,'University of Maine Orono',376,'University',NULL),(630,'University of Maine Presque Isle',377,'University',NULL),(631,'University of Maine School of Law',368,'University',NULL),(632,'University of Southern Maine',368,'University',NULL),(633,'University of New England',368,'University',NULL),(634,'American International College',378,'College',NULL),(635,'Amherst College',379,'College',NULL),(636,'Andover Newton Theological School',380,'College',NULL),(637,'Anna Maria College',381,'College',NULL),(638,'Assumption College',382,'College',NULL),(639,'Atlantic Union College',383,'College',NULL),(640,'Babson College',384,'College',NULL),(641,'Bay Path College',385,'College',NULL),(642,'Becker Colleg',386,'College',NULL),(643,'Benjamin Franklin Institute of Technikogy',387,'College',NULL),(644,'Bently College',388,'College',NULL),(645,'Berklee College of Music ',387,'College',NULL),(646,'Boston Archtectural College',387,'College',NULL),(647,'Boston College',389,'College',NULL),(648,'Boston Conservatory',387,'College',NULL),(649,'Boston Graduate School of Psychoanalysis',390,'College',NULL),(650,'Boston University ',387,'University',NULL),(651,'Brandeis University ',388,'University',NULL),(652,'Bridgewater State College',391,'College',NULL),(653,'Cambridge College',392,'College',NULL),(654,'Clark University',382,'University',NULL),(655,'College of the Holy Cross ',382,'College',NULL),(656,'Curry College',382,'College',NULL),(657,'Eastern Nazarene College',393,'College',NULL),(658,'Elms College',394,'College',NULL),(659,'Emerson College',387,'College',NULL),(660,'Emmanuel College',387,'College',NULL),(661,'Endicott College',395,'College',NULL),(662,'Fisher College',387,'College',NULL),(663,'Fitchburg State College',396,'College',NULL),(664,'Framingham State College',397,'College',NULL),(665,'Gordon College',398,'College',NULL),(666,'Gordon -Conwell Theological Seminary',399,'College',NULL),(667,'Hampshire College',379,'College',NULL),(668,'Harvard University',400,'University',NULL),(669,'Hebrew College',380,'College',NULL),(670,'Hult International Business School',401,'College',NULL),(671,'Lasell College',402,'College',NULL),(672,'Lesley College',392,'College',NULL),(673,'Massachusetts College of Arts',387,'College',NULL),(674,'Massachusetts College of Liberal Arts',403,'College',NULL),(675,'Massachusetts College of Pharmacy & Health Sciences',387,'College',NULL),(676,'Massachusetts Institute of Technology',387,'College',NULL),(677,'Massachusetts Maritime Academy',404,'College',NULL),(678,'Massachusetts School of Professianal Psychology',405,'College',NULL),(679,'Merrimack College',406,'College',NULL),(680,'Mount Holyoke College',407,'College',NULL),(681,'Mount Ida College ',380,'College',NULL),(682,'New England College of Optometry',387,'College',NULL),(683,'New England Conservatory of Music',387,'College',NULL),(684,'Newbury College',390,'College',NULL),(685,'Nichols College',408,'College',NULL),(686,'Northeastern University ',387,'University',NULL),(687,'Pine Manor College',389,'College',NULL),(688,'Regis College',409,'College',NULL),(689,'Salem State College',410,'College',NULL),(690,'Simmonse College',387,'College',NULL),(691,'Simon\'s Rock College',411,'College',NULL),(692,'Smith College',412,'College',NULL),(693,'Springfield College',378,'College',NULL),(694,'Stonehill College',413,'College',NULL),(695,'Suffolk University ',387,'University',NULL),(696,'Tufts university',387,'University',NULL),(697,'University of Massachusetts System',388,'University',NULL),(698,'University of Massachusetts Amherst',379,'University',NULL),(699,'University of Massachusetts Boston',387,'University',NULL),(700,'University of Massachusetts Darmouth',414,'University',NULL),(701,'University of Massachusetts Lowell',415,'University',NULL),(702,'University of Massachusetts Medical School at Worcester',382,'University',NULL),(703,'Wellesley College',416,'College',NULL),(704,'Wentworth Institute of Technology',387,'College',NULL),(705,'Western New England College',378,'College',NULL),(706,'Westfield  State College',378,'College',NULL),(707,'Wheaton College',417,'College',NULL),(708,'Wheelock College',387,'College',NULL),(709,'Williams College',418,'College',NULL),(710,'Worcester Politechnic Institute ',382,'College',NULL),(711,'Worcester State College',382,'College',NULL),(712,'Alfred Adler Institute',419,'College',NULL),(713,'Augsburg College',420,'College',NULL),(714,'Bethany Lutheran College',421,'College',NULL),(715,'Bethel University & Seminary',422,'University',NULL),(716,'Capella University ',420,'University',NULL),(717,'Carleton College',423,'College',NULL),(718,'College of Saint Benedict',424,'College',NULL),(719,'College of Saint Catherine ',422,'College',NULL),(720,'College of Saint Scholastica ',425,'College',NULL),(721,'College of Visual Arts ',426,'College',NULL),(722,'Concordia  College-Moorhead',427,'College',NULL),(723,'Concordia University-Saint Paul ',426,'University',NULL),(724,'Crossroads College',428,'College',NULL),(725,'Crown College',429,'College',NULL),(726,'Dunwoody College of Technology ',420,'College',NULL),(727,'Gustavus Adolphus College',430,'College',NULL),(728,'Hamline University',422,'University',NULL),(729,'Hazelden Graduate School of Addiction Studies',431,'College',NULL),(730,'Luther Seminary',432,'College',NULL),(731,'Macalester College',426,'College',NULL),(732,'Martin Luther College',433,'College',NULL),(733,'Mayo Clinic College of Medicine',428,'College',NULL),(734,'Minnesota State College & University System',426,'College',NULL),(735,'Bemidji State University ',434,'University',NULL),(736,'Metropolitan State University ',426,'University',NULL),(737,'Minnesota State University Mankato',421,'University',NULL),(738,'Minnesota State University Moorhead',427,'University',NULL),(739,'Southwest Minnesota State University ',435,'University',NULL),(740,'Saint Cloud State University ',436,'University',NULL),(741,'Winona State University',437,'University',NULL),(742,'North Central University ',420,'University',NULL),(743,'Northwestern College',438,'College',NULL),(744,'Northwestern Health Sciences University',439,'University',NULL),(745,'Oak Hills Christian College',434,'College',NULL),(746,'Pillsbury  Baptist Bible College',440,'College',NULL),(747,'Rasmussen College',441,'College',NULL),(748,'Saint John\'s University',442,'University',NULL),(749,'Saint Mary\'s University of Minnesota ',437,'University',NULL),(750,'Saint Olaf College',423,'College',NULL),(751,'United Theological Seminary of the Twin Cities',422,'College',NULL),(752,'University of Minnesota Crookston ',443,'University',NULL),(753,'University of Minnesota Duluth',425,'University',NULL),(754,'University of Minnesota Morris',444,'University',NULL),(755,'University of Minnesota Twin Cities',420,'University',NULL),(756,'University of Saint Thomas',422,'University',NULL),(757,'Walden University',420,'University',NULL),(758,'A.T. Still University of Health Sciences',445,'University',NULL),(759,'Aquinas Institute of Theology ',446,'College',NULL),(760,'Assemblies of God Theological Seminary ',447,'College',NULL),(761,'Avila University ',448,'University',NULL),(762,'Baptist Bible College',447,'College',NULL),(763,'Calvary Bible College & Theological Seminary ',448,'College',NULL),(764,'Central Bible College',447,'College',NULL),(765,'Central Christian College of Bible',449,'College',NULL),(766,'Central Methodist University ',450,'University',NULL),(767,'Chamberlian College of Nursing',446,'College',NULL),(768,'College of the Ozarks ',451,'College',NULL),(769,'Columbia College ',452,'College',NULL),(770,'Conseption Seminary College',453,'College',NULL),(771,'Concordia Seminary-Saint Louis',446,'College',NULL),(772,'Covenant Theological Seminary',454,'College',NULL),(773,'Cox College of Nursing & Health Sciences',447,'College',NULL),(774,'Culver-Stockton College',455,'College',NULL),(775,'DeVry university-Kansas City',448,'University',NULL),(776,'Drury University ',447,'University',NULL),(777,'Eden  Theological Seminary ',456,'College',NULL),(778,'Evangel University ',447,'University',NULL),(779,'Fontbonne University ',457,'University',NULL),(780,'Forest Institute of Professional Psychology',447,'College',NULL),(781,'Goldfarb School of Nursing at Barnes-Jewish College',458,'College',NULL),(782,'Hannibal-Lagrange College',459,'College',NULL),(783,'Harris-Stowe State University ',446,'College',NULL),(784,'Kansas City Art Institute',448,'College',NULL),(785,'Kansas City University of Medicine & Biosciences',448,'University',NULL),(786,'Kenrick-Glennon Seminary ',446,'College',NULL),(787,'Lincoln University ',460,'University',NULL),(788,'Lindenwood University ',461,'University',NULL),(789,'Logan University',462,'University',NULL),(790,'Maryville University of Saint Louis',463,'University',NULL),(791,'Midwestern Baptist Theological Seminary ',448,'College',NULL),(792,'Missouri Baptist University ',464,'University',NULL),(793,'Missouri Southern State University ',465,'University',NULL),(794,'Missouri State University ',447,'University',NULL),(795,'Missouri Valley College',466,'College',NULL),(796,'Missouri Western State University ',467,'University',NULL),(797,'Northwest Missouri State University ',468,'University',NULL),(798,'Ozark Christian College',465,'College',NULL),(799,'Park University ',469,'University',NULL),(800,'Research College of Nursing ',448,'College',NULL),(801,'Rockhurst University ',448,'University',NULL),(802,'Saint Louis College of Pharmacy',446,'College',NULL),(803,'Saint Louis University ',446,'University',NULL),(804,'Saint Luke\'s College',448,'College',NULL),(805,'Saint Paul School of Theology ',448,'College',NULL),(806,'Southeast Missouri State University ',470,'University',NULL),(807,'Southwest Baptist University ',471,'University',NULL),(808,'Stephens College',472,'College',NULL),(809,'Truman State University ',445,'University',NULL),(810,'University of Central Missouri ',473,'University',NULL),(811,'University of Missouri System ',472,'University',NULL),(812,'University of Missouri Columbia ',472,'University',NULL),(813,'University of Missouri Kansas City',448,'University',NULL),(814,'Missouri University of Science & Technology',452,'University',NULL),(815,'University of Missouri Saint Louis',446,'University',NULL),(816,'Washington University in Saint Louis ',446,'University',NULL),(817,'Webster University',456,'University',NULL),(818,'Westminster College',474,'College',NULL),(819,'William Jewell College',475,'College',NULL),(820,'William Woods University ',474,'University',NULL),(821,'Antioch New England',476,'College',NULL),(822,'Chester College of New England',477,'College',NULL),(823,'Coldy-Sawyer College',478,'College',NULL),(824,'Daniel Webster College',479,'College',NULL),(825,'Dartmounth College',480,'College',NULL),(826,'Franklin Pierce University ',481,'University',NULL),(827,'Franklin Pierce Law Center ',482,'College',NULL),(828,'Granite State College',482,'College',NULL),(829,'Keene State College',476,'College',NULL),(830,'New England College',483,'College',NULL),(831,'Plymounth State College',484,'College',NULL),(832,'River College',479,'College',NULL),(833,'Saint Anselm College',481,'College',NULL),(834,'Southern New Hampshire University ',481,'University',NULL),(835,'The Thomas More College of Liberal Arts ',481,'College',NULL),(836,'University of New Hampshire ',485,'University',NULL),(837,'University of New Hampshire at Manchester',481,'University',NULL),(838,'Great Basin College',486,'College',NULL),(839,'Sierra Nevada College',487,'College',NULL),(840,'University of Nevada-Las Vegas',488,'University',NULL),(841,'University of Nevada-Reno',489,'University',NULL),(842,'College of Santa Fe',490,'College',NULL),(843,'Eastern New  Mexico University ',491,'University',NULL),(844,'Institute of American Indian Arts',490,'College',NULL),(845,'New Mexico Institute of Mining & Technology ',492,'College',NULL),(846,'New Mexico Highland University ',493,'University',NULL),(847,'New Mexico State University ',494,'University',NULL),(848,'Saint John\'s College-Santa Fe',490,'College',NULL),(849,'Southwestern College',490,'College',NULL),(850,'University Of New Mexico ',490,'University',NULL),(851,'University of the Southwest',495,'University',NULL),(852,'Western New Mexico University',496,'University',NULL),(853,'Berkeley College',497,'College',NULL),(854,'Bloomfield College',498,'College',NULL),(855,'Caldwell College',499,'College',NULL),(856,'Centenary College  ',500,'College',NULL),(857,'The College of New Jersey',501,'College',NULL),(858,'College of Saint Elizabeth ',502,'College',NULL),(859,'Drew University ',503,'University',NULL),(860,'Fairleigh Dickinson University',503,'University',NULL),(861,'Felician College',504,'College',NULL),(862,'Goergian Court College',505,'College',NULL),(863,'Kean University ',506,'University',NULL),(864,'Monmouth University ',507,'University',NULL),(865,'Montclair State University ',508,'University',NULL),(866,'New Jersey City University ',509,'University',NULL),(867,'New Jersey Institute of Technology',510,'College',NULL),(868,'Princeton University ',511,'University',NULL),(869,'Ramapo College',512,'College',NULL),(870,'Richard Stockton College of New Jersey',513,'College',NULL),(871,'Rowan University ',514,'University',NULL),(872,'Rurgers University',515,'University','http://www.rutgers.edu/'),(873,'Rurgers University Camden ',515,'University',NULL),(874,'Rurgers University New Bruswick/Piscataway',516,'University',NULL),(875,'Rurgers University Newark',510,'University',NULL),(876,'Saint Peter\'s College',509,'College',NULL),(877,'Seton Hall University ',517,'University',NULL),(878,'Stevens Institute of Technology ',518,'College',NULL),(879,'Thomas Edison State College',501,'College',NULL),(880,'University of Medicine & Dentistry of New Jersey',519,'University',NULL),(881,'William Paterson University ',520,'University',NULL),(882,'Adrian College',521,'College',NULL),(883,'Albion College',522,'College',NULL),(884,'Alma College',523,'College',NULL),(885,'Andrews University ',524,'University',NULL),(886,'Aquinas College',525,'College',NULL),(887,'Baker College',526,'College',NULL),(888,'Calvin College',525,'College',NULL),(889,'Central Michigan University ',527,'University',NULL),(890,'Cleary University ',528,'University',NULL),(891,'College of Creative Studies ',529,'College',NULL),(892,'Concodia College-Ann Arbor ',530,'College',NULL),(893,'Cornerstone University ',525,'University',NULL),(894,'Cranbrook Academy of Art ',531,'College',NULL),(895,'Davenport University ',525,'University',NULL),(896,'Eastern Michigan University ',532,'University',NULL),(897,'Ferris State University ',533,'University',NULL),(898,'Kendall College of Art & Design ',525,'College',NULL),(899,'Finlandia University ',534,'University',NULL),(900,'Grace Bible College ',535,'College',NULL),(901,'Grand Valley State University ',525,'University',NULL),(902,'Great Lakes Christian College ',536,'College',NULL),(903,'Hillsdale  College',537,'College',NULL),(904,'Hope College',538,'College',NULL),(905,'Kalamazoo College',539,'College',NULL),(906,'Kettering University ',540,'University',NULL),(907,'Kuyper College',525,'College',NULL),(908,'Lake Superior State University ',541,'University',NULL),(909,'Lawrence Technological University ',542,'University',NULL),(910,'Madonna University ',543,'University',NULL),(911,'Marygrove College',529,'College',NULL),(912,'Michigan School of Professional Psychology ',544,'College',NULL),(913,'Nmichigan State University ',545,'University',NULL),(914,'Michigan Technological University',546,'University',NULL),(915,'Miller College',547,'College',NULL),(916,'Northern Michigan University ',548,'University',NULL),(917,'Northwood University ',549,'University',NULL),(918,'Oakland University ',550,'University',NULL),(919,'Olivet College ',551,'College',NULL),(920,'Sacred Heart Major Seminary ',529,'College',NULL),(921,'Saginaw Valley State University ',552,'University',NULL),(922,'Siena Heighs University ',521,'University',NULL),(923,'Spring Arbor University ',553,'University',NULL),(924,'Thomas M. Cooley Law School',525,'College',NULL),(925,'University of Detroit Mercy ',529,'University',NULL),(926,'University of Michigan System',554,'University',NULL),(927,'University of Michigan Ann Arbor',530,'University',NULL),(928,'University of Michigan Dearborn',555,'University',NULL),(929,'University of Michigan Flint',540,'University',NULL),(930,'Walsh College',556,'College',NULL),(931,'Wayne State University ',529,'University',NULL),(932,'Western Michigan University ',529,'University',NULL),(933,'Alcorn State University ',557,'University',NULL),(934,'Belhaven College',558,'College',NULL),(935,'Blue Mountain College ',559,'College',NULL),(936,'Delta State University ',560,'University',NULL),(937,'Jackson State University ',558,'University',NULL),(938,'Magnolia Bible College',561,'College',NULL),(939,'Millsaps College',558,'College',NULL),(940,'Mississippi College',562,'College',NULL),(941,'Mississippi State University',563,'University',NULL),(942,'Mississippi University for Women',564,'University',NULL),(943,'Mississippi Valley State University ',565,'University',NULL),(944,'Rust College',566,'College',NULL),(945,'Tougaloo College',567,'College',NULL),(946,'University of Mississippi ',568,'University',NULL),(947,'University of Mississippi Medical Center ',558,'University',NULL),(948,'University of southernMississippi',569,'University',NULL),(949,'William Carey College',570,'College',NULL),(950,'Carroll College',571,'College',NULL),(951,'Montana State University ',572,'University',NULL),(952,'Montana State University Billings ',573,'University',NULL),(953,'Montana State University Northern',574,'University',NULL),(954,'Rocky Mountain College  ',573,'College',NULL),(955,'Salish Kootenai College',575,'College',NULL),(956,'University of Great Falls ',576,'University',NULL),(957,'University of Montana System ',577,'University',NULL),(958,'University of Montana Montana Tech',578,'University',NULL),(959,'University of Montana-Missoula',577,'University',NULL),(960,'University of Montana-Western',579,'University',NULL),(961,'Bellevue University ',580,'University',NULL),(962,'Chadron State College',581,'College',NULL),(963,'Clarkson College',582,'College',NULL),(964,'College of Saint Mary ',582,'College',NULL),(965,'Concordia University-Nebraska',583,'University',NULL),(966,'Creighton University ',582,'University',NULL),(967,'Dana College',584,'College',NULL),(968,'Doane College',585,'College',NULL),(969,'Grace University ',582,'University',NULL),(970,'Hastings College',586,'College',NULL),(971,'Midland Lutheran College',587,'College',NULL),(972,'Nebraska Christian College',588,'College',NULL),(973,'Nebraska Methodist College',582,'College',NULL),(974,'Nebraska Wesleyan University ',589,'University',NULL),(975,'Peru State College',590,'College',NULL),(976,'Union College',589,'College',NULL),(977,'University of Nebraska System ',589,'University',NULL),(978,'University of Nebraska Kearney',591,'University',NULL),(979,'University of Nebraska Lincoln',589,'University',NULL),(980,'University of Nebraska Medical Center ',582,'University',NULL),(981,'University of Nebraska Omaha',582,'University',NULL),(982,'Wayne State College',592,'College',NULL),(983,'York College',593,'College',NULL),(984,'Appalachian State University ',594,'University',NULL),(985,'Barton College',595,'College',NULL),(986,'Bennett College',596,'College',NULL),(987,'Brevard College',597,'College',NULL),(988,'Cabarrus College of Health Sciences',598,'College',NULL),(989,'Campbell University ',599,'University',NULL),(990,'Catawba College',600,'College',NULL),(991,'Chowan College ',601,'College',NULL),(992,'Davidson  College ',602,'College',NULL),(993,'Duke University ',603,'University',NULL),(994,'East Carolina University ',604,'University',NULL),(995,'Elizabeth City State University ',605,'University',NULL),(996,'Fayetteville State University ',606,'University',NULL),(997,'Gardner-Webb University ',607,'University',NULL),(998,'Greensboro College',596,'College',NULL),(999,'High Point University',608,'University',NULL),(1000,'Johnson C. Smith University ',609,'University',NULL),(1001,'Lees-McRae College',610,'College',NULL),(1002,'Lenoir-Rhyne College',611,'College',NULL);
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL auto_increment,
  `label` varchar(255) default NULL,
  `identifier` varchar(255) default NULL,
  `description` text,
  `field_type` varchar(255) default 'string',
  `value` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'Site name','site_name',NULL,'string','AfterClassroom','2009-03-31 09:05:35','2009-03-31 09:05:35'),(2,'Site url','site_url',NULL,'string','afterclassroom.com','2009-03-31 09:05:35','2009-04-02 03:43:44'),(3,'Company name','company_name',NULL,'string','AfterClassroom','2009-03-31 09:05:35','2009-03-31 09:05:35'),(4,'Admin email','admin_email',NULL,'string','admin@afterclassroom.com','2009-03-31 09:05:35','2009-03-31 09:05:35'),(5,'Support name','support_name',NULL,'string','Support','2009-03-31 09:05:35','2009-03-31 09:05:35'),(6,'Support email','support_email',NULL,'string','support@afterclassroom.com','2009-03-31 09:05:35','2009-03-31 09:05:35');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipping_methods`
--

DROP TABLE IF EXISTS `shipping_methods`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `shipping_methods` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `shipping_methods`
--

LOCK TABLES `shipping_methods` WRITE;
/*!40000 ALTER TABLE `shipping_methods` DISABLE KEYS */;
INSERT INTO `shipping_methods` VALUES (1,'FedEx'),(2,'UPS'),(3,'USPO');
/*!40000 ALTER TABLE `shipping_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `states` (
  `id` int(11) NOT NULL auto_increment,
  `country_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `alias` varchar(2) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `states`
--

LOCK TABLES `states` WRITE;
/*!40000 ALTER TABLE `states` DISABLE KEYS */;
INSERT INTO `states` VALUES (1,214,'Alabama','AL'),(2,214,'Alaska','AK'),(3,214,'Arizona','AZ'),(4,214,'Arkansas','AR'),(5,214,'California','CA'),(6,214,'Colorado','CO'),(7,214,'Connecticut','CT'),(8,214,'Delaware','DE'),(9,214,'District Of Columbia','DC'),(10,214,'Florida','FL'),(11,214,'Georgia','GA'),(12,214,'Hawaii','HI'),(13,214,'Idaho','ID'),(14,214,'Illinois','IL'),(15,214,'Indiana','IN'),(16,214,'Iowa','IA'),(17,214,'Kansas','KS'),(18,214,'Kentucky','KY'),(19,214,'Louisiana','LA'),(20,214,'Maine','ME'),(21,214,'Maryland','MD'),(22,214,'Massachusetts','MA'),(23,214,'Michigan','MI'),(24,214,'Minnesota','MN'),(25,214,'Mississippi','MS'),(26,214,'Missouri','MO'),(27,214,'Montana','MT'),(28,214,'Nebraska','NE'),(29,214,'Nevada','NV'),(30,214,'New Hampshire','NH'),(31,214,'New Jersey','NJ'),(32,214,'New Mexico','NM'),(33,214,'New York','NY'),(34,214,'North Carolina','NC'),(35,214,'North Dakota','ND'),(36,214,'Ohio','OH'),(37,214,'Oklahoma','OK'),(38,214,'Oregon','OR'),(39,214,'Pennsylvania','PA'),(40,214,'Rhode Island','RI'),(41,214,'South Carolina','SC'),(42,214,'South Dakota','SD'),(43,214,'Tennessee','TN'),(44,214,'Texas','TX'),(45,214,'Utah','UT'),(46,214,'Vermont','VT'),(47,214,'Virginia','VA'),(48,214,'Washington','WA'),(49,214,'West Virginia','WV'),(50,214,'Wisconsin','WI'),(51,214,'Wyoming','WY');
/*!40000 ALTER TABLE `states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stories`
--

DROP TABLE IF EXISTS `stories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `stories` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `stories`
--

LOCK TABLES `stories` WRITE;
/*!40000 ALTER TABLE `stories` DISABLE KEYS */;
INSERT INTO `stories` VALUES (1,4,'alibaba','2009-04-04 07:42:09','2009-04-04 07:42:09'),(2,6,'Chuyen tinh cua toi','2009-04-09 02:48:06','2009-04-09 02:48:06'),(3,6,'Khong con tinh yeu','2009-04-09 02:56:41','2009-04-09 02:56:41'),(4,1,'thththththt','2009-04-13 20:21:21','2009-04-15 02:41:00'),(5,1,'hellol ththeht \r\n\r\n\r\ntyhtht','2009-04-24 21:20:25','2009-04-24 21:20:25');
/*!40000 ALTER TABLE `stories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taggings`
--

DROP TABLE IF EXISTS `taggings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) default NULL,
  `taggable_id` int(11) default NULL,
  `taggable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type` (`taggable_id`,`taggable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `taggings`
--

LOCK TABLES `taggings` WRITE;
/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
INSERT INTO `taggings` VALUES (1,1,5,'Photo','2009-04-22 01:53:27');
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'me');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teamup_categories`
--

DROP TABLE IF EXISTS `teamup_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `teamup_categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `teamup_categories`
--

LOCK TABLES `teamup_categories` WRITE;
/*!40000 ALTER TABLE `teamup_categories` DISABLE KEYS */;
INSERT INTO `teamup_categories` VALUES (1,'Start-up company'),(2,'Research team'),(3,'Soccer team'),(4,'Football team'),(5,'Baseball team'),(6,'Chess team');
/*!40000 ALTER TABLE `teamup_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_educations`
--

DROP TABLE IF EXISTS `user_educations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `user_educations` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `grad_school` varchar(255) default NULL,
  `college` varchar(255) default NULL,
  `high_school` varchar(255) default NULL,
  `elementary` varchar(255) default NULL,
  `favourite_school` varchar(255) default NULL,
  `major` varchar(255) default NULL,
  `level` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `user_educations`
--

LOCK TABLES `user_educations` WRITE;
/*!40000 ALTER TABLE `user_educations` DISABLE KEYS */;
INSERT INTO `user_educations` VALUES (1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-31 09:05:39','2009-03-31 09:05:39'),(2,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-02 02:48:19','2009-04-02 02:48:19'),(3,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-02 02:56:57','2009-04-02 02:56:57'),(4,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-02 02:57:09','2009-04-02 02:57:09'),(5,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-02 03:16:27','2009-04-02 03:16:27'),(6,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-02 03:40:39','2009-04-02 03:40:39'),(7,7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-03 20:11:16','2009-04-03 20:11:16'),(8,8,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-03 20:52:50','2009-04-03 20:52:50'),(9,9,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-06 16:40:47','2009-04-06 16:40:47');
/*!40000 ALTER TABLE `user_educations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_employments`
--

DROP TABLE IF EXISTS `user_employments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `user_employments` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `resume` text,
  `current_employer` varchar(255) default NULL,
  `position_current` varchar(255) default NULL,
  `past_employer` varchar(255) default NULL,
  `position_past` varchar(255) default NULL,
  `favourite_company` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `user_employments`
--

LOCK TABLES `user_employments` WRITE;
/*!40000 ALTER TABLE `user_employments` DISABLE KEYS */;
INSERT INTO `user_employments` VALUES (1,1,NULL,NULL,NULL,NULL,NULL,NULL,'2009-03-31 09:05:39','2009-03-31 09:05:39'),(2,2,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-02 02:48:19','2009-04-02 02:48:19'),(3,3,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-02 02:56:57','2009-04-02 02:56:57'),(4,4,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-02 02:57:09','2009-04-02 02:57:09'),(5,5,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-02 03:16:27','2009-04-02 03:16:27'),(6,6,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-02 03:40:39','2009-04-02 03:40:39'),(7,7,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-03 20:11:16','2009-04-03 20:11:16'),(8,8,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-03 20:52:50','2009-04-03 20:52:50'),(9,9,NULL,NULL,NULL,NULL,NULL,NULL,'2009-04-06 16:40:47','2009-04-06 16:40:47');
/*!40000 ALTER TABLE `user_employments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_informations`
--

DROP TABLE IF EXISTS `user_informations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `user_informations` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `home_town` varchar(255) default NULL,
  `current_town` varchar(255) default NULL,
  `sex` tinyint(1) default NULL,
  `age` int(11) default '0',
  `relationship_status` varchar(255) default NULL,
  `polictical_view` text,
  `interest` text,
  `award` text,
  `i_am_doing` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `user_informations`
--

LOCK TABLES `user_informations` WRITE;
/*!40000 ALTER TABLE `user_informations` DISABLE KEYS */;
INSERT INTO `user_informations` VALUES (1,1,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'I\'m working','2009-03-31 09:05:39','2009-04-15 02:40:08'),(2,2,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'2009-04-02 02:48:19','2009-04-02 02:48:19'),(3,3,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'2009-04-02 02:56:57','2009-04-02 02:56:57'),(4,4,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'2009-04-02 02:57:09','2009-04-02 02:57:09'),(5,5,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'2009-04-02 03:16:27','2009-04-02 03:16:27'),(6,6,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'2009-04-02 03:40:39','2009-04-02 03:40:39'),(7,7,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'2009-04-03 20:11:16','2009-04-03 20:11:16'),(8,8,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'2009-04-03 20:52:50','2009-04-03 20:52:50'),(9,9,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'2009-04-06 16:40:47','2009-04-06 16:40:47');
/*!40000 ALTER TABLE `user_informations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_invites`
--

DROP TABLE IF EXISTS `user_invites`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `user_invites` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `user_id_target` int(11) NOT NULL,
  `code` varchar(255) default NULL,
  `message` text,
  `is_accepted` tinyint(1) default NULL,
  `accepted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `user_invites`
--

LOCK TABLES `user_invites` WRITE;
/*!40000 ALTER TABLE `user_invites` DISABLE KEYS */;
INSERT INTO `user_invites` VALUES (1,6,4,NULL,'I want to make friend with you',NULL,NULL,'2009-04-07 07:20:33','2009-04-07 07:20:33');
/*!40000 ALTER TABLE `user_invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(40) default NULL,
  `identity_url` varchar(255) default NULL,
  `name` varchar(100) default '',
  `email` varchar(100) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `remember_token` varchar(40) default NULL,
  `activation_code` varchar(40) default NULL,
  `state` varchar(255) default 'passive',
  `remember_token_expires_at` datetime default NULL,
  `password_reset_code` varchar(255) default NULL,
  `activated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `school_id` int(11) default NULL,
  `allow_search_by_email` tinyint(1) default NULL,
  `avatar_file_name` varchar(255) default NULL,
  `avatar_content_type` varchar(255) default NULL,
  `avatar_file_size` int(11) default NULL,
  `avatar_updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_users_on_login` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin',NULL,'','admin@afterclassroom.com','4b78ae34c6f63f7611c2c9ffa7dff8e540bb93d5','8075f9e072f4730461689df4d12601874ad65753',NULL,NULL,'active',NULL,NULL,'2009-03-31 09:05:39',NULL,'2009-03-31 09:05:38','2009-03-31 09:05:39',NULL,NULL,NULL,NULL,NULL,NULL),(2,'duyen',NULL,'','duyentnn@gmail.com','d48a3b2c6caa92d75992eab6764374bcaab2fd84','ff605c40e905f5f22ff2a46708d5038680328c0d',NULL,'594ea96abbeedaef68eddf102b90bc0f970ee81b','pending',NULL,NULL,NULL,NULL,'2009-04-02 02:48:18','2009-04-02 02:48:18',3,0,NULL,NULL,NULL,NULL),(3,'tony',NULL,'','dungtqa@gmail.com','06ac6b9a60c7e60e514c865c3107bc258dc1c557','1f78e95099e91e51a1ffafa6a88f0942cf4ae3a9',NULL,NULL,'active',NULL,NULL,'2009-04-02 04:20:39',NULL,'2009-04-02 02:56:56','2009-04-02 04:20:39',1,0,NULL,NULL,NULL,NULL),(4,'anivuive',NULL,'','ani@gmail.com','d470c8690768cdce0cf4db09c68ada0703306d39','1466bb1df9dc55cb5f708821f677767a5c7a2881',NULL,NULL,'active',NULL,NULL,'2009-04-02 07:06:49',NULL,'2009-04-02 02:57:09','2009-04-04 07:50:30',7,0,'Michelle.jpg','image/jpeg',20100,NULL),(5,'toby',NULL,'','yahoo@gmail.com','8a875cce7fc30aef9fdba0638245fe01cc10ca20','6760bcc971043e858040a23d2b10e17428d56ced',NULL,'22577b85bec0b07f5156555ba567092a423e0392','pending',NULL,NULL,NULL,NULL,'2009-04-02 03:16:25','2009-04-02 03:16:25',1,0,NULL,NULL,NULL,NULL),(6,'blame',NULL,'','dungtqa@yahoo.com','5d82f8b4632cfc02d8ccc2018e1c14038652c949','df92ce2e59b647ba34011d971a826cd5d2d22923',NULL,NULL,'active',NULL,NULL,'2009-04-02 03:46:33',NULL,'2009-04-02 03:40:38','2009-04-07 01:44:58',1,0,'abstract-colors-s.jpg','image/jpeg',14452,NULL),(7,'johnny',NULL,'','johnhuynh04@yahoo.com','6c78decbe637a0a19ec78de793ba096f48de4b0a','94e67cf4b96e72611342d6e9f23f1741b581d02a',NULL,'7351b55a256f3a3139d0fbfbf078539506b4c851','pending',NULL,NULL,NULL,NULL,'2009-04-03 20:11:15','2009-04-03 20:11:15',194,1,NULL,NULL,NULL,NULL),(8,'john2',NULL,'','johnhuynh03@yahoo.com','ce1e2f4aa3ac6abe6c19f70d8d6552cf85eddd4a','120f026cfe87df1a26c285de6a579c55baab8638',NULL,NULL,'active',NULL,NULL,'2009-04-03 20:54:00',NULL,'2009-04-03 20:52:50','2009-04-03 20:54:00',3,1,NULL,NULL,NULL,NULL),(9,'quachqhuy',NULL,'','quachqhuy@yahoo.com','ed5a2af3f4321ed357f7980bd3dcd658f89553ac','be58062917c5e27ed75fa0fa1455df97ace414a2',NULL,'997d84709cacb97b2ebd256d9a70fafe1e603364','pending',NULL,NULL,NULL,NULL,'2009-04-06 16:40:46','2009-04-06 16:40:46',175,1,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `video_albums`
--

DROP TABLE IF EXISTS `video_albums`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `video_albums` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `video_albums`
--

LOCK TABLES `video_albums` WRITE;
/*!40000 ALTER TABLE `video_albums` DISABLE KEYS */;
INSERT INTO `video_albums` VALUES (1,4,'MTD','2009-04-04 07:33:42','2009-04-04 07:33:42');
/*!40000 ALTER TABLE `video_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos`
--

DROP TABLE IF EXISTS `videos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `videos` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `video_album_id` int(11) NOT NULL,
  `title` varchar(255) default NULL,
  `description` text,
  `who_can_see` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `video_attach_file_name` varchar(255) default NULL,
  `video_attach_content_type` varchar(255) default NULL,
  `video_attach_file_size` int(11) default NULL,
  `video_attach_updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `videos`
--

LOCK TABLES `videos` WRITE;
/*!40000 ALTER TABLE `videos` DISABLE KEYS */;
INSERT INTO `videos` VALUES (1,4,1,'mtdT0000000','',0,'2009-04-04 07:35:18','2009-04-04 07:35:18','T0000000.AVI','video/avi',514364,NULL),(2,4,1,'T0000002','',0,'2009-04-04 07:36:14','2009-04-04 07:36:14','T0000002.WAV','audio/wav',99406,NULL),(3,4,1,'T0000003','',0,'2009-04-04 07:40:09','2009-04-04 07:40:09','T0000003.AVI','video/avi',5397100,NULL);
/*!40000 ALTER TABLE `videos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-04-28  7:49:09
