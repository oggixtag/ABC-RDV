/*
Ce fichier ne doit pas être exécuté. Il contient des requêtes SQL pour interagir avec la base de données du projet ABC-RDV.
Il est destiné à être utilisé comme référence pour les développeurs et les administrateurs de la base de données.
Exploitation données dans l'environnement de production, abcrdv_prd_db.
*/

-- 1. RECHERCHE DE PROFESSIONNELS
-- Cette requête trouve tous les professionnels dans une ville spécifique (par exemple, Paris)
SELECT
    p.nom,
    p.adresse
FROM abcrdv_prd_db.professionnels p
JOIN abcrdv_prd_db.villes v ON p.ville_id = v.ville_id
WHERE
    v.nom_ville = 'Paris';

-- Cette requête liste les professionnels offrant un service spécifique (par exemple, "Coloration")
SELECT
    p.nom,
    p.adresse,
    s.nom_service
FROM abcrdv_prd_db.professionnels p
JOIN abcrdv_prd_db.professionnel_services ps ON p.professionnel_id = ps.professionnel_id
JOIN abcrdv_prd_db.services s ON ps.service_id = s.service_id
WHERE
    s.nom_service = 'Coloration';

-- Cette requête combine les deux critères : professionnels dans une ville spécifique et leur services
SELECT
    p.nom,
    p.adresse,
    s.nom_service,
    s.description
FROM abcrdv_prd_db.professionnels p
JOIN abcrdv_prd_db.villes v ON p.ville_id = v.ville_id
JOIN abcrdv_prd_db.professionnel_services ps ON p.professionnel_id = ps.professionnel_id
JOIN abcrdv_prd_db.services s ON ps.service_id = s.service_id
WHERE
    v.nom_ville = ?
ORDER BY p.nom,s.nom_service ;



-- 2. GESTION DES RENDEZ-VOUS
-- Cette requête récupère toutes les réservations d'un client spécifique (par exemple, le client avec l'ID 1)
SELECT
    r.date_reservation,
    r.heure_reservation,
    p.nom AS nom_professionnel,
    s.nom_service
FROM abcrdv_prd_db.reservations r
JOIN abcrdv_prd_db.clients c ON r.client_id = c.client_id
JOIN abcrdv_prd_db.professionnels p ON r.professionnel_id = p.professionnel_id
JOIN abcrdv_prd_db.professionnel_services ps ON p.professionnel_id = ps.professionnel_id
JOIN abcrdv_prd_db.services s ON r.service_id = s.service_id
WHERE
    c.client_id = 1
ORDER BY
    r.date_reservation DESC, r.heure_reservation ASC;

-- Cette requête affiche l'agenda complet d'un professionnel pour une journée donnée
SELECT
    r.heure_reservation,
    c.nom AS nom_client,
    s.nom_service
FROM abcrdv_prd_db.reservations r
JOIN abcrdv_prd_db.clients c ON r.client_id = c.client_id
JOIN abcrdv_prd_db.services s ON r.service_id = s.service_id
WHERE
    r.professionnel_id = 1 AND r.date_reservation = '2023-10-27'
ORDER BY
    r.heure_reservation ASC;



-- 3. STATISTIQUES ET ANALYSES
-- Cette requête calcule la note moyenne d'un professionnel basé sur tous les avis
SELECT
    p.nom,
    AVG(a.note) AS note_moyenne
FROM abcrdv_prd_db.avis a
JOIN abcrdv_prd_db.professionnels p ON a.professionnel_id = p.professionnel_id
GROUP BY
    p.nom
ORDER BY
    note_moyenne DESC;

-- Cette requête liste les services les plus réservés
SELECT
    s.nom_service,
    COUNT(1) AS nombre_reservations
FROM abcrdv_prd_db.reservations r
JOIN abcrdv_prd_db.services s ON r.service_id = s.service_id
GROUP BY
    s.nom_service
ORDER BY
    nombre_reservations DESC; 

-- Cette requête trouve les clients ayant fait plus d'une réservation
select COUNT(1) count, r.client_id 
from abcrdv_prd_db.reservations r 
group by  r.client_id having  COUNT(1) > 1 ;


-- Fin des requêtes SQL pour la base de données ABC-RDV en production

