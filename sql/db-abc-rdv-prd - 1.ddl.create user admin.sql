/*
Creation de l'utilisateur adminstrateur pour la base de données MariaDB du projet ABCRDV.

Il faut executer le script avec l'utilisateur ayant les droits create CREATE USER et GRANT ALL PRIVILEGES 
*/

CREATE USER 'abcrdv_prd_useradm'@'%' IDENTIFIED BY '*E8D46CE25265E545D225A8A6F1BAF642FEBEE5CB';

GRANT ALL PRIVILEGES ON *.* TO 'abcrdv_prd_useradm'@'%' ;

GRANT ALL PRIVILEGES ON abc_rdv_bd_prd.* TO 'abcrdv_prd_useradm'@'%';