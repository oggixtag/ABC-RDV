<!DOCTYPE html>
<html lang="fr">
<!-- Head -->
<?php include 'head.php'; ?>
<body>
    <!-- Header -->
    <?php include 'header.php'; ?>
	<!-- Navigation Menu -->
	<?php include 'navigation.php'; ?>
	<!-- Main page -->
	<main role='main'>
		
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
			FROM abc_rdv_prd_db.professionnels p
			JOIN abc_rdv_prd_db.villes v ON p.ville_id = v.ville_id
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
	<!DOCTYPE html>
	<html lang="fr">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Recherche de Professionnels</title>
		<style>
			body { font-family: sans-serif; margin: 2rem; }
			.container { max-width: 800px; margin: auto; }
			h1 { text-align: center; color: #118AB2; }
			form { text-align: center; margin-bottom: 2rem; }
			input[type="text"] { padding: 0.5rem; border: 1px solid #ccc; border-radius: 4px; }
			input[type="submit"] { padding: 0.5rem 1rem; border: none; background-color: #06D6A0; color: white; border-radius: 4px; cursor: pointer; }
			input[type="submit"]:hover { background-color: #05C997; }
			table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
			th, td { border: 1px solid #ddd; padding: 0.75rem; text-align: left; }
			th { background-color: #F0F4F8; color: #073B4C; }
			.no-results { text-align: center; color: #FF6B6B; margin-top: 2rem; }
		</style>
	</head>
	<body>
		<div class="container">
			<h1>Rechercher un professionnel à <?php echo htmlspecialchars($_GET['ville'])?> </h1>
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
								<td><a href="jeSuisProfessionnel_ia.php?ville_id=<?php echo $row['ville_id']; ?>&professionnel_id=<?php echo $row['professionnel_id']; ?>"><?php echo htmlspecialchars($row['nom']); ?></a></td>
								<td><?php echo htmlspecialchars($row['adresse']); ?></td>
							</tr>
						<?php endwhile; ?>
					</tbody>
				</table>
			<?php elseif (isset($resultat) && $resultat->num_rows == 0) : ?>
				<p class="no-results">Aucun professionnel trouvé dans cette ville.</p>
			<?php endif; ?>
		</div>
	</body>
	</html>
	<?php
	// Fermer la connexion à la base de données
	if (isset($stmt)) {
		$stmt->close();
	}
	$connexion->close();
	?>
	
	<h2>page Recherche</h2>
	
	<a href="index.php">Home page</a>
	
	</main>
    <!-- Footer -->
    <?php include 'footer.php'; ?>
</body> 
</html>
	
	
	