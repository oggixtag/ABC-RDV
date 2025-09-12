
/*
Executer ce script autant que db-abc-rdv-prd-useradm ou db-abc-rdv-prd-userapf.
Ce script met à jour l'historique des réservations pour les clients insérés dans une base de données MariaDB pour le projet ABC-RDV.
Le script est conçu pour être exécuté dans un environnement de production, db-abc-rdv-prd.
Il ajoute 50 enregistrements factices pour chaque client dans la colonne 'historique_reservations' de la table 'Client', afin de simuler un historique plus profond.
Il est important de noter que ce script suppose que la table 'Client' existe déjà et qu'elle contient des enregistrements de clients.
Il faut executer le script avec l'utilisateur ayant les droits de mise à jour sur la table 'Client'.
*/

/*
Ce script ne contient pas COMMIT final !
*/

--maj historique_reservations

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 1,
        'professionnel_id', 1,
        'service_id', 1,
        'date', '2024-10-01'
    )
) WHERE client_id = 1;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 2,
        'professionnel_id', 2,
        'service_id', 4,
        'date', '2024-10-01'
    )
) WHERE client_id = 2;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 3,
        'professionnel_id', 3,
        'service_id', 2,
        'date', '2024-10-02'
    )
) WHERE client_id = 3;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 4,
        'professionnel_id', 4,
        'service_id', 6,
        'date', '2024-10-02'
    )
) WHERE client_id = 4;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 5,
        'professionnel_id', 5,
        'service_id', 3,
        'date', '2024-10-03'
    )
) WHERE client_id = 5;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 6,
        'professionnel_id', 6,
        'service_id', 8,
        'date', '2024-10-03'
    )
) WHERE client_id = 6;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 7,
        'professionnel_id', 7,
        'service_id', 5,
        'date', '2024-10-04'
    )
) WHERE client_id = 7;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 8,
        'professionnel_id', 8,
        'service_id', 6,
        'date', '2024-10-04'
    )
) WHERE client_id = 8;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 9,
        'professionnel_id', 9,
        'service_id', 4,
        'date', '2024-10-05'
    )
) WHERE client_id = 9;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 10,
        'professionnel_id', 10,
        'service_id', 2,
        'date', '2024-10-05'
    )
) WHERE client_id = 10;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 11,
        'professionnel_id', 11,
        'service_id', 1,
        'date', '2024-10-06'
    )
) WHERE client_id = 11;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 12,
        'professionnel_id', 12,
        'service_id', 8,
        'date', '2024-10-06'
    )
) WHERE client_id = 12;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 13,
        'professionnel_id', 13,
        'service_id', 9,
        'date', '2024-10-07'
    )
) WHERE client_id = 13;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 14,
        'professionnel_id', 14,
        'service_id', 7,
        'date', '2024-10-07'
    )
) WHERE client_id = 14;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 15,
        'professionnel_id', 15,
        'service_id', 13,
        'date', '2024-10-08'
    )
) WHERE client_id = 15;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 16,
        'professionnel_id', 16,
        'service_id', 14,
        'date', '2024-10-08'
    )
) WHERE client_id = 16;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 17,
        'professionnel_id', 17,
        'service_id', 10,
        'date', '2024-10-09'
    )
) WHERE client_id = 17;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 18,
        'professionnel_id', 18,
        'service_id', 11,
        'date', '2024-10-09'
    )
) WHERE client_id = 18;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 19,
        'professionnel_id', 19,
        'service_id', 12,
        'date', '2024-10-10'
    )
) WHERE client_id = 19;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 20,
        'professionnel_id', 20,
        'service_id', 15,
        'date', '2024-10-10'
    )
) WHERE client_id = 20;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 21,
        'professionnel_id', 21,
        'service_id', 1,
        'date', '2024-10-11'
    )
) WHERE client_id = 21;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 22,
        'professionnel_id', 22,
        'service_id', 4,
        'date', '2024-10-11'
    )
) WHERE client_id = 22;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 23,
        'professionnel_id', 23,
        'service_id', 7,
        'date', '2024-10-12'
    )
) WHERE client_id = 23;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 24,
        'professionnel_id', 24,
        'service_id', 1,
        'date', '2024-10-12'
    )
) WHERE client_id = 24;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 25,
        'professionnel_id', 25,
        'service_id', 2,
        'date', '2024-10-13'
    )
) WHERE client_id = 25;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 26,
        'professionnel_id', 26,
        'service_id', 3,
        'date', '2024-10-13'
    )
) WHERE client_id = 26;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 27,
        'professionnel_id', 27,
        'service_id', 4,
        'date', '2024-10-14'
    )
) WHERE client_id = 27;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 28,
        'professionnel_id', 28,
        'service_id', 1,
        'date', '2024-10-14'
    )
) WHERE client_id = 28;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 29,
        'professionnel_id', 29,
        'service_id', 6,
        'date', '2024-10-15'
    )
) WHERE client_id = 29;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 30,
        'professionnel_id', 30,
        'service_id', 8,
        'date', '2024-10-15'
    )
) WHERE client_id = 30;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 31,
        'professionnel_id', 31,
        'service_id', 2,
        'date', '2024-10-16'
    )
) WHERE client_id = 31;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 32,
        'professionnel_id', 32,
        'service_id', 11,
        'date', '2024-10-16'
    )
) WHERE client_id = 32;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 33,
        'professionnel_id', 33,
        'service_id', 9,
        'date', '2024-10-17'
    )
) WHERE client_id = 33;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 34,
        'professionnel_id', 34,
        'service_id', 7,
        'date', '2024-10-17'
    )
) WHERE client_id = 34;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 35,
        'professionnel_id', 35,
        'service_id', 14,
        'date', '2024-10-18'
    )
) WHERE client_id = 35;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 36,
        'professionnel_id', 36,
        'service_id', 10,
        'date', '2024-10-18'
    )
) WHERE client_id = 36;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 37,
        'professionnel_id', 37,
        'service_id', 10,
        'date', '2024-10-19'
    )
) WHERE client_id = 37;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 38,
        'professionnel_id', 38,
        'service_id', 13,
        'date', '2024-10-19'
    )
) WHERE client_id = 38;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 39,
        'professionnel_id', 39,
        'service_id', 12,
        'date', '2024-10-20'
    )
) WHERE client_id = 39;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 40,
        'professionnel_id', 40,
        'service_id', 15,
        'date', '2024-10-20'
    )
) WHERE client_id = 40;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 41,
        'professionnel_id', 41,
        'service_id', 1,
        'date', '2024-10-21'
    )
) WHERE client_id = 41;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 42,
        'professionnel_id', 42,
        'service_id', 2,
        'date', '2024-10-21'
    )
) WHERE client_id = 42;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 43,
        'professionnel_id', 43,
        'service_id', 4,
        'date', '2024-10-22'
    )
) WHERE client_id = 43;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 44,
        'professionnel_id', 44,
        'service_id', 5,
        'date', '2024-10-22'
    )
) WHERE client_id = 44;

/*UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 45,
        'professionnel_id', 45,
        'service_id', 2,
        'date', '2024-10-23'
    )
) WHERE client_id = 45;*/

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 46,
        'professionnel_id', 46,
        'service_id', 3,
        'date', '2024-10-23'
    )
) WHERE client_id = 46;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 47,
        'professionnel_id', 47,
        'service_id', 8,
        'date', '2024-10-24'
    )
) WHERE client_id = 47;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 48,
        'professionnel_id', 48,
        'service_id', 11,
        'date', '2024-10-24'
    )
) WHERE client_id = 48;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 49,
        'professionnel_id', 49,
        'service_id', 9,
        'date', '2024-10-25'
    )
) WHERE client_id = 49;

UPDATE db-abc-rdv-prd.Client SET historique_reservations = JSON_ARRAY_APPEND(
    historique_reservations,
    '$.reservations',
    JSON_OBJECT(
        'reservation_id', 50,
        'professionnel_id', 50,
        'service_id', 7,
        'date', '2024-10-25'
    )
) WHERE client_id = 50;

