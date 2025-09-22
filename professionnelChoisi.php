<!DOCTYPE html>
<html lang="fr">
<!-- Head -->
<?php include 'head.php'; ?>
<body>
    <!-- Header -->
    <?php include 'header.php'; ?>
    <!-- Navigation Menu -->
    <?php include 'navigation.php'; ?>
    <!-- Main page Je suis Professionnel-->
    <main>
        <h2>page Je suis Professionnel</h2>
        <?php
        
        // Configuration de la base de données
		$host = "localhost";
		$user = "abc_rdv_prd_useradm";
		$password = "";
		$dbname = "abc_rdv_prd_db";

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
                FROM abc_rdv_prd_db.professionnels p
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
                FROM abc_rdv_prd_db.professionnels p
                JOIN abc_rdv_prd_db.professionnel_services ps ON ps.professionnel_id = p.professionnel_id
                JOIN abc_rdv_prd_db.services s ON s.service_id = ps.service_id
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
        
        $connexion->close();
        ?>
        
        <?php if ($info_professionnel) : ?>
        <div>
            <div>
                Nom du professionnel: <?php echo htmlspecialchars($info_professionnel['nom']); ?>
            </div>
            <div>
                Adresse: <?php echo htmlspecialchars($info_professionnel['adresse']); ?>
            </div>
        </div>
        <?php else: ?>
        <p>Professionnel non trouvé.</p>
        <?php endif; ?>

        <br><br>
        
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

        <br><br>
        
        <a href="rechercheProParVille.php">Retour à la liste de professionnel</a>
        
    </main>
    <!-- Footer -->
    <?php include 'footer.php'; ?>
</body>
</html>
