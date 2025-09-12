/*
Ce scritp supprime la base de données MariaDB pour le projet ABC-RDV.
Le script est conçu pour être exécuté dans un environnement de production, abc_rdv_prd_db.
Il faut exécuter le script avec l'utilisateur ayant les droits de suppression de base de données
*/

DROP DATABASE IF EXISTS abc_rdv_prd_db;