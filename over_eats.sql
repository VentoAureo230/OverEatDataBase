-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : jeu. 15 juin 2023 à 11:29
-- Version du serveur : 8.0.31
-- Version de PHP : 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `over_eats`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `archive_client_inactif`$$
CREATE DEFINER=`bastien`@`localhost` PROCEDURE `archive_client_inactif` ()  NO SQL BEGIN
DECLARE fin BOOLEAN DEFAULT FALSE;
DECLARE id_archive INT;
DECLARE tel_archive varchar(10);
DECLARE nom_archive varchar(50);
DECLARE prenom_archive varchar(50);
DECLARE email_archive varchar(255);
DECLARE date_creation_archive DATE;
DECLARE curs_dupli CURSOR
FOR SELECT c.id_client, c.telephone, c.nom, c.prenom, c.email, c.date_creation FROM client c LEFT JOIN commande cmd ON cmd.client_id_client = c.id_client WHERE c.est_actif = 0;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;
OPEN curs_dupli;
loop_cursor: LOOP
FETCH curs_dupli INTO id_archive, tel_archive, nom_archive, prenom_archive, email_archive, date_creation_archive;
IF fin THEN 
LEAVE loop_cursor;
END IF;
INSERT INTO archive_client(id_client, telephone, nom, prenom, email, date_creation) VALUE (id_archive, tel_archive, nom_archive, prenom_archive, email_archive, date_creation_archive);
DELETE FROM client WHERE id_archive = client.id_client;
END LOOP;

CLOSE curs_dupli;

END$$

DROP PROCEDURE IF EXISTS `archive_commande_annule`$$
CREATE DEFINER=`bastien`@`localhost` PROCEDURE `archive_commande_annule` ()   BEGIN
DECLARE fin BOOLEAN DEFAULT FALSE;
DECLARE numero_commande_archive INT;
DECLARE date_commande_archive DATE;
DECLARE date_coursier_archive DATE;
DECLARE date_livraison_archive DATE;
DECLARE prix_archive FLOAT;
DECLARE curs_dupli CURSOR
FOR SELECT c.numero_commande, c.date_commande, c.date_coursier, c.date_livraison, c.prix FROM commande c JOIN statut stt ON stt.type = c.statut_type WHERE stt.type = 'annulé';

DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;
OPEN curs_dupli;
loop_cursor: LOOP
FETCH curs_dupli INTO numero_commande_archive, date_commande_archive, date_coursier_archive, date_livraison_archive, prix_archive;
IF fin THEN 
LEAVE loop_cursor;
END IF;
IF YEAR(date_commande_archive) <= YEAR(CURRENT_DATE) - 3 THEN
INSERT INTO archive_commande(numero_commande, date_commande, date_coursier, date_livraison, prix) VALUE (numero_commande_archive, date_commande_archive, date_coursier_archive, date_livraison_archive, prix_archive);
DELETE FROM commande cmd WHERE numero_commande_archive = cmd.numero_commande;
END IF;
END LOOP;

CLOSE curs_dupli;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `adresse_client`
--

DROP TABLE IF EXISTS `adresse_client`;
CREATE TABLE IF NOT EXISTS `adresse_client` (
  `id_adresse_client` int NOT NULL AUTO_INCREMENT,
  `ville_adresse_client` varchar(45) NOT NULL,
  `code_postal_adresse_client` int NOT NULL,
  `rue_adresse_client` varchar(75) NOT NULL,
  PRIMARY KEY (`id_adresse_client`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `adresse_client`
--

INSERT INTO `adresse_client` (`id_adresse_client`, `ville_adresse_client`, `code_postal_adresse_client`, `rue_adresse_client`) VALUES
(1, 'Rennes', 35000, '3 rue Fernand Robert'),
(2, 'Marseille', 13015, '90 boulevard de la Liberation'),
(3, 'Grenoble', 38000, '35 avenue Ferdinand de Lesseps'),
(4, 'Saint-Étienne', 42000, '10 rue Sébastopol'),
(5, 'Bourges', 18000, '60 rue Petite Fusterie'),
(6, 'Lyon', 69001, '8 rue du Pont Neuf'),
(7, 'Toulouse', 31000, '15 avenue des Minimes'),
(8, 'Bordeaux', 33000, '25 rue Sainte-Catherine'),
(9, 'Lille', 59000, '12 place du Général de Gaulle'),
(10, 'Nantes', 44000, '7 rue de la Paix');

-- --------------------------------------------------------

--
-- Structure de la table `adresse_restaurant`
--

DROP TABLE IF EXISTS `adresse_restaurant`;
CREATE TABLE IF NOT EXISTS `adresse_restaurant` (
  `rue` varchar(255) NOT NULL,
  `ville` varchar(45) NOT NULL,
  `code_postal` int NOT NULL,
  PRIMARY KEY (`rue`,`ville`,`code_postal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `adresse_restaurant`
--

INSERT INTO `adresse_restaurant` (`rue`, `ville`, `code_postal`) VALUES
('10 rue de la République', 'Lyon', 69002),
('15 boulevard Jean Jaurès', 'Nantes', 44000),
('25 avenue Victor Hugo', 'Toulouse', 31100),
('30 rue de Paris', 'Lille', 59000),
('31 Faubourg Saint Honoré', 'Paris', 75018),
('40 rue de Groussay', 'Romainville', 93230),
('5 quai de la Douane', 'Bordeaux', 33000),
('77 rue Ernest Renan', 'Chaumont', 52000),
('95 rue Lenotre', 'Rambouillet', 78120),
('99 Place de la Gare', 'Colomiers', 31770);

-- --------------------------------------------------------

--
-- Structure de la table `allergene`
--

DROP TABLE IF EXISTS `allergene`;
CREATE TABLE IF NOT EXISTS `allergene` (
  `code` int NOT NULL,
  `nom_allergene` varchar(45) NOT NULL,
  `description_allergene` mediumtext NOT NULL,
  PRIMARY KEY (`code`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `allergene`
--

INSERT INTO `allergene` (`code`, `nom_allergene`, `description_allergene`) VALUES
(20, 'amande', 'Noix, Solanacees'),
(24, 'crevettes', 'fruit de mer'),
(25, 'noix', 'Fruits à coque'),
(30, 'arachides', 'Légumineuses'),
(35, 'œufs', 'animal'),
(40, 'soja', 'Légumineuses'),
(45, 'moutarde', 'Condiment'),
(74, 'cafe', 'autres'),
(79, 'glutene', 'farine'),
(168, 'lait en poudre', 'produits laitiers, oeufs');

-- --------------------------------------------------------

--
-- Structure de la table `archive_client`
--

DROP TABLE IF EXISTS `archive_client`;
CREATE TABLE IF NOT EXISTS `archive_client` (
  `id_client` int NOT NULL,
  `telephone` varchar(10) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `date_creation` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_client`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `archive_client`
--

INSERT INTO `archive_client` (`id_client`, `telephone`, `nom`, `prenom`, `email`, `date_creation`) VALUES
(5, '0659985632', 'Finlay', 'Valdimarsson', 'valdimarsson.finlay@hotmail.com', '2014-06-03 22:00:00');

-- --------------------------------------------------------

--
-- Structure de la table `archive_commande`
--

DROP TABLE IF EXISTS `archive_commande`;
CREATE TABLE IF NOT EXISTS `archive_commande` (
  `numero_commande` int NOT NULL,
  `date_commande` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_coursier` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_livraison` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `prix` float NOT NULL,
  PRIMARY KEY (`numero_commande`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `archive_commande`
--

INSERT INTO `archive_commande` (`numero_commande`, `date_commande`, `date_coursier`, `date_livraison`, `prix`) VALUES
(10, '2016-05-31 22:00:00', '2023-06-13 22:00:00', '2023-06-13 22:00:00', 22.99);

-- --------------------------------------------------------

--
-- Structure de la table `avis_coursier`
--

DROP TABLE IF EXISTS `avis_coursier`;
CREATE TABLE IF NOT EXISTS `avis_coursier` (
  `note` int NOT NULL,
  `avis` mediumtext,
  `date_publication` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `coursier_id_coursier` int NOT NULL,
  `commande_numero_commande` int NOT NULL,
  `client_id_client` int NOT NULL,
  PRIMARY KEY (`coursier_id_coursier`,`commande_numero_commande`,`client_id_client`),
  KEY `fk_avis_coursier_commande1_idx` (`commande_numero_commande`),
  KEY `fk_avis_coursier_client1_idx` (`client_id_client`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `avis_coursier`
--

INSERT INTO `avis_coursier` (`note`, `avis`, `date_publication`, `coursier_id_coursier`, `commande_numero_commande`, `client_id_client`) VALUES
(5, 'Un bon coursier rapide', '2022-06-16 08:32:30', 1, 1, 1),
(1, 'commande annulé car il l\'a perdu', '2023-06-07 08:34:47', 2, 2, 2),
(3, 'en retard !', '2023-06-07 08:35:39', 3, 3, 3),
(4, 'Coursier rapide et efficace', '2023-06-07 08:37:05', 5, 5, 5);

-- --------------------------------------------------------

--
-- Structure de la table `avis_restaurant`
--

DROP TABLE IF EXISTS `avis_restaurant`;
CREATE TABLE IF NOT EXISTS `avis_restaurant` (
  `note` int NOT NULL,
  `avis` mediumtext,
  `date_publication` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `restaurant_id_restaurant` int NOT NULL,
  `client_id_client` int NOT NULL,
  `commande_numero_commande` int NOT NULL,
  PRIMARY KEY (`restaurant_id_restaurant`,`client_id_client`,`commande_numero_commande`),
  KEY `fk_avis_restaurant_restaurant1_idx` (`restaurant_id_restaurant`),
  KEY `fk_avis_restaurant_client1_idx` (`client_id_client`),
  KEY `fk_avis_restaurant_commande1_idx` (`commande_numero_commande`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `avis_restaurant`
--

INSERT INTO `avis_restaurant` (`note`, `avis`, `date_publication`, `restaurant_id_restaurant`, `client_id_client`, `commande_numero_commande`) VALUES
(4, 'Excellente adresse. Les plats sont excellents et les viandes très généreuses avec un respect des cuissons demandées.', '2023-06-07 08:42:34', 1, 3, 3);

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `id_client` int NOT NULL AUTO_INCREMENT,
  `telephone` varchar(10) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(45) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `date_creation` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modification` timestamp NULL DEFAULT NULL,
  `date_suppression` timestamp NULL DEFAULT NULL,
  `est_actif` tinyint NOT NULL,
  `moyen_paiement_numero` varchar(16) NOT NULL,
  PRIMARY KEY (`id_client`) USING BTREE,
  UNIQUE KEY `telephone_client_UNIQUE` (`telephone`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  KEY `fk_client_moyen_paiement1_idx` (`moyen_paiement_numero`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `client`
--

INSERT INTO `client` (`id_client`, `telephone`, `nom`, `prenom`, `email`, `mot_de_passe`, `date_creation`, `date_modification`, `date_suppression`, `est_actif`, `moyen_paiement_numero`) VALUES
(1, '0623567952', 'Felicita', 'Nino', 'nino.felicita@gmail.com', '7682fe272099ea26efe39c890b33675b', '2023-06-07 04:58:11', NULL, NULL, 1, '4533306646836717'),
(2, '0759624628', 'Inarkaevich', 'Henry', 'henry.inarkaevich@gmail.com', '3244b30438420d58b018cf3143bae178', '2023-06-07 05:00:27', NULL, NULL, 1, '4979654486941019'),
(3, '0652356593', 'Henryka', 'Boumans', 'boumans.henryka@gmail.com', 'f45731e3d39a1b2330bbf93e9b3de59e', '2016-06-01 07:04:31', NULL, NULL, 1, '5134121818067631'),
(4, '0653059542', 'Jesaja', 'Koru', 'koru.jesaja@gmail.com', '3691308f2a4c2f6983f2880d32e29c84', '2016-06-01 07:06:02', NULL, NULL, 1, '5292921286155810'),
(6, '0650123456', 'Dupont', 'Marie', 'marie.dupont@example.com', 'e6c4b95d5cc2092cc0b6c1c087d5be78', '2023-06-07 09:00:00', NULL, NULL, 1, '6011453098745632'),
(7, '0678901234', 'Lefevre', 'Thomas', 'thomas.lefevre@example.com', '30b9b432ae7d11809c9f5045f101b2b4', '2023-06-07 09:01:00', NULL, NULL, 1, '6349781523698475'),
(8, '0612345678', 'Martin', 'Julie', 'julie.martin@example.com', 'ff29f1f0660d222fa07ee91bc3dc0c33', '2023-06-07 09:02:00', NULL, NULL, 1, '6498104576932415'),
(9, '0634567890', 'Dubois', 'Luc', 'luc.dubois@example.com', 'cfc4ac5035ff4a9069d95d2ad1a2ad24', '2023-06-07 09:03:00', NULL, NULL, 1, '6751936402813547'),
(10, '0690123456', 'Petit', 'Emma', 'emma.petit@example.com', 'd99d679bb841bea3c2805c9b1a59ed4a', '2023-06-07 07:04:00', NULL, NULL, 1, '6894127530965421');

-- --------------------------------------------------------

--
-- Structure de la table `client_a_adresse_client`
--

DROP TABLE IF EXISTS `client_a_adresse_client`;
CREATE TABLE IF NOT EXISTS `client_a_adresse_client` (
  `client_id_client` int NOT NULL,
  `adresse_client_id_adresse_client` int NOT NULL,
  PRIMARY KEY (`client_id_client`,`adresse_client_id_adresse_client`),
  KEY `fk_client_a_adresse_client_adresse_client1_idx` (`adresse_client_id_adresse_client`),
  KEY `fk_client_a_adresse_client_client1_idx` (`client_id_client`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `client_a_adresse_client`
--

INSERT INTO `client_a_adresse_client` (`client_id_client`, `adresse_client_id_adresse_client`) VALUES
(3, 3),
(4, 4),
(6, 6),
(7, 7),
(8, 8),
(9, 9);

-- --------------------------------------------------------

--
-- Structure de la table `commande`
--

DROP TABLE IF EXISTS `commande`;
CREATE TABLE IF NOT EXISTS `commande` (
  `numero_commande` int NOT NULL AUTO_INCREMENT,
  `date_commande` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_coursier` timestamp NULL DEFAULT NULL,
  `date_livraison` timestamp NULL DEFAULT NULL,
  `prix` float NOT NULL,
  `ville` varchar(45) NOT NULL,
  `statut_type` varchar(30) NOT NULL,
  `coursier_id_coursier` int NOT NULL,
  `client_id_client` int NOT NULL,
  PRIMARY KEY (`numero_commande`,`statut_type`,`coursier_id_coursier`,`client_id_client`),
  UNIQUE KEY `numero_commande_UNIQUE` (`numero_commande`),
  KEY `fk_commande_statut1_idx` (`statut_type`),
  KEY `fk_commande_coursier2_idx` (`coursier_id_coursier`),
  KEY `fk_commande_client1_idx` (`client_id_client`)
) ENGINE=InnoDB AUTO_INCREMENT=125546469 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `commande`
--

INSERT INTO `commande` (`numero_commande`, `date_commande`, `date_coursier`, `date_livraison`, `prix`, `ville`, `statut_type`, `coursier_id_coursier`, `client_id_client`) VALUES
(1, '2020-06-01 08:24:08', '2020-06-01 10:24:08', '2020-06-01 11:24:08', 69.99, 'Rennes', 'effectué', 1, 3),
(2, '2021-06-04 08:28:05', '2021-06-04 09:28:05', '2021-06-04 10:28:05', 0, 'Marseille', 'annulé', 2, 2),
(3, '2023-06-07 08:31:09', '2023-06-07 08:31:09', '2023-06-07 08:31:09', 30.99, 'Grenoble', 'retardé', 3, 3),
(4, '2023-06-07 07:28:05', '2023-06-07 07:40:05', '2023-06-07 08:31:09', 59.99, 'Saint-Étienne', 'en cours', 4, 4),
(5, '2018-06-07 08:28:05', '2018-06-07 09:28:05', '2018-06-07 10:28:05', 70, 'Bourges', 'effectué', 5, 5),
(6, '2023-06-14 08:30:00', '2023-06-14 10:30:00', '2023-06-14 11:30:00', 25.99, 'Paris', 'en cours', 6, 6),
(7, '2023-06-14 08:35:00', NULL, NULL, 12.99, 'Lyon', 'en attente', 7, 7),
(8, '2023-06-14 08:40:00', '2023-06-14 08:40:00', '2023-06-14 08:40:00', 19.99, 'Bordeaux', 'en attente', 8, 8),
(9, '2023-06-14 07:45:00', NULL, NULL, 15.99, 'Toulouse', 'en attente', 9, 9);

--
-- Déclencheurs `commande`
--
DROP TRIGGER IF EXISTS `apres_insertion_commande`;
DELIMITER $$
CREATE TRIGGER `apres_insertion_commande` AFTER INSERT ON `commande` FOR EACH ROW UPDATE client
JOIN (
    SELECT client_id_client, MAX(date_commande) AS max_date 
    FROM commande 
    GROUP BY client_id_client 
    HAVING YEAR(max_date) <= YEAR(CURRENT_DATE) - 2) AS c 
ON c.client_id_client = client.id_client
SET client.est_actif = 0
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `commande_a_menu`
--

DROP TABLE IF EXISTS `commande_a_menu`;
CREATE TABLE IF NOT EXISTS `commande_a_menu` (
  `menu_id_menu` int NOT NULL,
  `commande_numero_commande` int NOT NULL,
  `quantitee` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`menu_id_menu`,`commande_numero_commande`),
  KEY `fk_menu_a_commande_commande1_idx` (`commande_numero_commande`),
  KEY `fk_menu_a_commande_menu1_idx` (`menu_id_menu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `commande_a_menu`
--

INSERT INTO `commande_a_menu` (`menu_id_menu`, `commande_numero_commande`, `quantitee`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 1);

-- --------------------------------------------------------

--
-- Structure de la table `contact_de_reference`
--

DROP TABLE IF EXISTS `contact_de_reference`;
CREATE TABLE IF NOT EXISTS `contact_de_reference` (
  `id_contact` int NOT NULL AUTO_INCREMENT,
  `telephone` varchar(10) NOT NULL,
  `nom` varchar(45) NOT NULL,
  `prenom` varchar(45) NOT NULL,
  `restaurant_id_restaurant` int NOT NULL,
  PRIMARY KEY (`id_contact`,`restaurant_id_restaurant`),
  KEY `fk_contact_de_reference_restaurant1_idx` (`restaurant_id_restaurant`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `contact_de_reference`
--

INSERT INTO `contact_de_reference` (`id_contact`, `telephone`, `nom`, `prenom`, `restaurant_id_restaurant`) VALUES
(1, '0647589564', 'Moreau', 'Jérôme ', 1),
(2, '0756986512', 'Fouquet', 'Esperanza ', 2),
(3, '0265984513', 'Gaillard', 'Sylvie ', 3),
(4, '0698123565', 'Huppé', 'Amedee ', 4),
(5, '0789453265', 'Chrétien', 'Ray', 5),
(6, '0645123654', 'Gagnon', 'Marie', 6),
(7, '0756234897', 'Lévesque', 'Philippe', 7),
(8, '0265487965', 'Roy', 'Sophie', 8),
(9, '0698547123', 'Bouchard', 'Patrick', 9),
(10, '0789632145', 'Gauthier', 'Isabelle', 10);

-- --------------------------------------------------------

--
-- Structure de la table `coursier`
--

DROP TABLE IF EXISTS `coursier`;
CREATE TABLE IF NOT EXISTS `coursier` (
  `id_coursier` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `telephone` varchar(10) NOT NULL,
  `date_creation` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modification` timestamp NULL DEFAULT NULL,
  `date_suppression` timestamp NULL DEFAULT NULL,
  `est_actif` tinyint NOT NULL,
  `type_vehicule_nom_type_vehicule` varchar(50) NOT NULL,
  PRIMARY KEY (`id_coursier`) USING BTREE,
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `telephone_coursier_UNIQUE` (`telephone`),
  KEY `fk_coursier_type_vehicule1_idx` (`type_vehicule_nom_type_vehicule`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `coursier`
--

INSERT INTO `coursier` (`id_coursier`, `nom`, `prenom`, `email`, `mot_de_passe`, `telephone`, `date_creation`, `date_modification`, `date_suppression`, `est_actif`, `type_vehicule_nom_type_vehicule`) VALUES
(1, 'Laberge', 'Amber ', 'amber.laberge@yahoo.fr', 'aa38a46efc3002b35e46f7313f819612', '0654213598', '2023-06-07 08:18:34', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 'moto'),
(2, 'Beauchemin', 'Kari', 'beauchemin.kari@gmail.com', 'd58e3582afa99040e27b92b13c8f2280', '0635984564', '2023-06-07 08:19:39', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 'trottinette'),
(3, 'Poulin', 'Hilaire', 'hilaire.poulin@gmail.com', 'bdb9b29708a7caff6a9df287bcf74f85', '0654983545', '2023-06-07 08:21:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 'velo'),
(4, 'Boulanger', 'Tabor', 'tabor.boulanger@orange.fr', '3784f2fc676e500949163bc0f2b9993d', '0654983215', '2023-06-07 08:21:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 'voiture'),
(5, 'Provencher', 'Medoro', 'medoro.provencher@gmail.com', '8e02236c1915a0fda32ab09b00dfcf70', '0654983216', '2023-06-07 08:21:47', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 'moto'),
(6, 'Dupuis', 'Marie', 'marie.dupuis@gmail.com', '5f4dcc3b5aa765d61d8327deb882cf99', '0632135698', '2023-06-10 13:30:21', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 'velo'),
(7, 'Lefebvre', 'Jean', 'jean.lefebvre@yahoo.fr', '202cb962ac59075b964b07152d234b70', '0658741236', '2023-06-10 13:31:42', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 'voiture'),
(8, 'Tremblay', 'Sophie', 'sophie.tremblay@gmail.com', '81dc9bdb52d04dc20036dbd8313ed055', '0632147852', '2023-06-10 13:32:59', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 'trottinette'),
(9, 'Roy', 'Pierre', 'pierre.roy@orange.fr', 'e10adc3949ba59abbe56e057f20f883e', '0658749632', '2023-06-10 13:34:15', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 'moto'),
(10, 'Gagnon', 'Isabelle', 'isabelle.gagnon@gmail.com', '25f9e794323b453885f5181f1b624d0b', '0632145698', '2023-06-10 13:35:30', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 'velo');

-- --------------------------------------------------------

--
-- Structure de la table `coursier_a_zone_geographique`
--

DROP TABLE IF EXISTS `coursier_a_zone_geographique`;
CREATE TABLE IF NOT EXISTS `coursier_a_zone_geographique` (
  `coursier_id_coursier` int NOT NULL,
  `zone_geographique_id_adresse_coursier` int NOT NULL,
  `zone_active` varchar(45) NOT NULL,
  PRIMARY KEY (`coursier_id_coursier`,`zone_geographique_id_adresse_coursier`),
  KEY `fk_coursier_a_zone_geographique_zone_geographique1_idx` (`zone_geographique_id_adresse_coursier`),
  KEY `fk_coursier_a_zone_geographique_coursier1_idx` (`coursier_id_coursier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `coursier_a_zone_geographique`
--

INSERT INTO `coursier_a_zone_geographique` (`coursier_id_coursier`, `zone_geographique_id_adresse_coursier`, `zone_active`) VALUES
(1, 1, 'est_actif'),
(2, 2, 'est_actif'),
(3, 3, 'est_actif'),
(4, 4, 'est_actif'),
(5, 5, 'est_actif'),
(6, 6, 'est_actif'),
(7, 7, 'est_actif'),
(8, 8, 'est_actif'),
(9, 9, 'est_actif'),
(10, 10, 'est_actif');

-- --------------------------------------------------------

--
-- Structure de la table `facture`
--

DROP TABLE IF EXISTS `facture`;
CREATE TABLE IF NOT EXISTS `facture` (
  `numero_facture` int NOT NULL AUTO_INCREMENT,
  `date_emission` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_limite_paiement` timestamp NULL DEFAULT NULL,
  `date_paiement` timestamp NULL DEFAULT NULL,
  `commande_numero_commande` int NOT NULL,
  PRIMARY KEY (`numero_facture`,`commande_numero_commande`),
  KEY `fk_facture_commande1_idx` (`commande_numero_commande`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `facture`
--

INSERT INTO `facture` (`numero_facture`, `date_emission`, `date_limite_paiement`, `date_paiement`, `commande_numero_commande`) VALUES
(1, '2020-06-01 08:24:08', '2020-06-01 10:24:08', '2020-06-01 11:24:08', 1),
(2, '2021-06-04 08:28:05', '2021-06-04 09:28:05', '2021-06-04 10:28:05', 2),
(3, '2023-06-07 08:31:09', '2023-06-07 08:31:09', '2023-06-07 08:31:09', 3),
(4, '2023-06-07 07:28:05', '2023-06-07 07:40:05', '2023-06-07 08:31:09', 4),
(5, '2018-06-07 08:28:05', '2018-06-07 09:28:05', '2018-06-07 10:28:05', 5),
(6, '2023-06-14 08:30:00', '2023-06-14 10:30:00', '2023-06-14 11:30:00', 6),
(7, '2023-06-14 08:35:00', '2023-06-14 09:35:00', '2023-06-14 08:30:00', 7),
(8, '2023-06-14 08:40:00', '2023-06-14 08:40:00', '2023-06-07 08:31:09', 8),
(9, '2023-06-14 07:45:00', '2023-06-14 08:45:00', '2021-06-04 10:28:05', 9);

-- --------------------------------------------------------

--
-- Structure de la table `favoris`
--

DROP TABLE IF EXISTS `favoris`;
CREATE TABLE IF NOT EXISTS `favoris` (
  `id_favoris` int NOT NULL AUTO_INCREMENT,
  `est_favoris` tinyint NOT NULL DEFAULT '0',
  `restaurant_id_restaurant` int NOT NULL,
  `client_id_client` int NOT NULL,
  `menu_id_menu` int NOT NULL,
  PRIMARY KEY (`id_favoris`,`restaurant_id_restaurant`,`client_id_client`,`menu_id_menu`) USING BTREE,
  KEY `fk_favoris_restaurant1_idx` (`restaurant_id_restaurant`),
  KEY `fk_favoris_client1_idx` (`client_id_client`),
  KEY `fk_menu_id` (`menu_id_menu`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `favoris`
--

INSERT INTO `favoris` (`id_favoris`, `est_favoris`, `restaurant_id_restaurant`, `client_id_client`, `menu_id_menu`) VALUES
(3, 1, 3, 3, 3),
(4, 1, 4, 4, 4),
(6, 1, 6, 6, 6),
(7, 1, 7, 7, 7),
(8, 1, 8, 8, 8),
(9, 1, 9, 9, 9);

-- --------------------------------------------------------

--
-- Structure de la table `media`
--

DROP TABLE IF EXISTS `media`;
CREATE TABLE IF NOT EXISTS `media` (
  `id_media` int NOT NULL AUTO_INCREMENT,
  `url` varchar(45) NOT NULL,
  PRIMARY KEY (`id_media`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `media`
--

INSERT INTO `media` (`id_media`, `url`) VALUES
(1, 'http://dummyimage.com/208x100.png/cc0000/ffff'),
(2, 'http://dummyimage.com/211x100.png/5fa2dd/ffff'),
(3, 'http://dummyimage.com/241x100.png/5fa2dd/ffff'),
(4, 'http://dummyimage.com/184x100.png/ff4444/ffff'),
(5, 'http://dummyimage.com/160x100.png/ff4444/ffff'),
(6, 'http://dummyimage.com/113x100.png/ff4444/ffff'),
(7, 'http://dummyimage.com/127x100.png/dddddd/0000'),
(8, 'http://dummyimage.com/200x100.png/5fa2dd/ffff'),
(9, 'http://dummyimage.com/232x100.png/cc0000/ffff'),
(10, 'http://dummyimage.com/223x100.png/cc0000/ffff'),
(11, 'http://dummyimage.com/207x100.png/ff4444/ffff'),
(12, 'http://dummyimage.com/192x100.png/ff4444/ffff'),
(13, 'http://dummyimage.com/175x100.png/ff4444/ffff'),
(14, 'http://dummyimage.com/140x100.png/5fa2dd/ffff'),
(15, 'http://dummyimage.com/101x100.png/cc0000/ffff'),
(16, 'http://dummyimage.com/225x100.png/cc0000/ffff'),
(17, 'http://dummyimage.com/195x100.png/cc0000/ffff'),
(18, 'http://dummyimage.com/120x100.png/cc0000/ffff'),
(19, 'http://dummyimage.com/245x100.png/ff4444/ffff'),
(20, 'http://dummyimage.com/194x100.png/ff4444/ffff');

-- --------------------------------------------------------

--
-- Structure de la table `menu`
--

DROP TABLE IF EXISTS `menu`;
CREATE TABLE IF NOT EXISTS `menu` (
  `id_menu` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) NOT NULL,
  `description` mediumtext NOT NULL,
  `prix` float NOT NULL,
  `date_creation` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modification` timestamp NULL DEFAULT NULL,
  `date_suppression` timestamp NULL DEFAULT NULL,
  `media_id_media` int DEFAULT NULL,
  `promotion_id_promotion` int DEFAULT NULL,
  `restaurant_id_restaurant` int DEFAULT NULL,
  PRIMARY KEY (`id_menu`) USING BTREE,
  KEY `fk_promotion_id_promotion` (`promotion_id_promotion`) USING BTREE,
  KEY `fk_menu_media` (`media_id_media`),
  KEY `fk_menu_restaurant` (`restaurant_id_restaurant`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `menu`
--

INSERT INTO `menu` (`id_menu`, `nom`, `description`, `prix`, `date_creation`, `date_modification`, `date_suppression`, `media_id_media`, `promotion_id_promotion`, `restaurant_id_restaurant`) VALUES
(1, 'Maxi sushi', 'Un menu de qualité pour des sushi de qualité', 30, '2023-06-07 11:56:20', NULL, NULL, 1, 1, 1),
(2, 'King size', 'Mmh des burgers', 15.99, '2023-06-07 11:56:20', NULL, NULL, 15, NULL, 2),
(3, 'Coulis de caviar', 'Du caviar et encore du caviar', 69.99, '2023-06-07 11:56:20', NULL, NULL, 17, NULL, 3),
(4, 'La pizza de la mama', 'Des pizzas à volonté', 19.99, '2023-06-07 11:56:20', NULL, NULL, 12, NULL, 4),
(5, 'La miso collection', 'Plusieurs soupes dont la soupe miso', 20.99, '2023-06-07 11:56:20', NULL, NULL, 20, NULL, 5),
(6, 'Sushi Deluxe', 'Un assortiment de sushi haut de gamme', 35.99, '2023-06-14 08:30:00', NULL, NULL, 9, 2, 6),
(7, 'Burger Suprême', 'Le burger ultime pour les amateurs de viande', 17.99, '2023-06-14 08:30:00', NULL, NULL, 16, NULL, 7),
(8, 'Menu Dégustation', 'Une expérience culinaire inoubliable', 89.99, '2023-06-14 08:30:00', NULL, NULL, 18, 3, 8),
(9, 'Pizza Gourmet', 'Des pizzas raffinées aux saveurs uniques', 24.99, '2023-06-14 08:30:00', NULL, NULL, 13, NULL, 9),
(10, 'Soupe Variée', 'Un choix varié de soupes pour tous les goûts', 22.99, '2023-06-14 08:30:00', NULL, NULL, 18, NULL, 10);

-- --------------------------------------------------------

--
-- Structure de la table `menu_a_allergene`
--

DROP TABLE IF EXISTS `menu_a_allergene`;
CREATE TABLE IF NOT EXISTS `menu_a_allergene` (
  `menu_id_menu` int NOT NULL,
  `allergene_code` int NOT NULL,
  PRIMARY KEY (`menu_id_menu`,`allergene_code`),
  KEY `fk_menu_a_allergene_allergene1_idx` (`allergene_code`),
  KEY `fk_menu_a_allergene_menu1_idx` (`menu_id_menu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `menu_a_allergene`
--

INSERT INTO `menu_a_allergene` (`menu_id_menu`, `allergene_code`) VALUES
(2, 20),
(4, 24),
(6, 25),
(7, 30),
(8, 35),
(9, 40),
(10, 45),
(3, 74),
(1, 79),
(5, 168);

-- --------------------------------------------------------

--
-- Structure de la table `menu_a_produit`
--

DROP TABLE IF EXISTS `menu_a_produit`;
CREATE TABLE IF NOT EXISTS `menu_a_produit` (
  `menu_id_menu` int NOT NULL,
  `produit_id_produit` int NOT NULL,
  `quantitee` int DEFAULT NULL,
  PRIMARY KEY (`menu_id_menu`,`produit_id_produit`),
  KEY `fk_menu_a_produit_produit1_idx` (`produit_id_produit`),
  KEY `fk_menu_a_produit_menu1_idx` (`menu_id_menu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `menu_a_produit`
--

INSERT INTO `menu_a_produit` (`menu_id_menu`, `produit_id_produit`, `quantitee`) VALUES
(1, 5, 2),
(2, 4, 2),
(3, 5, 3),
(4, 3, 1),
(5, 5, 1),
(6, 6, 2),
(7, 7, 2),
(8, 8, 3),
(9, 9, 1),
(10, 10, 1);

-- --------------------------------------------------------

--
-- Structure de la table `moyen_paiement`
--

DROP TABLE IF EXISTS `moyen_paiement`;
CREATE TABLE IF NOT EXISTS `moyen_paiement` (
  `numero` varchar(16) NOT NULL,
  `cvv` int NOT NULL,
  `nom` varchar(45) NOT NULL,
  `date_expiration` varchar(10) NOT NULL,
  PRIMARY KEY (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `moyen_paiement`
--

INSERT INTO `moyen_paiement` (`numero`, `cvv`, `nom`, `date_expiration`) VALUES
('4533306646836717', 339, 'Felicita Nino', '12/2027'),
('4979654486941019', 644, 'Henry Inarkaevich', '11/2027'),
('5134121818067631', 730, 'Henryka Boumans', '09/2029'),
('5292921286155810', 534, 'Jesaja Koru', '05/2022'),
('5531748476711735', 180, 'Finlay Valdimarsson', '10/2025'),
('6011453098745632', 427, 'Marie Dupont', '06/2024'),
('6349781523698475', 918, 'Lefevre Thomas', '03/2026'),
('6498104576932415', 536, 'Martin Julie', '09/2023'),
('6751936402813547', 639, 'Luc Dubois', '08/2028'),
('6894127530965421', 214, 'Petit Emma', '07/2025');

-- --------------------------------------------------------

--
-- Structure de la table `paiement_autorise`
--

DROP TABLE IF EXISTS `paiement_autorise`;
CREATE TABLE IF NOT EXISTS `paiement_autorise` (
  `mode_paiement` varchar(255) NOT NULL,
  PRIMARY KEY (`mode_paiement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `paiement_autorise`
--

INSERT INTO `paiement_autorise` (`mode_paiement`) VALUES
('carte bancaire'),
('paypal');

-- --------------------------------------------------------

--
-- Structure de la table `paiement_autorise_a_restaurant`
--

DROP TABLE IF EXISTS `paiement_autorise_a_restaurant`;
CREATE TABLE IF NOT EXISTS `paiement_autorise_a_restaurant` (
  `paiement_autorise_mode_paiement` varchar(255) NOT NULL,
  `restaurant_id_restaurant` int NOT NULL,
  PRIMARY KEY (`paiement_autorise_mode_paiement`,`restaurant_id_restaurant`),
  KEY `fk_paiement_autorise_a_restaurant_restaurant1_idx` (`restaurant_id_restaurant`),
  KEY `fk_paiement_autorise_a_restaurant_paiement_autorise1_idx` (`paiement_autorise_mode_paiement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `paiement_autorise_a_restaurant`
--

INSERT INTO `paiement_autorise_a_restaurant` (`paiement_autorise_mode_paiement`, `restaurant_id_restaurant`) VALUES
('carte bancaire', 1),
('carte bancaire', 2),
('paypal', 3),
('carte bancaire', 4),
('paypal', 5),
('carte bancaire', 6),
('carte bancaire', 7),
('paypal', 8),
('carte bancaire', 9),
('paypal', 10);

-- --------------------------------------------------------

--
-- Structure de la table `produit`
--

DROP TABLE IF EXISTS `produit`;
CREATE TABLE IF NOT EXISTS `produit` (
  `id_produit` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) NOT NULL,
  `description` mediumtext NOT NULL,
  `prix` float NOT NULL,
  `promotion_id_promotion` int DEFAULT NULL,
  PRIMARY KEY (`id_produit`) USING BTREE,
  KEY `fk_produit_promotion_idx` (`promotion_id_promotion`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `produit`
--

INSERT INTO `produit` (`id_produit`, `nom`, `description`, `prix`, `promotion_id_promotion`) VALUES
(1, 'steakhouse', 'Le plaisir d\'une viande de bœuf grillée à la flamme, d\'une sauce barbecue, de bacon, des tranches de cheddar fondu et d\'oignons croustillants.', 7.4, NULL),
(2, 'triple cheese', 'Trois viandes de bœuf grillées à la flamme, des tranches de cheddar fondu, du ketchup, de la moutarde et deux rondelles de cornichons.', 8.45, NULL),
(3, 'fanta', 'boisson gazeuse', 3.99, NULL),
(4, 'burger au bacon', 'burger fumé au bacon', 7.99, NULL),
(5, 'soupe au miso', 'une soupe', 6.99, NULL),
(6, 'pizza margherita', 'Pizza classique avec sauce tomate, mozzarella et basilic.', 9.99, NULL),
(7, 'sushi assorti', 'Assortiment de sushi comprenant des nigiri, des maki et des sashimi.', 12.99, NULL),
(8, 'pâtes carbonara', 'Pâtes à la crème avec des lardons, du parmesan et du poivre.', 10.99, NULL),
(9, 'pad thai crevettes', 'Plat thaïlandais traditionnel à base de nouilles de riz sautées avec des crevettes, des légumes et des cacahuètes.', 11.99, NULL),
(10, 'salade César', 'Salade verte avec des croûtons, du poulet grillé, du parmesan et une sauce César.', 8.99, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `promotion`
--

DROP TABLE IF EXISTS `promotion`;
CREATE TABLE IF NOT EXISTS `promotion` (
  `id_promotion` int NOT NULL AUTO_INCREMENT,
  `pourcentage` int NOT NULL,
  `date_debut` timestamp NULL DEFAULT NULL,
  `date_fin` timestamp NULL DEFAULT NULL,
  `est_active` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_promotion`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `promotion`
--

INSERT INTO `promotion` (`id_promotion`, `pourcentage`, `date_debut`, `date_fin`, `est_active`) VALUES
(1, 20, '2022-06-09 04:54:06', '2022-07-14 04:54:06', 0),
(2, 30, '2023-06-07 04:54:06', '2023-06-30 04:54:06', 1),
(3, 5, '2023-06-01 04:57:31', '2023-06-15 04:57:31', 1),
(4, 10, '2022-05-12 04:57:31', '2022-06-16 04:57:31', 0),
(5, 15, '2023-07-01 04:57:31', '2023-07-15 04:57:31', 1),
(6, 12, '2023-07-16 04:57:31', '2023-07-31 04:57:31', 1),
(7, 8, '2023-08-01 04:57:31', '2023-08-15 04:57:31', 0),
(8, 10, '2023-08-16 04:57:31', '2023-08-31 04:57:31', 1),
(9, 5, '2023-09-01 04:57:31', '2023-09-15 04:57:31', 0),
(10, 20, '2023-09-16 04:57:31', '2023-09-30 04:57:31', 1);

-- --------------------------------------------------------

--
-- Structure de la table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
CREATE TABLE IF NOT EXISTS `restaurant` (
  `id_restaurant` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(60) NOT NULL,
  `telephone` varchar(10) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `rangee_prix` int NOT NULL,
  `url_photo` varchar(255) NOT NULL,
  `date_creation` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modification` timestamp NULL DEFAULT NULL,
  `date_suppression` timestamp NULL DEFAULT NULL,
  `est_actif` tinyint NOT NULL,
  `adresse_restaurant_rue` varchar(255) NOT NULL,
  `adresse_restaurant_ville` varchar(45) NOT NULL,
  `adresse_restaurant_code_postal` int NOT NULL,
  `type_restaurant_type` varchar(50) NOT NULL,
  PRIMARY KEY (`id_restaurant`) USING BTREE,
  KEY `fk_restaurant_adresse_restaurant1_idx` (`adresse_restaurant_rue`,`adresse_restaurant_ville`,`adresse_restaurant_code_postal`),
  KEY `fk_restaurant_type_restaurant1_idx` (`type_restaurant_type`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `restaurant`
--

INSERT INTO `restaurant` (`id_restaurant`, `nom`, `telephone`, `email`, `mot_de_passe`, `rangee_prix`, `url_photo`, `date_creation`, `date_modification`, `date_suppression`, `est_actif`, `adresse_restaurant_rue`, `adresse_restaurant_ville`, `adresse_restaurant_code_postal`, `type_restaurant_type`) VALUES
(1, 'Yak', '0654983215', 'yak.chinois@gmail.com', '35832ec3afd602fbc4d9cf8a3440e0a4', 2, 'src/media/yak/pic1.png', '2023-06-07 08:08:38', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, '40 rue de Groussay', 'Romainville', 93230, 'chinois'),
(2, 'Burger King', '0654983512', 'burger.king@gmail.com', '16f51062e14429f385948cb0a5798231', 1, 'src/media/bk/pic1.png', '2023-06-07 08:08:38', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, '31 Faubourg Saint Honoré', 'Paris', 75018, 'fast food'),
(3, 'Le Ciel de Rennes', '0654879345', 'le.ciel@hotmail.com', '1170f4d834d721d579614f3255ca1371', 3, 'src/media/leciel/pic1.png', '2023-06-07 08:10:32', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, '77 rue Ernest Renan', 'Chaumont', 52000, 'gastronomique'),
(4, 'Del Arte', '0659321565', 'del.arte@yahoo.fr', 'cac65db6ba43f2a0dacbb4fcc034f839', 1, 'src/media/delarte/pic1.png', '2023-06-07 08:15:25', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, '95 rue Lenotre', 'Rambouillet', 78120, 'italien'),
(5, 'Toasushi', '0698452365', 'toasushi@gmail.com', 'db30f3a55342783d483dbce4b0d66dff', 1, 'src/media/toasushi/pic1.png', '2023-06-07 08:15:25', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, '99 Place de la Gare', 'Colomiers', 31770, 'japonais'),
(6, 'La Bella Vita', '0625369874', 'labellavita@gmail.com', '7a53e8d77f1657052157d5e663f5e64a', 2, 'src/media/labellavita/pic1.png', '2023-06-14 06:30:00', NULL, NULL, 1, '10 rue de la République', 'Lyon', 69002, 'indien'),
(7, 'Sushilicious', '0712456897', 'sushilicious@hotmail.com', 'fa0f1a1f23b8f9067d2efadeb299f79d', 2, 'src/media/sushilicious/pic1.png', '2023-06-14 06:30:00', NULL, NULL, 1, '25 avenue Victor Hugo', 'Toulouse', 31100, 'mexicain'),
(8, 'Chez Pierre', '0665897412', 'chezpierre@gmail.com', '5b0e63ce60a44587286e41b8e9e3eb7e', 3, 'src/media/chezpierre/pic1.png', '2023-06-14 06:30:00', NULL, NULL, 1, '5 quai de la Douane', 'Bordeaux', 33000, 'français'),
(9, 'Pizzaville', '0756985234', 'pizzaville@yahoo.fr', '16c8d6c3fe65d8b5f0b2e3c1f4f3f9a6', 1, 'src/media/pizzaville/pic1.png', '2023-06-14 06:30:00', NULL, NULL, 1, '30 rue de Paris', 'Lille', 59000, 'végétarien'),
(10, 'Wok & Roll', '0698741258', 'wokandroll@gmail.com', '8a4892b8226e48733a0c1d17a09e4e0f', 2, 'src/media/wokandroll/pic1.png', '2023-06-14 06:30:00', NULL, NULL, 1, '15 boulevard Jean Jaurès', 'Nantes', 44000, 'grill');

-- --------------------------------------------------------

--
-- Structure de la table `restaurant_a_commande`
--

DROP TABLE IF EXISTS `restaurant_a_commande`;
CREATE TABLE IF NOT EXISTS `restaurant_a_commande` (
  `restaurant_id_restaurant` int NOT NULL,
  `commande_numero_commande` int NOT NULL,
  `accepte` tinyint NOT NULL,
  PRIMARY KEY (`restaurant_id_restaurant`,`commande_numero_commande`),
  KEY `fk_restaurant_a_commande_commande1_idx` (`commande_numero_commande`),
  KEY `fk_restaurant_a_commande_restaurant1_idx` (`restaurant_id_restaurant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `restaurant_a_commande`
--

INSERT INTO `restaurant_a_commande` (`restaurant_id_restaurant`, `commande_numero_commande`, `accepte`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 1);

-- --------------------------------------------------------

--
-- Structure de la table `statut`
--

DROP TABLE IF EXISTS `statut`;
CREATE TABLE IF NOT EXISTS `statut` (
  `type` varchar(30) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `statut`
--

INSERT INTO `statut` (`type`) VALUES
('annulé'),
('effectué'),
('en attente'),
('en cours'),
('retardé');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `top_clients_sur_burger_king`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `top_clients_sur_burger_king`;
CREATE TABLE IF NOT EXISTS `top_clients_sur_burger_king` (
`email` varchar(255)
,`id_client` int
,`nom` varchar(50)
,`nom_enseigne` varchar(60)
,`prenom` varchar(45)
,`total_commandes` bigint
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `top_livreurs_par_ville`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `top_livreurs_par_ville`;
CREATE TABLE IF NOT EXISTS `top_livreurs_par_ville` (
`email` varchar(255)
,`id_coursier` int
,`nom` varchar(50)
,`prenom` varchar(50)
,`telephone` varchar(10)
,`total_livraisons` bigint
,`ville` varchar(45)
);

-- --------------------------------------------------------

--
-- Structure de la table `type_restaurant`
--

DROP TABLE IF EXISTS `type_restaurant`;
CREATE TABLE IF NOT EXISTS `type_restaurant` (
  `type` varchar(50) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `type_restaurant`
--

INSERT INTO `type_restaurant` (`type`) VALUES
('chinois'),
('fast food'),
('français'),
('gastronomique'),
('grill'),
('indien'),
('italien'),
('japonais'),
('mexicain'),
('végétarien');

-- --------------------------------------------------------

--
-- Structure de la table `type_vehicule`
--

DROP TABLE IF EXISTS `type_vehicule`;
CREATE TABLE IF NOT EXISTS `type_vehicule` (
  `nom_type_vehicule` varchar(50) NOT NULL,
  PRIMARY KEY (`nom_type_vehicule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `type_vehicule`
--

INSERT INTO `type_vehicule` (`nom_type_vehicule`) VALUES
('moto'),
('trottinette'),
('velo'),
('voiture');

-- --------------------------------------------------------

--
-- Structure de la table `url_coursier`
--

DROP TABLE IF EXISTS `url_coursier`;
CREATE TABLE IF NOT EXISTS `url_coursier` (
  `id_url` int NOT NULL AUTO_INCREMENT,
  `url_coursier` varchar(255) NOT NULL,
  `coursier_id_coursier` int NOT NULL,
  PRIMARY KEY (`id_url`) USING BTREE,
  KEY `fk_url_coursier_coursier1_idx` (`coursier_id_coursier`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `url_coursier`
--

INSERT INTO `url_coursier` (`id_url`, `url_coursier`, `coursier_id_coursier`) VALUES
(1, 'src/media/coursier/pic.png', 1),
(2, 'src/media/coursier/pic2.png', 2),
(3, 'src/media/coursier/pic3.png', 3),
(4, 'src/media/coursier/pic4.png', 4),
(5, 'src/media/coursier/pic5.png', 5),
(6, 'src/media/coursier/pic6.png', 6),
(7, 'src/media/coursier/pic7.png', 7),
(8, 'src/media/coursier/pic8.png', 8),
(9, 'src/media/coursier/pic9.png', 9),
(10, 'src/media/coursier/pic10.png', 10);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vue_ca_restaurants_ville`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `vue_ca_restaurants_ville`;
CREATE TABLE IF NOT EXISTS `vue_ca_restaurants_ville` (
`adresse_restaurant_ville` varchar(45)
,`chiffre_affaires` double
,`nom_restaurant` varchar(60)
);

-- --------------------------------------------------------

--
-- Structure de la table `zone_geographique`
--

DROP TABLE IF EXISTS `zone_geographique`;
CREATE TABLE IF NOT EXISTS `zone_geographique` (
  `id_zone_geo` int NOT NULL AUTO_INCREMENT,
  `ville_zone` varchar(45) NOT NULL,
  `code_postal_zone` int NOT NULL,
  PRIMARY KEY (`id_zone_geo`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `zone_geographique`
--

INSERT INTO `zone_geographique` (`id_zone_geo`, `ville_zone`, `code_postal_zone`) VALUES
(1, 'Rennes', 35000),
(2, 'Paris', 75000),
(3, 'Cesson Sevigne', 35510),
(4, 'Saint Gregoire', 35760),
(5, 'Angers', 49000),
(6, 'Nantes', 44000),
(7, 'Lyon', 69000),
(8, 'Bordeaux', 33000),
(9, 'Toulouse', 31000),
(10, 'Marseille', 13000);

-- --------------------------------------------------------

--
-- Structure de la vue `top_clients_sur_burger_king`
--
DROP TABLE IF EXISTS `top_clients_sur_burger_king`;

DROP VIEW IF EXISTS `top_clients_sur_burger_king`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `top_clients_sur_burger_king`  AS SELECT `c`.`id_client` AS `id_client`, `c`.`nom` AS `nom`, `c`.`prenom` AS `prenom`, `c`.`email` AS `email`, count(0) AS `total_commandes`, `r`.`nom` AS `nom_enseigne` FROM (((`client` `c` join `commande` `cmd` on((`c`.`id_client` = `cmd`.`client_id_client`))) join `restaurant_a_commande` `rac` on((`cmd`.`numero_commande` = `rac`.`commande_numero_commande`))) join `restaurant` `r` on((`rac`.`restaurant_id_restaurant` = `r`.`id_restaurant`))) GROUP BY `c`.`id_client`, `c`.`nom`, `c`.`prenom`, `c`.`email`, `r`.`nom` HAVING (`r`.`nom` = 'Burger King') ORDER BY count(0) DESC  ;

-- --------------------------------------------------------

--
-- Structure de la vue `top_livreurs_par_ville`
--
DROP TABLE IF EXISTS `top_livreurs_par_ville`;

DROP VIEW IF EXISTS `top_livreurs_par_ville`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `top_livreurs_par_ville`  AS SELECT `c`.`id_coursier` AS `id_coursier`, `c`.`nom` AS `nom`, `c`.`prenom` AS `prenom`, `c`.`email` AS `email`, `c`.`telephone` AS `telephone`, count(distinct `cmd`.`numero_commande`) AS `total_livraisons`, `cr`.`ville` AS `ville` FROM ((`coursier` `c` join `commande` `cmd` on((`c`.`id_coursier` = `cmd`.`coursier_id_coursier`))) join `adresse_restaurant` `cr` on((`cmd`.`ville` = `cr`.`ville`))) GROUP BY `c`.`id_coursier`, `c`.`nom`, `c`.`prenom`, `c`.`email`, `c`.`telephone`, `cr`.`ville` ORDER BY `cr`.`ville` ASC, count(distinct `cmd`.`numero_commande`) DESC LIMIT 0, 1010101010101010  ;

-- --------------------------------------------------------

--
-- Structure de la vue `vue_ca_restaurants_ville`
--
DROP TABLE IF EXISTS `vue_ca_restaurants_ville`;

DROP VIEW IF EXISTS `vue_ca_restaurants_ville`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vue_ca_restaurants_ville`  AS SELECT `r`.`nom` AS `nom_restaurant`, sum(`c`.`prix`) AS `chiffre_affaires`, `r`.`adresse_restaurant_ville` AS `adresse_restaurant_ville` FROM ((`restaurant` `r` join `restaurant_a_commande` `rc` on((`r`.`id_restaurant` = `rc`.`restaurant_id_restaurant`))) join `commande` `c` on((`rc`.`commande_numero_commande` = `c`.`numero_commande`))) GROUP BY `r`.`nom`  ;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `avis_coursier`
--
ALTER TABLE `avis_coursier`
  ADD CONSTRAINT `fk_avis_coursier_commande1` FOREIGN KEY (`commande_numero_commande`) REFERENCES `commande` (`numero_commande`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_avis_coursier_coursier1` FOREIGN KEY (`coursier_id_coursier`) REFERENCES `coursier` (`id_coursier`);

--
-- Contraintes pour la table `avis_restaurant`
--
ALTER TABLE `avis_restaurant`
  ADD CONSTRAINT `fk_avis_restaurant_client1` FOREIGN KEY (`client_id_client`) REFERENCES `client` (`id_client`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_avis_restaurant_commande1` FOREIGN KEY (`commande_numero_commande`) REFERENCES `commande` (`numero_commande`),
  ADD CONSTRAINT `fk_avis_restaurant_restaurant1` FOREIGN KEY (`restaurant_id_restaurant`) REFERENCES `restaurant` (`id_restaurant`);

--
-- Contraintes pour la table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `fk_moyen_paiement` FOREIGN KEY (`moyen_paiement_numero`) REFERENCES `moyen_paiement` (`numero`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Contraintes pour la table `client_a_adresse_client`
--
ALTER TABLE `client_a_adresse_client`
  ADD CONSTRAINT `fk_client_a_adresse_client_adresse_client1` FOREIGN KEY (`adresse_client_id_adresse_client`) REFERENCES `adresse_client` (`id_adresse_client`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_client_a_adresse_client_client1` FOREIGN KEY (`client_id_client`) REFERENCES `client` (`id_client`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `commande`
--
ALTER TABLE `commande`
  ADD CONSTRAINT `fk_commande_coursier2` FOREIGN KEY (`coursier_id_coursier`) REFERENCES `coursier` (`id_coursier`),
  ADD CONSTRAINT `fk_commande_statut1` FOREIGN KEY (`statut_type`) REFERENCES `statut` (`type`);

--
-- Contraintes pour la table `commande_a_menu`
--
ALTER TABLE `commande_a_menu`
  ADD CONSTRAINT `fk_menu_a_commande_commande1` FOREIGN KEY (`commande_numero_commande`) REFERENCES `commande` (`numero_commande`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `contact_de_reference`
--
ALTER TABLE `contact_de_reference`
  ADD CONSTRAINT `fk_contact_de_reference_restaurant1` FOREIGN KEY (`restaurant_id_restaurant`) REFERENCES `restaurant` (`id_restaurant`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `coursier`
--
ALTER TABLE `coursier`
  ADD CONSTRAINT `fk_coursier_type_vehicule1` FOREIGN KEY (`type_vehicule_nom_type_vehicule`) REFERENCES `type_vehicule` (`nom_type_vehicule`);

--
-- Contraintes pour la table `coursier_a_zone_geographique`
--
ALTER TABLE `coursier_a_zone_geographique`
  ADD CONSTRAINT `fk_coursier_a_zone_geographique_coursier1` FOREIGN KEY (`coursier_id_coursier`) REFERENCES `coursier` (`id_coursier`),
  ADD CONSTRAINT `fk_coursier_a_zone_geographique_zone_geographique1` FOREIGN KEY (`zone_geographique_id_adresse_coursier`) REFERENCES `zone_geographique` (`id_zone_geo`);

--
-- Contraintes pour la table `facture`
--
ALTER TABLE `facture`
  ADD CONSTRAINT `fk_facture_commande1` FOREIGN KEY (`commande_numero_commande`) REFERENCES `commande` (`numero_commande`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `favoris`
--
ALTER TABLE `favoris`
  ADD CONSTRAINT `fk_favoris_client1` FOREIGN KEY (`client_id_client`) REFERENCES `client` (`id_client`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_favoris_restaurant1` FOREIGN KEY (`restaurant_id_restaurant`) REFERENCES `restaurant` (`id_restaurant`),
  ADD CONSTRAINT `fk_menu_id` FOREIGN KEY (`menu_id_menu`) REFERENCES `menu` (`id_menu`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Contraintes pour la table `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `fk_menu_media` FOREIGN KEY (`media_id_media`) REFERENCES `media` (`id_media`),
  ADD CONSTRAINT `fk_menu_promotion` FOREIGN KEY (`promotion_id_promotion`) REFERENCES `promotion` (`id_promotion`),
  ADD CONSTRAINT `fk_menu_restaurant` FOREIGN KEY (`restaurant_id_restaurant`) REFERENCES `restaurant` (`id_restaurant`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `menu_a_allergene`
--
ALTER TABLE `menu_a_allergene`
  ADD CONSTRAINT `fk_menu_a_allergene_allergene1` FOREIGN KEY (`allergene_code`) REFERENCES `allergene` (`code`),
  ADD CONSTRAINT `fk_menu_a_allergene_menu1` FOREIGN KEY (`menu_id_menu`) REFERENCES `menu` (`id_menu`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `menu_a_produit`
--
ALTER TABLE `menu_a_produit`
  ADD CONSTRAINT `fk_menu_a_produit_menu1` FOREIGN KEY (`menu_id_menu`) REFERENCES `menu` (`id_menu`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_menu_a_produit_produit1` FOREIGN KEY (`produit_id_produit`) REFERENCES `produit` (`id_produit`);

--
-- Contraintes pour la table `paiement_autorise_a_restaurant`
--
ALTER TABLE `paiement_autorise_a_restaurant`
  ADD CONSTRAINT `fk_paiement_autorise_a_restaurant_paiement_autorise1` FOREIGN KEY (`paiement_autorise_mode_paiement`) REFERENCES `paiement_autorise` (`mode_paiement`),
  ADD CONSTRAINT `fk_paiement_autorise_a_restaurant_restaurant1` FOREIGN KEY (`restaurant_id_restaurant`) REFERENCES `restaurant` (`id_restaurant`);

--
-- Contraintes pour la table `produit`
--
ALTER TABLE `produit`
  ADD CONSTRAINT `fk_produit_promotion1` FOREIGN KEY (`promotion_id_promotion`) REFERENCES `promotion` (`id_promotion`);

--
-- Contraintes pour la table `restaurant`
--
ALTER TABLE `restaurant`
  ADD CONSTRAINT `fk_restaurant_adresse_restaurant1` FOREIGN KEY (`adresse_restaurant_rue`,`adresse_restaurant_ville`,`adresse_restaurant_code_postal`) REFERENCES `adresse_restaurant` (`rue`, `ville`, `code_postal`),
  ADD CONSTRAINT `fk_restaurant_type_restaurant1` FOREIGN KEY (`type_restaurant_type`) REFERENCES `type_restaurant` (`type`);

--
-- Contraintes pour la table `restaurant_a_commande`
--
ALTER TABLE `restaurant_a_commande`
  ADD CONSTRAINT `fk_restaurant_a_commande_commande1` FOREIGN KEY (`commande_numero_commande`) REFERENCES `commande` (`numero_commande`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_restaurant_a_commande_restaurant1` FOREIGN KEY (`restaurant_id_restaurant`) REFERENCES `restaurant` (`id_restaurant`);

--
-- Contraintes pour la table `url_coursier`
--
ALTER TABLE `url_coursier`
  ADD CONSTRAINT `fk_url_coursier_coursier1` FOREIGN KEY (`coursier_id_coursier`) REFERENCES `coursier` (`id_coursier`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
