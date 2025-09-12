/*
Executer ce script autant que root.

Creation de l'utilisateur applicatif pour la base de données MariaDB du projet ABC-RDV.

utilisateur : db-abc-rdv-prd-userapf
mot de passe : db-abc-rdv-prd-userapf
*/

CREATE USER 'db-abc-rdv-prd-userapf'@'%' IDENTIFIED VIA mysql_native_password USING 'db-abc-rdv-prd-userapf';
GRANT ALL PRIVILEGES ON *.* TO 'abc-rdv-prd-userapf'@'%' REQUIRE NONE WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;