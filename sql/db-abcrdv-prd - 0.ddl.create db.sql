/*
Ce script permet de créer une base de données MariaDB pour le projet ABCRDV. Le script est conçu pour être exécuté dans un environnement de production.
Il crée une base de données nommée "abcrdv_prd_db" avec les paramètres suivants :
- Jeu de caractères : utf8mb4  

Il faut executer le script avec l'utilisateur ayant les droits create database.
*/

create database if not exists abcrdv_prd_db
    character set 'utf8mb4'
    collate 'utf8mb4_general_ci';