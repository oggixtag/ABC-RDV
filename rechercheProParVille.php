<!DOCTYPE html>
<html lang="fr">
<!-- Head -->
<?php include 'head.php'; ?>
<body>
    <!-- Header -->
	<?php include 'header.php'; ?>
    <!-- Main page -->
    <main role='main'>
        
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

		// Assurez-vous que le paramètre de recherche 'ville' est défini
		if (isset($_GET['ville']) && !empty($_GET['ville'])) {
			$ville_recherchee = $_GET['ville'];

			// Préparer la requête SQL pour rechercher les professionnels par ville
			$sql = "
				SELECT
					v.ville_id,
					p.professionnel_id,
					p.nom,
					p.adresse
				FROM abcrdv_prd_db.professionnels p
				JOIN abcrdv_prd_db.villes v ON p.ville_id = v.ville_id
				WHERE
					v.nom_ville = ?
				ORDER BY p.nom
			";

			// Préparer et exécuter la requête
			$stmt = $connexion->prepare($sql);
			$stmt->bind_param("s", $ville_recherchee);
			$stmt->execute();
			$resultat = $stmt->get_result();
		}

		?>
		<div class="container">
		
			<!-- Liste des professionnels -->
			<div class="section">
				<h1>Notre liste de professionnel dans la ville de <?php echo htmlspecialchars($_GET['ville'])?> : </h1>
				<?php if (isset($resultat) && $resultat->num_rows > 0) : ?>
					<table>
						<thead>
							<tr>
								<th>Nom du professionnel</th>
								<th>Adresse</th>
							</tr>
						</thead>
						<tbody>
							<?php while ($row = $resultat->fetch_assoc()) : ?>
								<tr>
									<td>
										<a href="professionnelChoisi.php?ville_id=<?php echo $row['ville_id']; ?>&professionnel_id=<?php echo $row['professionnel_id']; ?>"><?php echo htmlspecialchars($row['nom']); ?></a>
									</td>
									<td><?php echo htmlspecialchars($row['adresse']); ?></td>
								</tr>
							<?php endwhile; ?>
						</tbody>
					</table>
				<?php elseif (isset($resultat) && $resultat->num_rows == 0) : ?>
					<p class="no-results">Nous n'avons trouvé aucun professionnel dans cette belle ville.</p>
				<?php endif; ?>
			</div>
    
			<hr>

			<!-- Lien pour le professionnel -->
			<div class="pty20 section">
				<h2>Êtes-vous un professionnel de la ville <?php echo htmlspecialchars($_GET['ville'])?> ?</h2>
				<div class="link-pro">
					<a href="vousEtesProfessionnel.php">
						<h3>Inscrivez-vous en tant que professionnel</h3>
					</a>
				</div>
			</div>
    
			<hr>

			<!-- Formulaire pour permettre à l'utilisateur de changer de ville -->
			<div class="section">
				<h2>Rechercher un professionnel dans une autre ville</h2>
				<form class="search-form" action="rechercheProParVille.php" method="get">
					<input type="text" name="ville" placeholder="Entrez le nom d'une ville" required>
					<button type="submit">Rechercher</button>
				</form>
			</div>
			
    </div>

		<?php
		// Fermer la connexion à la base de données
		if (isset($stmt)) {
			$stmt->close();
		}
		$connexion->close();
		?>    
    </main>
    <!-- Footer -->
    <?php include 'footer.php'; ?>
</body>
</html>
