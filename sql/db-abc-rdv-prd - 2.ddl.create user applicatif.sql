/*
Executer ce script autant que root.

Creation de l'utilisateur applicatif pour la base de données MariaDB du projet ABCRDV.

*/

CREATE USER 'abcrdv_prd_userapf'@'%' IDENTIFIED BY '*E8D46CE25265E545D225A8A6F1BAF642FEBEE5CB*';

GRANT ALL PRIVILEGES ON *.* TO 'abcrdv_prd_userapf'@'%' ;