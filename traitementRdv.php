<?php
// Inclusion des fichiers d'en-tête, de navigation et de pied de page pour la cohérence de la mise en page
include 'head.php';
include 'header.php';
include 'navigation.php';
?>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f9;
        color: #333;
        margin: 0;
        padding: 0;
    }
    .container {
        max-width: 700px;
        margin: 40px auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }
    .recap-section {
        border-bottom: 1px solid #ddd;
        padding-bottom: 20px;
        margin-bottom: 20px;
    }
    .recap-section h2 {
        font-size: 1.5em;
        font-weight: bold;
        margin-bottom: 10px;
        color: #444;
    }
    .recap-section p {
        margin: 5px 0;
        font-size: 1em;
    }
    .recap-section p strong {
        color: #000;
    }
    .recap-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .recap-list li {
        margin-bottom: 5px;
    }
    .recap-list li strong {
        display: inline-block;
        width: 100px; /* Aligner les étiquettes */
    }
    .button-confirm {
        display: block;
        width: 100%;
        padding: 12px;
        font-size: 1.1em;
        font-weight: bold;
        color: #fff;
        background-color: #007bff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s ease;
        text-align: center;
        margin-top: 20px;
    }
    .button-confirm:hover {
        background-color: #0056b3;
    }
    .success-message, .error-message {
        padding: 20px;
        border-radius: 8px;
        text-align: center;
        font-size: 1.2em;
        font-weight: bold;
    }
    .success-message {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }
    .error-message {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
</style>
<main>
    <div class="container">
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

        // Vérifier si la requête est bien une méthode POST
        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            // Récupération et validation des données du formulaire
            $professionnel_id = $_POST['professionnel_id'] ?? null;
            $service_id       = $_POST['service_id'] ?? null;
            $membre_id        = $_POST['membre_id'] ?? null;
            $date_rdv         = $_POST['date_rdv'] ?? null;
            $heure_rdv        = $_POST['heure_rdv'] ?? null;
            $client_nom       = $_POST['client_nom'] ?? null;
            $client_email     = $_POST['client_email'] ?? null;
            $action           = $_POST['action'] ?? 'recap'; // Champ pour déterminer l'étape

            // Vérification que toutes les données obligatoires sont présentes
            if ($professionnel_id && $service_id && $membre_id && $date_rdv && $heure_rdv && $client_nom && $client_email) {
                if ($action == 'confirm') {
                    // --- Étape 2 : Confirmation et enregistrement en base de données ---
                    try {
                        // Démarrage d'une transaction pour garantir l'atomicité des opérations
                        $connexion->begin_transaction();

                        // Étape 1 : Gérer l'enregistrement du client
                        $sql_client_check = "SELECT client_id FROM abc_rdv_prd_db.clients WHERE email = ?";
                        $stmt_client_check = $connexion->prepare($sql_client_check);
                        $stmt_client_check->bind_param("s", $client_email);
                        $stmt_client_check->execute();
                        $result_client = $stmt_client_check->get_result();
                        $client_row = $result_client->fetch_assoc();

                        if ($client_row) {
                            $client_id = $client_row['client_id'];
                        } else {
                            $sql_client_insert = "INSERT INTO abc_rdv_prd_db.clients (nom, email) VALUES (?, ?)";
                            $stmt_client_insert = $connexion->prepare($sql_client_insert);
                            $stmt_client_insert->bind_param("ss", $client_nom, $client_email);
                            $stmt_client_insert->execute();
                            $client_id = $connexion->insert_id;
                        }

                        // Étape 2 : Récupérer l'agenda_id
                        $sql_agenda_id = "SELECT agenda_id FROM abc_rdv_prd_db.agendas WHERE membre_id = ? AND date = ?";
                        $stmt_agenda = $connexion->prepare($sql_agenda_id);
                        $stmt_agenda->bind_param("is", $membre_id, $date_rdv);
                        $stmt_agenda->execute();
                        $result_agenda = $stmt_agenda->get_result();
                        $agenda_row = $result_agenda->fetch_assoc();

                        if (!$agenda_row) {
                            throw new Exception("Erreur : Créneau de l'agenda introuvable pour la date et le membre sélectionnés.");
                        }
                        $agenda_id = $agenda_row['agenda_id'];

                        // Étape 3 : Insérer la réservation
                        $sql_reservation_insert = "INSERT INTO abc_rdv_prd_db.reservations (client_id, professionnel_id, membre_id, service_id, agenda_id, heure_rdv) VALUES (?, ?, ?, ?, ?, ?)";
                        $stmt_reservation = $connexion->prepare($sql_reservation_insert);
                        $stmt_reservation->bind_param("iiiiss", $client_id, $professionnel_id, $membre_id, $service_id, $agenda_id, $heure_rdv);
                        $stmt_reservation->execute();

                        // Étape 4 : Mettre à jour l'agenda (marquer comme indisponible)
                        $heure_colonne = "heure_" . substr(str_replace(":", "h", $heure_rdv), 0, 3);
                        $sql_update_agenda = "UPDATE abc_rdv_prd_db.agendas SET `$heure_colonne` = 0 WHERE agenda_id = ?";
                        $stmt_update_agenda = $connexion->prepare($sql_update_agenda);
                        $stmt_update_agenda->bind_param("i", $agenda_id);
                        $stmt_update_agenda->execute();

                        // Si tout est bon, on valide la transaction
                        $connexion->commit();
                        
                        echo "<div class='success-message'>Votre rendez-vous a été confirmé avec succès. Merci !</div>";
                    } catch (Exception $e) {
                        // En cas d'erreur, annuler la transaction
                        $connexion->rollback();
                        echo "<div class='error-message'>Une erreur est survenue lors de l'enregistrement de votre rendez-vous. Veuillez réessayer plus tard.</div>";
                        echo "<p>Détails : " . htmlspecialchars($e->getMessage()) . "</p>";
                    }
                } else {
                    // --- Étape 1 : Affichage du récapitulatif pour validation ---
                    // Préparer les requêtes pour récupérer les noms pour l'affichage
                    $sql_display = "
                        SELECT
                            p.nom AS nom_pro, p.adresse,
                            s.nom_service,
                            m.nom_membre
                        FROM abc_rdv_prd_db.professionnels p
                        JOIN abc_rdv_prd_db.services s ON s.service_id = ?
                        JOIN abc_rdv_prd_db.membres_equipe m ON m.membre_id = ?
                        WHERE p.professionnel_id = ?
                    ";
                    $stmt_display = $connexion->prepare($sql_display);
                    $stmt_display->bind_param("iii", $service_id, $membre_id, $professionnel_id);
                    $stmt_display->execute();
                    $result_display = $stmt_display->get_result();
                    $details = $result_display->fetch_assoc();
                    $stmt_display->close();

                    if (!$details) {
                        echo "<div class='error-message'>Erreur : Impossible de trouver les informations pour la réservation.</div>";
                    } else {
                        ?>
                        <div class="container">
                            <h1 style="text-align: center; font-size: 2em; margin-bottom: 20px;">Récapitulatif de votre rendez-vous</h1>
                            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="POST">
                                <div class="recap-section">
                                    <h2>1. Prestation sélectionnée</h2>
                                    <p><strong>Service :</strong> <?php echo htmlspecialchars($details['nom_service']); ?></p>
                                    <p><strong>Professionnel :</strong> <?php echo htmlspecialchars($details['nom_membre']); ?></p>
                                </div>
                                <div class="recap-section">
                                    <h2>2. Date et heure sélectionnée</h2>
                                    <p><strong>Date :</strong> <?php echo htmlspecialchars($date_rdv); ?></p>
                                    <p><strong>Heure :</strong> <?php echo htmlspecialchars($heure_rdv); ?></p>
                                </div>
                                <div class="recap-section">
                                    <h2>3. Votre identification</h2>
                                    <p><strong>Nom :</strong> <?php echo htmlspecialchars($client_nom); ?></p>
                                    <p><strong>Email :</strong> <?php echo htmlspecialchars($client_email); ?></p>
                                </div>
                                
                                <!-- Informations sur le professionnel -->
                                <div class="recap-section">
                                    <h2>Informations du cabinet</h2>
                                    <p><strong>Nom :</strong> <?php echo htmlspecialchars($details['nom_pro']); ?></p>
                                    <p><strong>Adresse :</strong> <?php echo htmlspecialchars($details['adresse']); ?></p>
                                </div>

                                <!-- Champs cachés pour passer les données à la prochaine étape -->
                                <input type="hidden" name="professionnel_id" value="<?php echo htmlspecialchars($professionnel_id); ?>">
                                <input type="hidden" name="service_id" value="<?php echo htmlspecialchars($service_id); ?>">
                                <input type="hidden" name="membre_id" value="<?php echo htmlspecialchars($membre_id); ?>">
                                <input type="hidden" name="date_rdv" value="<?php echo htmlspecialchars($date_rdv); ?>">
                                <input type="hidden" name="heure_rdv" value="<?php echo htmlspecialchars($heure_rdv); ?>">
                                <input type="hidden" name="client_nom" value="<?php echo htmlspecialchars($client_nom); ?>">
                                <input type="hidden" name="client_email" value="<?php echo htmlspecialchars($client_email); ?>">
                                <input type="hidden" name="action" value="confirm">

                                <button type="submit" class="button-confirm">Confirmer le rendez-vous</button>
                            </form>
                        </div>
                        <?php
                    }
                }
            } else {
                echo "<p class='error-message'>Erreur : Toutes les informations requises n'ont pas été fournies.</p>";
            }
        } else {
            echo "<p class='error-message'>Accès invalide à cette page. Veuillez passer par le formulaire de prise de rendez-vous.</p>";
        }

        // Fermeture de la connexion à la base de données
        $connexion->close();
        ?>
    </div>
</main>
<?php include 'footer.php'; ?>
