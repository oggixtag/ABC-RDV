<!DOCTYPE html>
<html lang="fr">
<!-- Head -->
<?php include 'head.php'; ?>
<body>
    <!-- Header -->
	<?php include 'header.php'; ?>
    <!-- Main page Nos services populaires-->
    <main>
        <div class="mx_auto text_align_center">
            <h2>Nos services populaires</h2>
            <p>Découvrez les prestations les plus demandées par notre communauté.</p>
            <div class="service-blocks">
                <?php
                // Configuration de la base de données
                $host = "mysql-abcrdv.alwaysdata.net";
                $user = "abcrdv";
                $password = "*E8D46CE25265E545D225A8A6F1BAF642FEBEE5CB";
                $dbname = "abcrdv_prd_db";

                // Tableau de 100 codes de couleurs
                $color_codes = [
                    "FF5733", "FFBD33", "F0FF33", "A1FF33", "33FF57", "33FFBD", "33F0FF", "33A1FF",
                    "5733FF", "BD33FF", "F033FF", "FF33A1", "FF3357", "FF33BD", "FF33F0", "A133FF",
                    "33FF7A", "33FF57", "BDFF33", "F0FF33", "33F0FF", "33BDFF", "A133FF", "5733FF",
                    "FF33F0", "FF33A1", "FF3357", "FF7A33", "FFBD33", "FFD533", "FFD533", "A1FF33",
                    "D5FF33", "BDFF33", "57FF33", "33FFD5", "33FFBD", "33FF7A", "33F0FF", "33A1FF",
                    "3357FF", "33BDFF", "33D5FF", "33D5FF", "5733FF", "BD33FF", "D533FF", "F033FF",
                    "FF33BD", "FF33A1", "FF3357", "FF7A33", "FFBD33", "F0FF33", "D5FF33", "BDFF33",
                    "57FF33", "33FF7A", "33FFBD", "33FFD5", "33F0FF", "33A1FF", "3357FF", "33BDFF",
                    "33D5FF", "5733FF", "BD33FF", "D533FF", "F033FF", "FF33F0", "FF33A1", "FF3357",
                    "FF7A33", "FFBD33", "F0FF33", "D5FF33", "BDFF33", "57FF33", "33FF7A", "33FFBD",
                    "33FFD5", "33F0FF", "33A1FF", "3357FF", "33BDFF", "33D5FF", "5733FF", "BD33FF",
                    "D533FF", "F033FF", "FF33F0", "FF33A1", "FF3357", "FF7A33", "FFBD33", "F0FF33",
                    "33A1FF", "5733FF", "FF33A1", "FF33F0"
                ];

                // Établir la connexion à la base de données
                $connexion = new mysqli($host, $user, $password, $dbname);

                // Vérifier la connexion
                if ($connexion->connect_error) {
                    die("Échec de la connexion à la base de données : " . $connexion->connect_error);
                }

                // Requête pour récupérer les services
                $sql = "SELECT nom_service FROM services ORDER BY nom_service ASC";
                $resultat = $connexion->query($sql);

                if ($resultat && $resultat->num_rows > 0) {
                    // Afficher les données de chaque ligne
                    while($row = $resultat->fetch_assoc()) {
                        $nom_service = htmlspecialchars($row['nom_service']);
                        
                        // Sélectionner deux indices aléatoires pour les couleurs
                        $rand_index1 = array_rand($color_codes);
                        $rand_index2 = array_rand($color_codes);
                        $color1 = $color_codes[$rand_index1];
                        $color2 = $color_codes[$rand_index2];

                        echo "<div class='service-block'>";
                        echo "<img src='https://placehold.co/150x200/" . $color1 . "/" . $color2 . "?text=" . urlencode($nom_service) . "' alt='" . $nom_service . "' />";
                        echo "<div>";
                        echo "<h3>" . $nom_service . "</h3>";
                        echo "</div>";
                        echo "</div>";
                    }
                } else {
                    echo "<p>Aucun service populaire n'a été trouvé dans la base de données.</p>";
                }

                // Fermer la connexion
                $connexion->close();
                ?>
            </div>
        </div>
    </main>
    <!-- Footer -->
    <?php include 'footer.php'; ?>
</body>
</html>
