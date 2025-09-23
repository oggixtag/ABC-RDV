/*
Ce script supprime l'utilisateur administrateur de la base de données MariaDB pour le projet ABC-RDV.
Le script est conçu pour être exécuté dans un environnement de production, abcrdv_prd_db.
Il faut exécuter le script avec l'utilisateur ayant les droits de suppression d'utilisateur.
*/

DROP USER IF EXISTS 'abcrdv_prd_db.abc_rdv';