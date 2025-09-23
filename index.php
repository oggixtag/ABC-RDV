<!DOCTYPE html>
<html lang="fr">
<!-- Head -->
<?php include 'head.php'; ?>
<body>
    <!-- Header -->
	<?php include 'header.php'; ?>
    <!-- Navigation Menu -->
    <?php include 'navigation.php'; ?>
    <main role="main">
        <div id="accueil" class="py20">
            <section>
                <div class="mx_auto text_align_center">
                    <h2>Votre nouveau rendez-vous beauté, 24/7.</h2>
                    <p>Trouvez et réservez votre coiffeur idéal en quelques clics. Simple, rapide et toujours disponible.</p>
                </div>
            </section>
        </div>
        <div id="villes" class="py20">
            <section> 
                <div class="mx_auto text_align_center">
                    <h2>Rechercher par ville </h2>
                    <div class="villes-container">
                        <?php
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

                            // Requête pour récupérer les villes
                            $sql = "SELECT nom_ville FROM abcrdv_prd_db.villes ORDER BY nom_ville ASC";
                            $resultat = $connexion->query($sql);

                            if ($resultat && $resultat->num_rows > 0) {
                                while($row = $resultat->fetch_assoc()) {
                                    $nom_ville = htmlspecialchars($row['nom_ville']);
                                    echo "<div class='ville-block'>";
                                    echo "<a href='rechercheProParVille.php?ville=" . urlencode($nom_ville) . "'>" . $nom_ville . "</a>";
                                    echo "</div>";
                                }
                            } else {
                                echo "<p>Aucune ville n'a été trouvée dans la base de données.</p>";
                            }
                        ?>
                    </div>
                </div>
            </section>
        </div>
        <div id="processus" class="py20">
            <section >
                <div class="mx_auto text_align_center">
                    <h2>Comment ça marche ?</h2>
                    <div class="service-blocks">
                        <div class="service-block">
                            <h3>1. Recherchez</h3>
                            <p>Parcourez notre liste de coiffeurs et choisissez celui qui vous convient le mieux selon vos critères, filtrez par service ou disponibilité</p>
                        </div>
                        <div class="service-block">
                            <h3>2. Réservez</h3>
                            <p>Sélectionnez la prestation, votre créneau horaire préféré et confirmez votre rendez-vous en un instant.</p>
                        </div>
                        <div class="service-block">
                            <h3>3. Profitez</h3>
                            <p>Rendez-vous à votre salon, détendez-vous et profitez d’un service de qualité, sans attente.C'est aussi simple que ça !
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <div id="service" class="py20">
            <section>
                <div class="mx_auto text_align_center">
                    <h2>Nos services populaires</h2>
                    <p>Découvrez les prestations les plus demandées par notre communauté.</p>
                    <div class="service-blocks">
                        <div class="service-block">
                            <img src="https://placehold.co/150x200/F4F1ED/3D3D3D?text=Coupe+%26+Brushing" alt="Coupe et Brushing" />
                            <div>
                                <h3>Coupe &amp; Brushing</h3>
                            </div>
                        </div>
                        <div class="service-block">
                            <img src="https://placehold.co/150x200/D57A66/FFFFFF?text=Coloration" alt="Coloration" />
                            <div>
                                <h3>Coloration</h3>
                            </div>
                        </div>
                        <div class="service-block">
                            <img src="https://placehold.co/150x200/F4F1ED/3D3D3D?text=Balayage" alt="Balayage" />
                            <div>
                                <h3>Balayage</h3>
                            </div>
                        </div>
                        <div class="service-block">
                            <img src="https://placehold.co/150x200/3D3D3D/FFFFFF?text=Soin+Cheveux" alt="Soin Cheveux"/>
                            <div>
                                <h3>Soin Cheveux</h3>
                            </div>
                        </div>
                    </div>
                    <div class="button-style">
                        <a href="nosServicesPopulaires.php">Découvrir tous les services</a>
                    </div>
                </div>
            </section>
        </div>
        <div id="temoignages" class="py20">
            <section>
                <div class="mx_auto text_align_center">
                    <h2>Ils nous font confiance</h2>
					<p>Découvrez ce que nos clients disent de nous.</p>
                    <?php
                        // Connexion à la base de données
                        $connexion = new mysqli($host, $user, $password, $dbname);

                        if ($connexion->connect_error) {
                            die("Échec de la connexion à la base de données : " . $connexion->connect_error);
                        }

                        // Requête pour récupérer les avis avec les noms des clients et des professionnels
                        $sql = "SELECT a.commentaire, a.note, c.nom AS nom_client, p.nom AS nom_professionnel
                                FROM avis a
                                JOIN clients c ON a.client_id = c.client_id
                                JOIN professionnels p ON a.professionnel_id = p.professionnel_id
                                ORDER BY a.avis_id DESC
                                LIMIT 6";

                        $resultat = $connexion->query($sql);

                        if ($resultat && $resultat->num_rows > 0) {
                            echo "<div class='testimonials-container'>";
                            while($row = $resultat->fetch_assoc()) {
                                $note = htmlspecialchars($row['note']);
                                $commentaire = htmlspecialchars($row['commentaire']);
                                $nom_client = htmlspecialchars($row['nom_client']);
                                $nom_professionnel = htmlspecialchars($row['nom_professionnel']);

                                echo "<div class='testimonial-block'>";
                                echo "<div class='rating'>";
                                for ($i = 0; $i < 5; $i++) {
                                    if ($i < $note) {
                                        echo "<span>&#9733;</span>"; // Étoile pleine
                                    } else {
                                        echo "<span>&#9734;</span>"; // Étoile vide
                                    }
                                }
                                echo "</div>";
                                echo "<p class='comment'>\"" . $commentaire . "\"</p>";
                                echo "<p class='author'>- " . $nom_client . " (client de " . $nom_professionnel . ")</p>";
                                echo "</div>";
                            }
                            echo "</div>";
                        } else {
                            echo "<p>Aucun avis n'a été trouvé.</p>";
                        }
                        $connexion->close();
                    ?>
                </div>
            </section>
        </div>
        <div  class="py20">
            <section>
                <div class="mx_auto text_align_center">
                    <h2 >Vous êtes coiffeur ?</h2>
                    <p>Rejoignez notre plateforme pour gagner en visibilité, gérer votre agenda sans effort et développer votre clientèle. Concentrez-vous sur votre art, nous nous occupons du reste.</p>
					<div class="button-style">
                        <a href="vousEtesProfessionnel.php">Inscrivez-vous en tant que professionnel</a>
                    </div>
                </div>
            </section>
        </div>
    </main>
    <!-- Footer -->
    <?php include 'footer.php'; ?>
</body>
</html>
