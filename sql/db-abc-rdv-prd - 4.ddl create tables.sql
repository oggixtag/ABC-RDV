/*
Executer ce script autant que abc_rdv_prd_db-useradm.
Ce script permet de créer les tables d'une base de données MariaDB pour le projet ABC-RDV.
Le script est conçu pour être exécuté dans un environnement de production, abc_rdv_prd_db.
Il crée les tables nécessaires pour gérer les professionnels, les clients, les services, les réservations et les avis plus avec les contraintes et les clés étrangères appropriées.
Il est important de noter que ce script ne gère pas la création de la base de données elle-même, ni les utilisateurs et leurs permissions.
Il faut executer le script avec l'utilisateur ayant les droits de création de tables.
*/


-- Création de la table 'Villes'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.villes (
    ville_id INT AUTO_INCREMENT PRIMARY KEY,
    nom_ville VARCHAR(255) NOT NULL UNIQUE
);

-- Création de la table 'professionnels' avec une clé étrangère vers 'Villes'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.professionnels (
    professionnel_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    telephone VARCHAR(20),
    email VARCHAR(255) NOT NULL UNIQUE,
    agenda JSON,
    notes TEXT,
    ville_id INT NOT NULL,
    FOREIGN KEY (ville_id) REFERENCES abc_rdv_prd_db.villes(ville_id)
);

-- Création de la table 'services'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    nom_service VARCHAR(255) NOT NULL,
    description TEXT
);

-- Création de la table 'professionnel_services' pour gérer la relation plusieurs-à-plusieurs entre 'Professionnels' et 'Services'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.professionnel_services (
    professionnel_id INT NOT NULL,
    service_id INT NOT NULL,
    prix DECIMAL(10, 2),
    duree INT,
    PRIMARY KEY (professionnel_id, service_id),
    FOREIGN KEY (professionnel_id) REFERENCES abc_rdv_prd_db.professionnels(professionnel_id),
    FOREIGN KEY (service_id) REFERENCES abc_rdv_prd_db.services(service_id)
);

-- Création de la table 'Clients'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

-- Création de la table 'Reservations'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    date_reservation DATE NOT NULL,
    heure_reservation TIME NOT NULL,
    client_id INT NOT NULL,
    professionnel_id INT NOT NULL,
    service_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES abc_rdv_prd_db.clients(client_id),
    FOREIGN KEY (professionnel_id) REFERENCES abc_rdv_prd_db.professionnels(professionnel_id),
    FOREIGN KEY (service_id) REFERENCES abc_rdv_prd_db.services(service_id)
);

-- Création de la table 'Avis'
CREATE TABLE IF NOT EXISTS abc_rdv_prd_db.avis (
    avis_id INT AUTO_INCREMENT PRIMARY KEY,
    note INT,
    commentaire TEXT,
    client_id INT NOT NULL,
    professionnel_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES abc_rdv_prd_db.clients(client_id),
    FOREIGN KEY (professionnel_id) REFERENCES abc_rdv_prd_db.professionnels(professionnel_id)
);
