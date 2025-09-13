
/*
    Pour les tests cf test/test ABC-RDV.xlsx
*/

-- 1. GESTION DES PROFESSIONNELS

/*
    Enregistrement nouveau professionnel
    avec un service déjà présent et une ville (Nice) connue 
*/

-- vérification de la ville 
SELECT * from villes where nom_ville='Nice';
-- resultat:4

-- nouveau enregistrement dans la table professionnel
SELECT * from professionnels where nom='TAO' and email ='t1@email.com';
-- resultat:65

-- nouveau enregistrement dans la table professionnel_services
select * from professionnel_services where professionnel_id=65;
-- resultat:7

--nouveau enregistrement dans la table services
select * from services where service_id=7;
-- resultat:Balayage




-- 2. GESTION DES PROFESSIONNELS
