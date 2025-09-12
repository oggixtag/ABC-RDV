/*
Executer ce script autant que abc_rdv_prd_db-useradm.
Ce script permet de supprimer une base de données MariaDB pour le projet ABC-RDV. Le script est conçu pour être exécuté dans un environnement de production.
Il supprime une base de données nommée "abc_rdv_prd_db".
Il est important de noter que la suppression des tables entraînera la perte de toutes les données qu'elles contiennent.
L'ordre de suppression est important en raison des clés étrangères.
*/

-- Supprimer la table des avis en premier car elle a des dépendances
DROP TABLE IF EXISTS abc_rdv_prd_db.avis;

-- Supprimer la table des réservations
DROP TABLE IF EXISTS abc_rdv_prd_db.reservations;

-- Supprimer la table de liaison entre professionnels et services
DROP TABLE IF EXISTS abc_rdv_prd_db.professionnel_services;

-- Supprimer la table des services
DROP TABLE IF EXISTS abc_rdv_prd_db.services;

-- Supprimer la table des professionnels
DROP TABLE IF EXISTS abc_rdv_prd_db.professionnels;

-- Supprimer la table des clients
DROP TABLE IF EXISTS abc_rdv_prd_db.clients;

-- Supprimer la table des villes en dernier
DROP TABLE IF EXISTS abc_rdv_prd_db.villes;