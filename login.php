<?php
// Démarrer la session pour gérer les informations de l'utilisateur
session_start();

// Initialiser une variable pour les messages d'erreur
$error_message = '';

// Vérifier si le formulaire a été soumis
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Nettoyer et valider l'email
    $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);

    // Si l'email n'est pas valide, afficher une erreur
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error_message = "Veuillez entrer une adresse e-mail valide.";
    } else {
        // Paramètres de connexion à la base de données
        $servername = "mysql-abcrdv.alwaysdata.net";
        $username = "abcrdv";
        $password = "*E8D46CE25265E545D225A8A6F1BAF642FEBEE5CB"; // Le mot de passe n'a pas été fourni, veuillez le saisir ici.
        $dbname = "abcrdv_prd_db";

        try {
            // Connexion à la base de données avec PDO
            $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
            $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            // Préparer la requête pour vérifier l'email dans la table 'professionnels'
            $stmt = $conn->prepare("SELECT professionnel_id, nom FROM professionnels WHERE email = :email");
            $stmt->bindParam(':email', $email);
            $stmt->execute();
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            // Si l'email est trouvé dans la table 'professionnels'
            if ($user) {
                // Définir les variables de session pour l'utilisateur professionnel
                $_SESSION['user_type'] = 'professionnel';
                $_SESSION['user_id'] = $user['professionnel_id'];
                $_SESSION['user_name'] = $user['nom'];
                header("Location: dashboardPro.php"); // Rediriger vers le tableau de bord
                exit();
            }

            // Si l'email n'est pas trouvé, vérifier dans la table 'clients'
            $stmt = $conn->prepare("SELECT client_id, nom FROM clients WHERE email = :email");
            $stmt->bindParam(':email', $email);
            $stmt->execute();
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            // Si l'email est trouvé dans la table 'clients'
            if ($user) {
                // Définir les variables de session pour l'utilisateur client
                $_SESSION['user_type'] = 'client';
                $_SESSION['user_id'] = $user['client_id'];
                $_SESSION['user_name'] = $user['nom'];
                header("Location: dashboardClient.php"); // Rediriger vers le tableau de bord
                exit();
            }

            // Si l'email n'est trouvé dans aucune des tables
            $error_message = "Adresse e-mail ($email) non reconnue. Veuillez vérifier votre saisie.";

        } catch (PDOException $e) {
            $error_message = "Erreur de connexion à la base de données : " . $e->getMessage();
        }
    }
}
?>
<!DOCTYPE html>
<html lang="fr">
<!-- Head -->
<?php include 'head.php'; ?>
<body>
    <!-- Header -->
	<?php include 'header.php'; ?>
    <main role="main">
        <div>
            <h3>Le système détecte automatiquement si vous êtes un professionnels ou un clients.<br>
            <!-- Formulaire de connexion -->
			<div class="login-container">
				<form action="login.php" method="post">
					<input type="email" name="email" placeholder="Insérez votre mail" required>
					<button type="submit">Se connecter</button>
				</form>
			</div>
            
			<!-- Afficher le message d'erreur s'il existe -->
            <?php if (!empty($error_message)): ?>
                <div class="pty20 no-results"><?= htmlspecialchars($error_message); ?></div>
            <?php endif; ?>
			
        </div>
    </main>
    <!-- Footer -->
    <?php include 'footer.php'; ?>
</body>
</html>
