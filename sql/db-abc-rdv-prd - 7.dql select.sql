/*
Ce fichier ne doit pas être exécuté. Il contient des requêtes SQL pour interagir avec la base de données du projet ABC-RDV.
Il est destiné à être utilisé comme référence pour les développeurs et les administrateurs de la base de données.
Exploitation données dans l'environnement de production, db-abc-rdv-prd.
*/

-- 1. RECHERCHE DE PROFESSIONNELS
-- Cette requête trouve tous les professionnels dans une ville spécifique (par exemple, Paris)
SELECT
    p.nom,
    p.adresse,
    p.services
FROM db-abc-rdv-prd.Professionnels p
JOIN db-abc-rdv-prd.Villes v ON p.ville_id = v.id
WHERE
    v.nom = 'Paris';

-- Cette requête liste les professionnels offrant un service spécifique (par exemple, "Coloration")
SELECT
    p.nom,
    p.adresse,
    s.nom_service
FROM db-abc-rdv-prd.Professionnels p
JOIN db-abc-rdv-prd.Services s ON JSON_CONTAINS(p.services, JSON_ARRAY(s.id))
WHERE
    s.nom_service = 'Coloration';

-- 2. GESTION DES RENDEZ-VOUS
-- Cette requête récupère toutes les réservations d'un client spécifique (par exemple, le client avec l'ID 1)
SELECT
    r.date,
    r.heure,
    p.nom AS nom_professionnel,
    s.nom_service
FROM db-abc-rdv-prd.Reservations r
JOIN db-abc-rdv-prd.Clients c ON r.client_id = c.id
JOIN db-abc-rdv-prd.Professionnels p ON r.professionnel_id = p.id
JOIN db-abc-rdv-prd.Services s ON r.service_id = s.id
WHERE
    c.id = 1
ORDER BY
    r.date DESC, r.heure ASC;

-- Cette requête affiche l'agenda complet d'un professionnel pour une journée donnée
SELECT
    r.heure,
    c.nom AS nom_client,
    s.nom_service
FROM db-abc-rdv-prd.Reservations r
JOIN db-abc-rdv-prd.Clients c ON r.client_id = c.id
JOIN db-abc-rdv-prd.Services s ON r.service_id = s.id
WHERE
    r.professionnel_id = 1 AND r.date = '2023-10-27'
ORDER BY
    r.heure ASC;

-- 3. STATISTIQUES ET ANALYSES
-- Cette requête calcule la note moyenne d'un professionnel basé sur tous les avis
SELECT
    p.nom,
    AVG(a.note) AS note_moyenne
FROM db-abc-rdv-prd.Avis a
JOIN db-abc-rdv-prd.Professionnels p ON a.professionnel_id = p.id
GROUP BY
    p.nom
ORDER BY
    note_moyenne DESC;

-- Cette requête liste les services les plus réservés
SELECT
    s.nom_service,
    COUNT(r.id) AS nombre_reservations
FROM db-abc-rdv-prd.Reservations r
JOIN db-abc-rdv-prd.Services s ON r.service_id = s.id
GROUP BY
    s.nom_service
ORDER BY
    nombre_reservations DESC;
