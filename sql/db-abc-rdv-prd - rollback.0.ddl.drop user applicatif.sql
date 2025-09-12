/*
Ce script supprime l'utilisateur applicatif de la base de données MariaDB pour le projet ABC-RDV.
Le script est conçu pour être exécuté dans un environnement de production, abc_rdv_prd_db.
Il faut exécuter le script avec l'utilisateur ayant les droits de suppression d'utilisateur.
*/

DROP USER IF EXISTS 'abc_rdv_prd_db.abc_rdv_prd_userapf';