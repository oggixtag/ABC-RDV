/*
Executer ce script autant que db-abc-rdv-prd-useradm.
ce script permet de supprimer une base de données MariaDB pour le projet ABC-RDV. Le script est conçu pour être exécuté dans un environnement de production.
Il supprime une base de données nommée "db-abc-rdv-prd".
Il est important de noter que la suppression des tables entraînera la perte de toutes les données qu'elles contiennent.
L'ordre de suppression est important en raison des clés étrangères.
*/

-- Supprimer la table des avis en premier car elle a des dépendances
DROP TABLE IF EXISTS db-abc-rdv-prd.Avis;

-- Supprimer la table des réservations
DROP TABLE IF EXISTS db-abc-rdv-prd.Reservations;

-- Supprimer la table des services
DROP TABLE IF EXISTS db-abc-rdv-prd.Services;

-- Supprimer la table des professionnels
DROP TABLE IF EXISTS db-abc-rdv-prd.Professionnels;

-- Supprimer la table des clients
DROP TABLE IF EXISTS db-abc-rdv-prd.Clients;

-- Supprimer la table des villes en dernier
DROP TABLE IF EXISTS db-abc-rdv-prd.Villes;