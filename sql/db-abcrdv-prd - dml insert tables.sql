/*
Ce script permet d'insérer des données d'exemple dans les tables d'une base de données MariaDB pour le projet ABC-RDV. 
Le script est conçu pour être exécuté dans un environnement de production, abcrdv_prd_db.
Il insère des données dans les tables villes, clients, professionnels, membres_equipe, services et reservations.
Il est important de noter que ce script suppose que les tables existent déjà et qu'elles sont vides avant l'insertion des données.
Il faut executer le script avec l'utilisateur ayant les droits d'insertion sur les tables.
Executer ce script autant que abc_rdv_prd_useradm ou abc_rdv_prd_userapf.
*/

/*
Ce script ne contient pas COMMIT final !
*/

USE abcrdv_prd_db;

-- 1. Insertion dans la table 'Villes'
INSERT INTO villes (nom_ville) VALUES
('Paris'), ('Lyon'), ('Marseille'), ('Bordeaux'), ('Toulouse'),
('Nice'), ('Nantes'), ('Strasbourg'), ('Lille'), ('Rennes'),
('Montpellier'), ('Grenoble'), ('Rouen'), ('Reims'), ('Tours'),
('Aix-en-Provence'), ('Limoges'), ('Dijon'), ('Le Havre'), ('Saint-Étienne');

-- 2. Insertion dans la table 'professionnels'
INSERT INTO professionnels (nom, adresse, telephone, email, notes, ville_id) VALUES
('Salon de la Beauté', '12 Rue de Rivoli', '0123456789', 'salon-beaute@email.fr', 'Spécialiste en coiffure et soins', (SELECT ville_id FROM villes WHERE nom_ville = 'Paris')),
('Coupe Parfaite', '25 Avenue des Champs-Élysées', '0123456790', 'coupe-parfaite@email.fr', 'Salon de coiffure moderne', (SELECT ville_id FROM villes WHERE nom_ville = 'Paris')),
('Le Barbier Élégant', '8 Rue du Faubourg Saint-Honoré', '0123456791', 'barbier-elegant@email.fr', 'Barbier et soins de la barbe', (SELECT ville_id FROM villes WHERE nom_ville = 'Paris')),
('Maison de la Coiffure', '50 Rue du Président Edouard Herriot', '0412345678', 'maison-coiffure@email.fr', 'Salon de luxe à Lyon', (SELECT ville_id FROM villes WHERE nom_ville = 'Lyon')),
('Style & Chic', '15 Rue de la République', '0412345679', 'style-chic@email.fr', 'Expertise en coloration', (SELECT ville_id FROM villes WHERE nom_ville = 'Marseille')),
('L\'Artisan Coiffeur', '33 Rue Sainte-Catherine', '0545678901', 'artisan-coiffeur@email.fr', 'Coupes classiques et modernes', (SELECT ville_id FROM villes WHERE nom_ville = 'Bordeaux')),
('Atelier Beauté', '42 Allée Jean Jaurès', '0545678902', 'atelier-beaute@email.fr', 'Espace de bien-être et beauté', (SELECT ville_id FROM villes WHERE nom_ville = 'Toulouse')),
('Le Balayage Doré', '8 Rue de France', '0456789012', 'balayage-dore@email.fr', 'Spécialiste du balayage', (SELECT ville_id FROM villes WHERE nom_ville = 'Nice')),
('Tendance Coiffure', '1 Place du Commerce', '0234567890', 'tendance-coiffure@email.fr', 'À la pointe des tendances', (SELECT ville_id FROM villes WHERE nom_ville = 'Nantes')),
('La Coupe Urbaine', '10 Rue des Grandes Arcades', '0345678901', 'coupe-urbaine@email.fr', 'Coiffure mixte et stylisme', (SELECT ville_id FROM villes WHERE nom_ville = 'Strasbourg')),
('Coiffure & Compagnie', '20 Rue Esquermoise', '0345678902', 'coiffure-cie@email.fr', 'Salon familial', (SELECT ville_id FROM villes WHERE nom_ville = 'Lille')),
('L\'Étoile de la Beauté', '30 Rue d\'Antrain', '0234567891', 'etoile-beaute@email.fr', 'Services complets de beauté', (SELECT ville_id FROM villes WHERE nom_ville = 'Rennes')),
('Le Coiffeur du Sud', '5 Rue de la Loge', '0456789013', 'coiffeur-sud@email.fr', 'Atmosphère détendue', (SELECT ville_id FROM villes WHERE nom_ville = 'Montpellier')),
('Le Pinceau Magique', '22 Rue des Clercs', '0456789014', 'pinceau-magique@email.fr', 'Maquillage et coiffure de soirée', (SELECT ville_id FROM villes WHERE nom_ville = 'Grenoble')),
('Salon Créatif', '7 Rue du Gros Horloge', '0234567892', 'salon-creatif@email.fr', 'Coupe et couleur personnalisées', (SELECT ville_id FROM villes WHERE nom_ville = 'Rouen')),
('Harmonie Capillaire', '14 Place Drouet d\'Erlon', '0345678903', 'harmonie-capillaire@email.fr', 'Soins capillaires profonds', (SELECT ville_id FROM villes WHERE nom_ville = 'Reims')),
('Art et Cheveux', '36 Rue Nationale', '0234567893', 'art-et-cheveux@email.fr', 'Salon d\'artiste', (SELECT ville_id FROM villes WHERE nom_ville = 'Tours')),
('L\'Instant Parfait', '2 Rue du 4 Septembre', '0456789015', 'instant-parfait@email.fr', 'Coiffure de mariage', (SELECT ville_id FROM villes WHERE nom_ville = 'Aix-en-Provence')),
('Le Salon du Port', '18 Quai Notre Dame', '0234567894', 'salon-port@email.fr', 'Spécialiste des cheveux courts', (SELECT ville_id FROM villes WHERE nom_ville = 'Le Havre')),
('Beauté Moderne', '1 Place du Peuple', '0456789016', 'beaute-moderne@email.fr', 'Coupe et style pour hommes', (SELECT ville_id FROM villes WHERE nom_ville = 'Saint-Étienne'));

-- 3. Insertion dans la table 'membres_equipe'
INSERT INTO membres_equipe (nom_membre, professionnel_id) VALUES
('Julie Dupont', 1), 
('Marc Lefevre', 1), 
('Sophie Bernard', 1), 
('David Martin', 2), 
('Emilie Durand', 2);
/*('Pierre Dubois', 3), 
('Laura Petit', 3),
('Alexandre Rousseau', 4),
('Caroline Blanc', 5),
('Nicolas Lambert', 6),
('Marie Leroy', 7),
('Thomas Moreau', 8),
('Clara Fournier', 9),
('Lucas Girard', 10),
('Amélie Bonnet', 11),
('Fabien Garcia', 12),
('Chloé Roux', 13),
('Vincent Chen', 14),
('Manon Lopez', 15),
('Hugo Sanchez', 16);*/

-- 4. Insertion dans la table 'services'
INSERT INTO services (nom_service, description) VALUES
('Coupe homme', 'Coupe et coiffage pour homme'), ('Coupe femme', 'Coupe et coiffage pour femme'),
('Coloration', 'Application d\'une coloration complète'), ('Mèches', 'Création de mèches lumineuses'),
('Balayage', 'Technique d\'éclaircissement naturelle'), ('Soin Kératine', 'Soin profond à la kératine'),
('Barbe', 'Taille et entretien de la barbe'), ('Coiffure de soirée', 'Coiffure élégante pour événements'),
('Lissage brésilien', 'Lissage durable et soin intense'), ('Extensions de cheveux', 'Ajout de volume et longueur'),
('Brushing', 'Mise en forme des cheveux au sèche-cheveux'), ('Ombré hair', 'Effet dégradé de couleur'),
('Défrisage', 'Traitement pour défriser les cheveux'), ('Soin Hydratant', 'Masque hydratant pour cheveux secs'),
('Shampoing', 'Nettoyage professionnel des cheveux'), ('Soins du cuir chevelu', 'Traitements spécifiques'),
('Coiffure enfant', 'Coupe de cheveux pour enfant'), ('Permanente', 'Boucles et ondulations durables'),
('Tresse africaine', 'Réalisation de tresses'), ('Chignon', 'Coiffure élaborée pour occasions');

-- 5. Insertion dans la table 'professionnel_services'
INSERT INTO professionnel_services (professionnel_id, service_id, prix, duree) VALUES
(1, 1, 35.00, 30), (1, 2, 50.00, 45), (1, 3, 70.00, 90), (1, 4, 90.00, 120),
(2, 2, 55.00, 60), (2, 5, 110.00, 150), (2, 6, 80.00, 60), (2, 7, 25.00, 30),
(3, 1, 30.00, 30), (3, 7, 20.00, 20), (3, 8, 85.00, 90), (4, 2, 60.00, 60),
(4, 3, 80.00, 90), (5, 3, 75.00, 90), (5, 4, 95.00, 120), (6, 1, 40.00, 45),
(6, 2, 55.00, 60), (7, 5, 120.00, 150), (8, 5, 130.00, 160), (9, 2, 50.00, 60);

-- 6. Insertion dans la table 'clients'
INSERT INTO clients (nom, email) VALUES
('Jean Martin', 'jean.martin@email.fr'), ('Marie Dubois', 'marie.dubois@email.fr'),
('Pierre Laurent', 'pierre.laurent@email.fr'), ('Sophie Moreau', 'sophie.moreau@email.fr'),
('Lucie Garcia', 'lucie.garcia@email.fr'), ('Antoine Petit', 'antoine.petit@email.fr'),
('Isabelle Bernard', 'isabelle.bernard@email.fr'), ('Thomas Lefevre', 'thomas.lefevre@email.fr'),
('Chloé Robert', 'chloe.robert@email.fr'), ('Nicolas Richard', 'nicolas.richard@email.fr'),
('Émilie Duval', 'emilie.duval@email.fr'), ('Julien Michel', 'julien.michel@email.fr'),
('Camille Dupont', 'camille.dupont@email.fr'), ('Léo Girard', 'leo.girard@email.fr'),
('Manon Lefort', 'manon.lefort@email.fr'), ('Hugo Boyer', 'hugo.boyer@email.fr'),
('Sarah Vincent', 'sarah.vincent@email.fr'), ('Arthur Roussel', 'arthur.roussel@email.fr'),
('Emma Faure', 'emma.faure@email.fr'), ('Gabriel Marchand', 'gabriel.marchand@email.fr');

-- 7. Insertion dans la table 'agendas'
-- Disponibilités pour différents membres de l'équipe sur des jours spécifiques. (0 = disponible, 1 = réservé)
INSERT INTO agendas (membre_id, date, heure_08h, heure_09h, heure_10h, heure_11h, heure_12h, heure_13h, heure_14h, heure_15h, heure_16h, heure_17h, heure_18h) VALUES
(1, '2025-09-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-09-23', 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-09-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-09-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-09-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-09-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-09-30', 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-07', 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1), -- Julie Dupont
(1, '2025-10-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-15', 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1), -- Julie Dupont
(1, '2025-10-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-10-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-11-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2025-12-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-01-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-02-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(1, '2026-03-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Julie Dupont
(2, '2025-09-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-09-23', 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-09-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-09-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-09-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-09-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-09-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-01', 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-08', 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-10', 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-10-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-11-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2025-12-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-01-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-02-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(2, '2026-03-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Marc Lefevre
(3, '2025-09-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-09-23', 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-09-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-09-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-09-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-09-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-09-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-06', 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-09', 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-10-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-11-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2025-12-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-01-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-02-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(3, '2026-03-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Sophie Bernard
(4, '2025-09-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-09-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-09-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-09-25', 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-09-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1), -- David Martin
(4, '2025-09-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-09-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-03', 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-09', 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-13', 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-10-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-11-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2025-12-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-01-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-02-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(4, '2026-03-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- David Martin
(5, '2025-09-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-09-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-09-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-09-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-09-26', 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-09-29', 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-09-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-10', 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-14', 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1), -- Emilie Durand
(5, '2025-10-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-10-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-11-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2025-12-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-01', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-07', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-08', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-14', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-15', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-22', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-28', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-29', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-01-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-02-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-02', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-03', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-04', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-05', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-06', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-09', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-10', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-11', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-12', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-13', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-16', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-17', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-18', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-19', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-20', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-23', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-24', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-25', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-26', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-27', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-30', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), -- Emilie Durand
(5, '2026-03-31', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1); -- Emilie Durand

-- 8. Insertion dans la table 'reservations'
INSERT INTO reservations (client_id, professionnel_id, membre_id, service_id, agenda_id) VALUES
(10, 1, 1, 2, 2 ),  -- Nicolas Richard;Salon de la Beauté,Julie Dupont,Coupe femme,2025-09-23
(16, 1, 1, 4, 7 ),  -- Hugo Boyer;Salon de la Beauté,Julie Dupont,Mèches,2025-09-30
(10, 1, 1, 2, 12),  -- Nicolas Richard;Salon de la Beauté,Julie Dupont,Coupe femme,2025-10-07
(16, 1, 1, 4, 15),  -- Hugo Boyer;Salon de la Beauté,Julie Dupont,Mèches,2025-10-10
(16, 1, 1, 4, 18),  -- Hugo Boyer;Salon de la Beauté,Julie Dupont,Mèches,2025-10-15
(11, 1, 2, 1, 139 ),  -- Émilie Duval;Salon de la Beauté,Marc Lefevre,Coupe homme,2025-09-23
(17, 1, 2, 3, 139 ),  -- Sarah Vincent;Salon de la Beauté,Marc Lefevre,Coloration,2025-09-23
(17, 1, 2, 3, 145 ),  -- Sarah Vincent;Salon de la Beauté,Marc Lefevre,Coloration,2025-10-01
(11, 1, 2, 1, 150),  -- Émilie Duval;Salon de la Beauté,Marc Lefevre,Coupe homme,2025-10-08
(17, 1, 2, 3, 152 ), -- Sarah Vincent;Salon de la Beauté,Marc Lefevre,Coloration,2025-10-10
(12, 1, 3, 3, 276 ),  -- Julien Michel;Salon de la Beauté,Sophie Bernard,Coloration,2025-09-24
(20, 1, 3, 1, 285),  -- Gabriel Marchand;Salon de la Beauté,Sophie Bernard,Coupe homme,2025-10-06
(12, 1, 3, 3, 288),  -- Julien Michel;Salon de la Beauté,Sophie Bernard,Coloration,2025-10-09
(13, 2, 4, 5, 415 ),  -- Camille Dupont;Coupe Parfaite,David Martin,Balayage,2025-09-25
(14, 2, 4, 6, 416 ),  -- Léo Girard;Coupe Parfaite,David Martin,Soin Kératine,2025-09-26
(19, 2, 4, 2, 421),  -- Emma Faure;Coupe Parfaite,David Martin,Coupe femme,2025-10-03
(13, 2, 4, 5, 425),  -- Camille Dupont;Coupe Parfaite,David Martin,Balayage,2025-10-09
(14, 2, 4, 6, 427),  -- Léo Girard;Coupe Parfaite,David Martin,Soin Kératine,2025-10-13
(18, 2, 5, 6, 553 ), -- Arthur Roussel;Coupe Parfaite,Emilie Durand,Soin Kératine,2025-09-26
(15, 2, 5, 7, 554 ),  -- Manon Lefort;Coupe Parfaite,Emilie Durand,Barbe,2025-09-29
(18, 2, 5, 5, 563 ),  -- Arthur Roussel;Coupe Parfaite,Emilie Durand,Balayage,2025-10-10
(15, 2, 5, 7, 565);  -- Manon Lefort;Coupe Parfaite,Emilie Durand,Barbe,2025-10-14

-- 9. Insertion dans la table 'avis'
INSERT INTO avis (note, commentaire, client_id, professionnel_id) VALUES
(5, 'Excellent service, je suis très satisfait.', 1, 1), (4, 'Bonne coupe, rapide et efficace.', 2, 2),
(5, 'Le barbier est très professionnel.', 3, 3), (3, 'Salon agréable, mais un peu d\'attente.', 4, 4),
(5, 'Ma couleur est parfaite, merci !', 5, 5), (4, 'Bonne ambiance, personnel sympathique.', 6, 6),
(5, 'Un vrai artiste, j\'adore ma nouvelle coupe.', 7, 7), (5, 'Le résultat est incroyable, je recommande.', 8, 8),
(4, 'Très bon rapport qualité-prix.', 9, 9), (3, 'J\'attendais un résultat plus original.', 10, 10),
(5, 'Salon très propre et accueillant.', 11, 11), (5, 'Meilleur service que j\'ai jamais eu.', 12, 12),
(4, 'Une belle découverte, je reviendrai.', 13, 13), (5, 'Le coiffeur a parfaitement compris mes attentes.', 14, 14),
(4, 'Un peu cher, mais la qualité est là.', 15, 15), (5, 'Très bon coiffeur pour homme.', 16, 16),
(5, 'Super soin, mes cheveux revivent !', 17, 1), (4, 'Bonne ambiance et coiffeur à l\'écoute.', 18, 2),
(5, 'Le meilleur salon de la ville !', 19, 3), (4, 'Je suis très content du résultat.', 20, 4);
