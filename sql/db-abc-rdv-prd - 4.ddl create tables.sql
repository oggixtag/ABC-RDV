/*
Executer ce script autant que db-abc-rdv-prd-useradm.
Ce script permet de créer les tables d'une base de données MariaDB pour le projet ABC-RDV.
Le script est conçu pour être exécuté dans un environnement de production, db-abc-rdv-prd.
Il crée les tables nécessaires pour gérer les professionnels, les clients, les services, les réservations et les avis plus avec les contraintes et les clés étrangères appropriées.
Il est important de noter que ce script ne gère pas la création de la base de données elle-même, ni les utilisateurs et leurs permissions.
Il faut executer le script avec l'utilisateur ayant les droits de création de tables.
*/


-- Création de la table 'Villes'
CREATE TABLE IF NOT EXISTS db-abc-rdv-prd.Villes (
    ville_id INT AUTO_INCREMENT PRIMARY KEY,
    nom_ville VARCHAR(255) NOT NULL UNIQUE
);

-- Création de la table 'Professionnels' avec une clé étrangère vers 'Villes'
CREATE TABLE IF NOT EXISTS db-abc-rdv-prd.Professionnels (
    professionnel_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    services JSON,
    prix DECIMAL(10, 2),
    agenda JSON,
    notes TEXT,
    ville_id INT NOT NULL,
    FOREIGN KEY (ville_id) REFERENCES db-abc-rdv-prd.Villes(ville_id)
);

-- Création de la table 'Services'
CREATE TABLE IF NOT EXISTS db-abc-rdv-prd.Services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    nom_service VARCHAR(255) NOT NULL,
    description TEXT,
    prix DECIMAL(10, 2),
    duree INT
);

-- Création de la table 'Clients'
CREATE TABLE IF NOT EXISTS db-abc-rdv-prd.Clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    historique_reservations JSON
);

-- Création de la table 'Reservations'
CREATE TABLE IF NOT EXISTS db-abc-rdv-prd.Reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    date_reservation DATE NOT NULL,
    heure_reservation TIME NOT NULL,
    client_id INT NOT NULL,
    professionnel_id INT NOT NULL,
    service_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES db-abc-rdv-prd.Clients(client_id),
    FOREIGN KEY (professionnel_id) REFERENCES db-abc-rdv-prd.Professionnels(professionnel_id),
    FOREIGN KEY (service_id) REFERENCES db-abc-rdv-prd.Services(service_id)
);

-- Création de la table 'Avis'
CREATE TABLE IF NOT EXISTS db-abc-rdv-prd.Avis (
    avis_id INT AUTO_INCREMENT PRIMARY KEY,
    note INT,
    commentaire TEXT,
    client_id INT NOT NULL,
    professionnel_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES db-abc-rdv-prd.Clients(client_id),
    FOREIGN KEY (professionnel_id) REFERENCES db-abc-rdv-prd.Professionnels(professionnel_id)
);
