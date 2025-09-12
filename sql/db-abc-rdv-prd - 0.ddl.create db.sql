/*
Executer ce script autant que root.

Ce script permet de créer une base de données MariaDB pour le projet ABC-RDV. Le script est conçu pour être exécuté dans un environnement de production.
Il crée une base de données nommée "db-abc-rdv-prd" avec les paramètres suivants :
- Jeu de caractères : utf8mb4  
*/
create database if not exists db-abc-rdv-prd
    character set utf8mb4
    collate utf8mb4_general_ci;