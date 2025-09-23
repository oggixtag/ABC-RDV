/*
Creation de l'utilisateur adminstrateur pour la base de données MariaDB du projet ABCRDV.

Il faut executer le script avec l'utilisateur ayant les droits create CREATE USER et GRANT ALL PRIVILEGES 
*/

CREATE USER 'abcrdv'@'%' IDENTIFIED BY '*E8D46CE25265E545D225A8A6F1BAF642FEBEE5CB';

GRANT ALL PRIVILEGES ON *.* TO 'abcrdv'@'%' ;

GRANT ALL PRIVILEGES ON abcrdv_prd_db.* TO 'abcrdv'@'%';