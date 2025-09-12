/*
Executer ce script autant que root.

Creation de l'utilisateur adminstrateur pour la base de données MariaDB du projet ABC-RDV.

utilisateur : db-abc-rdv-prd-useradm
mot de passe : db-abc-rdv-prd-useradm
*/

CREATE USER 'db-abc-rdv-prd-useradm'@'%' IDENTIFIED VIA mysql_native_password USING 'db-abc-rdv-prd-useradm';
GRANT ALL PRIVILEGES ON *.* TO 'abc-rdv-prd-useradm'@'%' REQUIRE NONE WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
GRANT ALL PRIVILEGES ON `abc-rdv-prd`.* TO 'abc-rdv-prd-useradm'@'%';