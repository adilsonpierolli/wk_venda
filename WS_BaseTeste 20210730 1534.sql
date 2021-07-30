-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.7.11


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema wkbase
--

CREATE DATABASE IF NOT EXISTS wkbase;
USE wkbase;

--
-- Definition of table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes` (
  `codigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `cidade` varchar(50) NOT NULL,
  `uf` varchar(2) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `clientes`
--

/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` (`codigo`,`nome`,`cidade`,`uf`) VALUES 
 (1,'JJOAO CARLOS','UMUARAMA','PR'),
 (2,'MARCOS SILVA','MARINGA','PR'),
 (3,'ANTONIO GONCALVES','MARINGA','PR'),
 (4,'ALEXANDRE DE MORAES','LONDRINA','PR'),
 (5,'MARIA DOS ANJOS','SAO PAULO','PR'),
 (6,'KLEBER','DOURADINA','PR'),
 (7,'ADRIANO DA SILVA','UMUARAM','PR'),
 (8,'ANA FLAVIA B. DA SILVA','UMUARAMA','PR'),
 (9,'ANA LUCIA GONCALVES','UMUARAMA','PR'),
 (10,'GERALDO  DOS ANJOS SANTOS','MARINA','PR'),
 (11,'WAGNER DAS CHAVES','UMUARAMA','PR'),
 (12,'MARIO FERREIRA','CRUZEIRO DO OESTE','PR'),
 (13,'BRUNO ZOIO','UMUARAMA','PR'),
 (14,'GABRIEL','UMUARAMA','PR'),
 (15,'NILSON VASCONCELOS','MARINGA','PR'),
 (16,'NEODIR LUIZ VASCONCELOS','UMUARAMA','PR'),
 (17,'ANDREIA DOS SANTOS','UMUARAMA','PR'),
 (18,'JORGE VENCESLAU','SAO PAULO','PR'),
 (19,'JOANA GUIMARAES','LONDRINA','PR'),
 (20,'ROBERVAL DA SILVA','UMUARAMA','PR'),
 (21,'ANDRE DA SILVA','MARINGA','PR');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;


--
-- Definition of table `generator_tabela`
--

DROP TABLE IF EXISTS `generator_tabela`;
CREATE TABLE `generator_tabela` (
  `tabela` varchar(50) NOT NULL,
  `id_value` int(10) unsigned NOT NULL,
  PRIMARY KEY (`tabela`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `generator_tabela`
--

/*!40000 ALTER TABLE `generator_tabela` DISABLE KEYS */;
INSERT INTO `generator_tabela` (`tabela`,`id_value`) VALUES 
 ('PEDIDO',80);
/*!40000 ALTER TABLE `generator_tabela` ENABLE KEYS */;


--
-- Definition of table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
CREATE TABLE `pedidos` (
  `numpedido` int(10) unsigned NOT NULL,
  `dataemissao` datetime NOT NULL,
  `codigocliente` int(10) unsigned NOT NULL,
  `valortotal` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`numpedido`),
  KEY `FK_pedidos_1` (`codigocliente`),
  CONSTRAINT `FK_pedidos_1` FOREIGN KEY (`codigocliente`) REFERENCES `clientes` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pedidos`
--

/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` (`numpedido`,`dataemissao`,`codigocliente`,`valortotal`) VALUES 
 (1,'2029-07-20 21:00:00',1,'18.50'),
 (12,'2029-07-20 21:00:00',3,'7.50'),
 (13,'2029-07-20 21:00:00',3,'7.50'),
 (47,'2030-07-20 21:00:00',3,'17.00'),
 (49,'2030-07-20 21:00:00',2,'27.40'),
 (55,'2030-07-20 21:00:00',5,'30.40'),
 (56,'2030-07-20 21:00:00',1,'31.90'),
 (57,'2004-07-20 21:00:00',3,'27.50'),
 (67,'2030-07-20 21:00:00',5,'18.50'),
 (68,'2030-07-20 21:00:00',2,'24.40'),
 (70,'2030-07-20 21:00:00',3,'63.00'),
 (71,'2030-07-20 21:00:00',5,'19.50'),
 (72,'2030-07-20 21:00:00',2,'43.50'),
 (74,'2030-07-20 21:00:00',2,'26.50');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;


--
-- Definition of table `pedidos_produtos`
--

DROP TABLE IF EXISTS `pedidos_produtos`;
CREATE TABLE `pedidos_produtos` (
  `id_auto` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `numeropedido` int(10) unsigned NOT NULL,
  `codigoproduto` int(10) unsigned NOT NULL,
  `quantidade` int(10) unsigned NOT NULL,
  `valorunitario` decimal(10,2) DEFAULT NULL,
  `valortotal` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id_auto`),
  KEY `FK_pedidos_produtos_codprod` (`codigoproduto`),
  KEY `FK_pedidos_produtos_numeropedido` (`numeropedido`),
  CONSTRAINT `FK_pedidos_produtos_codprod` FOREIGN KEY (`codigoproduto`) REFERENCES `produtos` (`codigo`),
  CONSTRAINT `FK_pedidos_produtos_numeropedido` FOREIGN KEY (`numeropedido`) REFERENCES `pedidos` (`numpedido`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pedidos_produtos`
--

/*!40000 ALTER TABLE `pedidos_produtos` DISABLE KEYS */;
INSERT INTO `pedidos_produtos` (`id_auto`,`numeropedido`,`codigoproduto`,`quantidade`,`valorunitario`,`valortotal`) VALUES 
 (1,13,1,1,'4.50','4.50'),
 (2,13,2,1,'3.00','3.00'),
 (6,49,1,2,'4.50','9.00'),
 (7,49,3,1,'11.00','11.00'),
 (8,49,4,1,'7.40','7.40'),
 (9,55,1,2,'4.50','9.00'),
 (10,55,2,1,'3.00','3.00'),
 (11,55,3,1,'11.00','11.00'),
 (12,55,4,1,'7.40','7.40'),
 (13,56,1,1,'4.50','4.50'),
 (14,56,2,1,'3.00','3.00'),
 (15,56,3,1,'11.00','11.00'),
 (16,56,4,1,'7.40','7.40'),
 (17,56,5,1,'6.00','6.00'),
 (18,57,1,1,'4.50','4.50'),
 (19,57,2,1,'3.00','3.00'),
 (20,57,3,1,'11.00','11.00'),
 (21,57,5,1,'6.00','6.00'),
 (22,57,2,1,'3.00','3.00'),
 (28,67,1,1,'4.50','4.50'),
 (29,67,2,1,'3.00','3.00'),
 (30,67,3,1,'11.00','11.00'),
 (31,68,3,1,'11.00','11.00'),
 (32,68,4,1,'7.40','7.40'),
 (33,68,5,1,'6.00','6.00'),
 (34,70,1,1,'4.50','4.50'),
 (35,70,2,2,'3.00','6.00'),
 (36,70,3,1,'11.00','11.00'),
 (37,70,4,5,'7.40','37.00'),
 (38,70,1,1,'4.50','4.50'),
 (39,71,1,1,'4.50','4.50'),
 (40,71,2,1,'3.00','3.00'),
 (41,71,5,1,'6.00','6.00'),
 (42,71,5,1,'6.00','6.00'),
 (43,72,3,1,'11.00','11.00'),
 (44,72,2,1,'3.00','3.00'),
 (45,72,3,1,'11.00','11.00'),
 (46,72,8,1,'3.50','3.50'),
 (47,72,10,1,'7.00','7.00'),
 (48,72,15,1,'8.00','8.00'),
 (49,74,1,1,'4.50','4.50'),
 (50,74,12,1,'6.50','6.50'),
 (51,74,13,1,'7.00','7.00'),
 (52,74,14,1,'8.50','8.50');
/*!40000 ALTER TABLE `pedidos_produtos` ENABLE KEYS */;


--
-- Definition of table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
CREATE TABLE `produtos` (
  `codigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descricao` varchar(50) NOT NULL,
  `precovenda` decimal(10,2) NOT NULL,
  PRIMARY KEY (`codigo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `produtos`
--

/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` (`codigo`,`descricao`,`precovenda`) VALUES 
 (1,'COCA-LATA','4.50'),
 (2,'FANTA LARANJA','3.00'),
 (3,'ARROZ','11.00'),
 (4,'FEIJAO','7.40'),
 (5,'BANANA','6.00'),
 (6,'ABACATE','3.40'),
 (7,'MANDIOCA','4.00'),
 (8,'FANTA UVA','3.50'),
 (9,'SUCO PRATS','4.00'),
 (10,'HEINEKEN','7.00'),
 (11,'SKOL','6.00'),
 (12,'BRAHMA','6.50'),
 (13,'MEGA CHOPP','7.00'),
 (14,'CERVEJA ORIGINAL','8.50'),
 (15,'BOEMIA','8.00'),
 (16,'CERVEJA COLORADO','12.50'),
 (17,'UVA','5.50'),
 (18,'QUEIJO ','17.00'),
 (19,'GOIABADA','13.00'),
 (20,'MUSSARELA','23.50'),
 (21,'MORTADELA','17.00'),
 (22,'OVOS 30','12.50'),
 (23,'BLUSA INVERNO','89.00');
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
