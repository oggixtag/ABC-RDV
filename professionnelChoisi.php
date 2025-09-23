<!DOCTYPE html>
<html lang="fr">
<!-- Head -->
<?php include 'head.php'; ?>
<body>
    <!-- Header -->
    <?php include 'header.php'; ?>
    <!-- Main page Je suis Professionnel-->
    <main>
        <?php
        
		//var_dump('professionnel_id: '.$_GET['professionnel_id']);
		//var_dump('ville_id: '.$_GET['ville_id']);
		
        // Configuration de la base de données
		$host = "mysql-abcrdv.alwaysdata.net";
		$user = "abcrdv";
		$password = "*E8D46CE25265E545D225A8A6F1BAF642FEBEE5CB";
		$dbname = "abcrdv_prd_db";

        // Établir la connexion à la base de données
        $connexion = new mysqli($host, $user, $password, $dbname);

        // Vérifier la connexion
        if ($connexion->connect_error) {
            die("Échec de la connexion à la base de données : " . $connexion->connect_error);
        }
        
        $info_professionnel = null;
        $services_disponibles = [];

        if (isset($_GET['professionnel_id']) && !empty($_GET['professionnel_id'])) {
            $pro_id = $_GET['professionnel_id'];
            
            // Préparer la requête SQL pour les informations du professionnel
            $sql_info_pro = "
                SELECT
                    p.professionnel_id,
                    p.nom,
                    p.adresse
                FROM abcrdv_prd_db.professionnels p
                WHERE
                    p.professionnel_id = ?;
            ";

            $stmt_info = $connexion->prepare($sql_info_pro);
            $stmt_info->bind_param("i", $pro_id);
            $stmt_info->execute();
            $resultat_info_pro = $stmt_info->get_result();
            if ($resultat_info_pro->num_rows > 0) {
                $info_professionnel = $resultat_info_pro->fetch_assoc();
            }
            $stmt_info->close();

            // Préparer la requête SQL pour la liste des services
            $sql_services = "
                SELECT
                    p.professionnel_id,
                    s.service_id,
                    s.nom_service,
                    s.description,
                    ps.prix,
                    ps.duree
                FROM abcrdv_prd_db.professionnels p
                JOIN abcrdv_prd_db.professionnel_services ps ON ps.professionnel_id = p.professionnel_id
                JOIN abcrdv_prd_db.services s ON s.service_id = ps.service_id
                WHERE
                    p.professionnel_id = ?
                ORDER BY s.nom_service;
            ";
            
            $stmt_services = $connexion->prepare($sql_services);
            $stmt_services->bind_param("i", $pro_id);
            $stmt_services->execute();
            $resultat_services = $stmt_services->get_result();
            if ($resultat_services->num_rows > 0) {
                while($row = $resultat_services->fetch_assoc()) {
                    $services_disponibles[] = $row;
                }
            }
            $stmt_services->close();
        }
		
		if (isset($_GET['ville_id']) && !empty($_GET['ville_id'])) {
			$ville_id = $_GET['ville_id'];
			
			// Étape 1 : Gérer l'enregistrement du client
			$sql_ville_nom = "SELECT nom_ville FROM abcrdv_prd_db.villes WHERE ville_id = ?";
			$stmt_ville_nom = $connexion->prepare($sql_ville_nom);
			$stmt_ville_nom->bind_param("s", $ville_id);
			$stmt_ville_nom->execute();
			$result_ville = $stmt_ville_nom->get_result();
			$ville_row = $result_ville->fetch_assoc();
			
			//var_dump($ville_row);
			//var_dump($ville_row['nom_ville']);
			
			$stmt_ville_nom->close();
		}
		
        $connexion->close();
        ?>
        
		<?php if ($info_professionnel) : ?>
			<div class="section">
				<h2>Nom du professionnel: <?php echo htmlspecialchars($info_professionnel['nom']); ?></h2>
				<h2>Adresse: <?php echo htmlspecialchars($info_professionnel['adresse']); ?></h2>
			</div>
        <?php else: ?>
			<div class="pty20 no-results">Professionnel non trouvé.</div>
        <?php endif; ?>
        
        <div class="services-group">
            <?php if (!empty($services_disponibles)): ?>
            <?php foreach ($services_disponibles as $service): ?>
            <div class="service-item">
                <form action="prendreRdv.php" method="post">
                    <input type="hidden" name="professionnel_id" value="<?php echo htmlspecialchars($service['professionnel_id']); ?>">
                    <input type="hidden" name="service_id" value="<?php echo htmlspecialchars($service['service_id']); ?>">
                    <button type="submit">Je reserve</button>
                </form>
                <div>
                    <strong><?php echo htmlspecialchars($service['nom_service']); ?></strong>
                    <p>Prix: <?php echo htmlspecialchars($service['prix']); ?>€</p>
                    <p>Durée: <?php echo htmlspecialchars($service['duree']); ?> min</p>
                    <p><?php echo htmlspecialchars($service['description']); ?></p>
                </div>
            </div>
            <?php endforeach; ?>
            <?php else: ?>
            <p>Ce professionnel ne propose pas de services actuellement.</p>
            <?php endif; ?>
        </div>

        <hr>
        

		<div class="button-style text_align_center"> 
			<a href="rechercheProParVille.php?ville=<?= htmlspecialchars($ville_row['nom_ville']); ?>">Retour à la liste des professionnels de la ville de <?= htmlspecialchars($ville_row['nom_ville']); ?></a>
		</div>
        
    </main>
    <!-- Footer -->
    <?php include 'footer.php'; ?>
</body>
</html>
