<!DOCTYPE html>
<html lang="fr">
<!-- Head -->
<?php include 'head.php'; ?>
<body>
    <!-- Header -->
    <?php include 'header.php'; ?>
	<!-- Navigation Menu -->
	<?php include 'navigation.php'; ?>
	<!-- Main page vous êtes coiffeur-->
	<main>
		<h2>page Vous êtes coiffeur</h2>
		<a href="index.php">Home page</a>
		
		<?php

// Configuration de la base de données
$host = "localhost";
$user = "abc_rdv_prd_useradm";
$password = "";
$dbname = "abc_rdv_prd_db";

// Message de statut
$message_statut = '';
$message_type = '';

// Connexion à la base de données
$connexion = new mysqli($host, $user, $password, $dbname);

if ($connexion->connect_error) {
    die("Échec de la connexion : " . $connexion->connect_error);
}

// Récupérer la liste des services pour le formulaire
$sql_services = "SELECT service_id, nom_service FROM services ORDER BY nom_service";
$resultat_services = $connexion->query($sql_services);
$services_disponibles = [];
if ($resultat_services && $resultat_services->num_rows > 0) {
    while($row = $resultat_services->fetch_assoc()) {
        $services_disponibles[] = $row;
    }
}

// Traitement du formulaire
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Récupérer et valider les données du formulaire
    $nom = $_POST['nom'] ?? '';
    $adresse = $_POST['adresse'] ?? '';
    $telephone = $_POST['telephone'] ?? '';
    $email = $_POST['email'] ?? '';
    $notes = $_POST['notes'] ?? '';
    $nom_ville = $_POST['nom_ville'] ?? '';
    $services_selectionnes = $_POST['services'] ?? [];
    $nouveau_service_nom = trim($_POST['nouveau_service_nom'] ?? '');
    $nouveau_service_prix = $_POST['nouveau_service_prix'] ?? null;
    $nouveau_service_duree = $_POST['nouveau_service_duree'] ?? null;

    $agenda_json = json_encode(['lundi' => '9h-18h', 'mardi' => '9h-18h', 'mercredi' => '9h-18h', 'jeudi' => '9h-18h', 'vendredi' => '9h-18h', 'samedi' => '10h-17h', 'dimanche' => null]);
    
    // Vérifier si au moins un service est sélectionné ou un nouveau est renseigné
    if (empty($services_selectionnes) && empty($nouveau_service_nom)) {
        $message_statut = "Veuillez sélectionner au moins un service ou en ajouter un nouveau.";
        $message_type = "erreur";
        goto end_script;
    }

    // Début de la transaction
    $connexion->begin_transaction();
    
    try {
        // 1. Gérer la ville : trouver son ID ou l'insérer
        $ville_id = null;
        $stmt_ville = $connexion->prepare("SELECT ville_id FROM villes WHERE nom_ville = ?");
        $stmt_ville->bind_param("s", $nom_ville);
        $stmt_ville->execute();
        $resultat_ville = $stmt_ville->get_result();
        if ($resultat_ville->num_rows > 0) {
            $row = $resultat_ville->fetch_assoc();
            $ville_id = $row['ville_id'];
        } else {
            $stmt_insert_ville = $connexion->prepare("INSERT INTO villes (nom_ville) VALUES (?)");
            $stmt_insert_ville->bind_param("s", $nom_ville);
            $stmt_insert_ville->execute();
            $ville_id = $stmt_insert_ville->insert_id;
            $stmt_insert_ville->close();
        }
        $stmt_ville->close();

        // 2. Insérer le nouveau professionnel
        $sql_pro = "INSERT INTO professionnels (nom, adresse, telephone, email, agenda, notes, ville_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        $stmt_pro = $connexion->prepare($sql_pro);
        $stmt_pro->bind_param("ssssssi", $nom, $adresse, $telephone, $email, $agenda_json, $notes, $ville_id);
        $stmt_pro->execute();
        $professionnel_id = $stmt_pro->insert_id;
        $stmt_pro->close();

        // 3. Préparer les données de services pour l'insertion
        $services_a_inserer = [];

        // Ajouter les services existants sélectionnés
        foreach ($services_selectionnes as $service_id) {
            $prix = $_POST['prix'][$service_id] ?? null;
            $duree = $_POST['duree'][$service_id] ?? null;
            if ($prix !== null && $duree !== null) {
                $services_a_inserer[] = [
                    'service_id' => $service_id,
                    'prix' => $prix,
                    'duree' => $duree
                ];
            }
        }

        // Gérer le nouveau service s'il a été saisi
        if (!empty($nouveau_service_nom) && $nouveau_service_prix !== null && $nouveau_service_duree !== null) {
            $nouveau_service_id = null;
            $stmt_nouveau_service = $connexion->prepare("SELECT service_id FROM services WHERE nom_service = ?");
            $stmt_nouveau_service->bind_param("s", $nouveau_service_nom);
            $stmt_nouveau_service->execute();
            $resultat_nouveau_service = $stmt_nouveau_service->get_result();

            if ($resultat_nouveau_service->num_rows == 0) {
                // Le service n'existe pas, on l'insère
                $stmt_insert_service = $connexion->prepare("INSERT INTO services (nom_service) VALUES (?)");
                $stmt_insert_service->bind_param("s", $nouveau_service_nom);
                $stmt_insert_service->execute();
                $nouveau_service_id = $stmt_insert_service->insert_id;
                $stmt_insert_service->close();
            } else {
                // Le service existe déjà, on récupère son ID
                $row = $resultat_nouveau_service->fetch_assoc();
                $nouveau_service_id = $row['service_id'];
            }
            $stmt_nouveau_service->close();

            // Ajouter le nouveau service à la liste des services à insérer pour le professionnel
            $services_a_inserer[] = [
                'service_id' => $nouveau_service_id,
                'prix' => $nouveau_service_prix,
                'duree' => $nouveau_service_duree
            ];
        }

        // 4. Insérer tous les services associés dans la table 'professionnel_services'
        if (!empty($services_a_inserer)) {
            $sql_services_pro = "INSERT INTO professionnel_services (professionnel_id, service_id, prix, duree) VALUES (?, ?, ?, ?)";
            $stmt_services_pro = $connexion->prepare($sql_services_pro);
            
            foreach ($services_a_inserer as $service_data) {
                $service_id = $service_data['service_id'];
                $prix = $service_data['prix'];
                $duree = $service_data['duree'];
                $stmt_services_pro->bind_param("iidi", $professionnel_id, $service_id, $prix, $duree);
                $stmt_services_pro->execute();
            }
            $stmt_services_pro->close();
        }

        // Valider la transaction
        $connexion->commit();
        $message_statut = "Inscription réussie !";
        $message_type = "succes";

    } catch (Exception $e) {
        $connexion->rollback();
        $message_statut = "Erreur lors de l'inscription : " . $e->getMessage();
        $message_type = "erreur";
    }
}

end_script:

// Récupérer la liste des services pour le formulaire
$sql_services = "SELECT service_id, nom_service FROM services ORDER BY nom_service";
$resultat_services = $connexion->query($sql_services);
$services_disponibles = [];
if ($resultat_services && $resultat_services->num_rows > 0) {
    while($row = $resultat_services->fetch_assoc()) {
        $services_disponibles[] = $row;
    }
}
$connexion->close();
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription Professionnel</title>
    <style>
        body { font-family: sans-serif; background-color: #f0f4f8; margin: 0; padding: 20px; }
        .container { max-width: 700px; margin: 2rem auto; padding: 20px; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h1 { color: #118AB2; text-align: center; }
        label { display: block; margin-top: 15px; font-weight: bold; }
        input[type="text"], input[type="email"], textarea, input[type="number"] { width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .services-group { margin-top: 10px; }
        .service-item, .new-service-item { display: flex; align-items: center; margin-bottom: 5px; }
        .service-item label { margin-right: 10px; flex-grow: 1; }
        .service-item input[type="checkbox"] { margin-right: 5px; }
        .price-input, .duration-input, .new-service-input { width: 100px; margin-left: auto; }
        .new-service-input { flex-grow: 1; margin-right: 10px; }
        .new-service-item { margin-top: 20px; }
        button { width: 100%; padding: 10px; margin-top: 20px; background-color: #06D6A0; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        button:hover { background-color: #05C997; }
        .message-box { text-align: center; padding: 10px; border-radius: 4px; margin-top: 20px; }
        .message-box.succes { background-color: #e0f7e9; color: #2e7d32; }
        .message-box.erreur { background-color: #ffebee; color: #c62828; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Inscription Professionnel</h1>
        
        <?php if (!empty($message_statut)): ?>
            <div class="message-box <?php echo $message_type; ?>">
                <?php echo $message_statut; ?>
            </div>
        <?php endif; ?>

        <form id="pro-form" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
            <label for="nom">Nom :</label>
            <input type="text" id="nom" name="nom" required>

            <label for="adresse">Adresse :</label>
            <input type="text" id="adresse" name="adresse" required>

            <label for="nom_ville">Ville :</label>
            <input type="text" id="nom_ville" name="nom_ville" required>

            <label for="telephone">Téléphone :</label>
            <input type="text" id="telephone" name="telephone" required>

            <label for="email">Email :</label>
            <input type="email" id="email" name="email" required>

            <label for="notes">Notes/Description :</label>
            <textarea id="notes" name="notes" rows="4"></textarea>

            <label>Services offerts :</label>
            <div class="services-group">
                <?php if (!empty($services_disponibles)): ?>
                    <?php foreach ($services_disponibles as $service): ?>
                        <div class="service-item">
                            <input type="checkbox" id="service_<?php echo $service['service_id']; ?>" name="services[]" value="<?php echo $service['service_id']; ?>">
                            <label for="service_<?php echo $service['service_id']; ?>"><?php echo htmlspecialchars($service['nom_service']); ?></label>
                            <input type="number" placeholder="Prix (€)" name="prix[<?php echo $service['service_id']; ?>]" class="price-input" step="0.01">
                            <input type="number" placeholder="Durée (min)" name="duree[<?php echo $service['service_id']; ?>]" class="duration-input">
                        </div>
                    <?php endforeach; ?>
                <?php else: ?>
                    <p>Aucun service disponible. Vous pouvez en ajouter un ci-dessous.</p>
                <?php endif; ?>
            </div>

            <div class="new-service-item">
                <label for="nouveau_service_nom">Ajouter un nouveau service :</label>
                <input type="text" id="nouveau_service_nom" name="nouveau_service_nom" placeholder="Nom du service" class="new-service-input">
                <input type="number" placeholder="Prix (€)" name="nouveau_service_prix" step="0.01" class="price-input">
                <input type="number" placeholder="Durée (min)" name="nouveau_service_duree" class="duration-input">
            </div>

            <button type="submit">S'inscrire</button>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const form = document.getElementById('pro-form');
            const serviceItems = document.querySelectorAll('.service-item');
            const newServiceNom = document.getElementById('nouveau_service_nom');
            const newServicePrix = document.getElementsByName('nouveau_service_prix')[0];
            const newServiceDuree = document.getElementsByName('nouveau_service_duree')[0];

            serviceItems.forEach(item => {
                const checkbox = item.querySelector('input[type="checkbox"]');
                const prixInput = item.querySelector('.price-input');
                const dureeInput = item.querySelector('.duration-input');

                checkbox.addEventListener('change', (event) => {
                    if (event.target.checked) {
                        prixInput.setAttribute('required', 'required');
                        dureeInput.setAttribute('required', 'required');
                    } else {
                        prixInput.removeAttribute('required');
                        dureeInput.removeAttribute('required');
                    }
                });
            });

            // Validation minimale au niveau du formulaire
            form.addEventListener('submit', (event) => {
                const checkedServices = document.querySelectorAll('.service-item input[type="checkbox"]:checked');
                const isNewServiceFilled = newServiceNom.value.trim() !== '' && newServicePrix.value.trim() !== '' && newServiceDuree.value.trim() !== '';

                if (checkedServices.length === 0 && !isNewServiceFilled) {
                    alert('Veuillez sélectionner au moins un service ou en ajouter un nouveau.');
                    event.preventDefault();
                }
            });
        });
    </script>
</body>
</html>

		
	</main>
    <!-- Footer -->
    <?php include 'footer.php'; ?>
</body> 
</html>
	
	
	