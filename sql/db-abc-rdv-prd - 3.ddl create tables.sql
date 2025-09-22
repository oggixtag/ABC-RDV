-- Ce script permet de créer les tables d'une base de données MariaDB pour le projet ABC-RDV.
-- Le script est conçu pour être exécuté dans un environnement de production, abc_rdv_prd_db.
-- Il crée les tables nécessaires pour gérer les professionnels et ses équipes, les clients, les services, les réservations et les avis, avec les contraintes et les clés étrangères appropriées.
-- Il est important de noter que ce script ne gère pas la création de la base de données elle-même, ni les utilisateurs et leurs permissions.
-- Il faut l'exécuter avec l'utilisateur ayant les droits de création de tables, root ou abc_rdv_prd_useradm.

-- Création de la table 'villes'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.villes (
	ville_id INT AUTO_INCREMENT PRIMARY KEY,
	nom_ville VARCHAR(255) NOT NULL UNIQUE
);

-- Création de la table 'professionnels'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.professionnels (
	professionnel_id INT AUTO_INCREMENT PRIMARY KEY,
	nom VARCHAR(255) NOT NULL,
	adresse VARCHAR(255) NOT NULL,
	telephone VARCHAR(20),
	email VARCHAR(255) NOT NULL UNIQUE,
	notes TEXT,
	ville_id INT NOT NULL,
	FOREIGN KEY (ville_id) REFERENCES abc_rdv_prd_db.villes(ville_id)
);

-- Création de la table 'membres_equipe' pour gérer l'équipe du professionnel
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.membres_equipe (
	membre_id INT AUTO_INCREMENT PRIMARY KEY,
	nom_membre VARCHAR(255) NOT NULL,
	professionnel_id INT NOT NULL,
	FOREIGN KEY (professionnel_id) REFERENCES abc_rdv_prd_db.professionnels(professionnel_id)
);

-- Création de la table 'services'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.services (
	service_id INT AUTO_INCREMENT PRIMARY KEY,
	nom_service VARCHAR(255) NOT NULL,
	description TEXT
);

-- Création de la table 'professionnel_services' (table de liaison)
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.professionnel_services (
	professionnel_id INT NOT NULL,
	service_id INT NOT NULL,
	prix DECIMAL(10, 2),
	duree INT,
	PRIMARY KEY (professionnel_id, service_id),
	FOREIGN KEY (professionnel_id) REFERENCES abc_rdv_prd_db.professionnels(professionnel_id),
	FOREIGN KEY (service_id) REFERENCES abc_rdv_prd_db.services(service_id)
);

-- Création de la table 'agendas' pour gérer les créneaux horaires
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.agendas (
	agenda_id INT PRIMARY KEY AUTO_INCREMENT,
	membre_id INT NOT NULL,
	date DATE NOT NULL,
	heure_08h TINYINT(1) DEFAULT 0,
	heure_09h TINYINT(1) DEFAULT 0,
	heure_10h TINYINT(1) DEFAULT 0,
	heure_11h TINYINT(1) DEFAULT 0,
	heure_12h TINYINT(1) DEFAULT 0,
	heure_13h TINYINT(1) DEFAULT 0,
	heure_14h TINYINT(1) DEFAULT 0,
	heure_15h TINYINT(1) DEFAULT 0,
	heure_16h TINYINT(1) DEFAULT 0,
	heure_17h TINYINT(1) DEFAULT 0,
	heure_18h TINYINT(1) DEFAULT 0,
	FOREIGN KEY (membre_id) REFERENCES abc_rdv_prd_db.membres_equipe(membre_id)
);

-- Création de la table 'clients'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.clients (
	client_id INT AUTO_INCREMENT PRIMARY KEY,
	nom VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE
);

-- Création de la table 'reservations'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.reservations (
	reservation_id INT AUTO_INCREMENT PRIMARY KEY,
	client_id INT NOT NULL,
	professionnel_id INT NOT NULL,
	membre_id INT NOT NULL,
	service_id INT NOT NULL,
	agenda_id INT NOT NULL,
	date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (client_id) REFERENCES abc_rdv_prd_db.clients(client_id),
	FOREIGN KEY (professionnel_id) REFERENCES abc_rdv_prd_db.professionnels(professionnel_id),
	FOREIGN KEY (membre_id) REFERENCES abc_rdv_prd_db.membres_equipe(membre_id),
	FOREIGN KEY (service_id) REFERENCES abc_rdv_prd_db.services(service_id),
	FOREIGN KEY (agenda_id) REFERENCES abc_rdv_prd_db.agendas(agenda_id)
);

-- Création de la table 'avis'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.avis (
	avis_id INT AUTO_INCREMENT PRIMARY KEY,
	note INT,
	commentaire TEXT,
	client_id INT NOT NULL,
	professionnel_id INT NOT NULL,
	FOREIGN KEY (client_id) REFERENCES abc_rdv_prd_db.clients(client_id),
	FOREIGN KEY (professionnel_id) REFERENCES abc_rdv_prd_db.professionnels(professionnel_id)
);