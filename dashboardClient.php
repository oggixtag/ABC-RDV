<?php
// Démarrer la session
session_start();

// Vérifier si l'utilisateur est connecté et est un client
if (!isset($_SESSION['user_type']) || $_SESSION['user_type'] !== 'client') {
    header("Location: login.php");
    exit();
}

$nom_client = $_SESSION['user_name'];
$client_id = $_SESSION['user_id'];

// Inclure la connexion à la base de données
$servername = "mysql-abcrdv.alwaysdata.net";
$username = "abcrdv";
$password = "*E8D46CE25265E545D225A8A6F1BAF642FEBEE5CB"; // Le mot de passe n'a pas été fourni, veuillez le saisir ici.
$dbname = "abcrdv_prd_db";

try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // --- LOGIQUE DE SUPPRESSION AVEC MISE À JOUR DE L'AGENDA ---
    if (isset($_POST['reservation_id'])) {
        $reservation_id = intval($_POST['reservation_id']);

        // Démarre une transaction pour garantir la cohérence des données
        $conn->beginTransaction();

        try {
            // 1. Récupérer l'agenda_id et l'heure de la réservation à supprimer
            $stmt_select = $conn->prepare("
                SELECT r.agenda_id, a.*
                FROM reservations r
                JOIN agendas a ON r.agenda_id = a.agenda_id
                WHERE r.reservation_id = :res_id AND r.client_id = :client_id
            ");
            $stmt_select->bindParam(':res_id', $reservation_id, PDO::PARAM_INT);
            $stmt_select->bindParam(':client_id', $client_id, PDO::PARAM_INT);
            $stmt_select->execute();
            $reservation_info = $stmt_select->fetch(PDO::FETCH_ASSOC);

            if ($reservation_info) {
                $agenda_id = $reservation_info['agenda_id'];
                $heure_col = '';
                // Chercher l'heure du rendez-vous
                for ($h = 8; $h <= 18; $h++) {
                    $heure_key = 'heure_' . sprintf('%02d', $h) . 'h';
                    if ($reservation_info[$heure_key] == 0) {
                        $heure_col = $heure_key;
                        break;
                    }
                }

                if ($heure_col) {
                    // 2. Mettre à jour l'agenda pour rendre le créneau disponible
                    $stmt_update = $conn->prepare("UPDATE agendas SET `{$heure_col}` = 1 WHERE agenda_id = :agenda_id");
                    $stmt_update->bindParam(':agenda_id', $agenda_id, PDO::PARAM_INT);
                    $stmt_update->execute();

                    // 3. Supprimer la réservation
                    $stmt_delete = $conn->prepare("DELETE FROM reservations WHERE reservation_id = :res_id AND client_id = :client_id");
                    $stmt_delete->bindParam(':res_id', $reservation_id, PDO::PARAM_INT);
                    $stmt_delete->bindParam(':client_id', $client_id, PDO::PARAM_INT);
                    $stmt_delete->execute();

                    // Valider la transaction
                    $conn->commit();
                    header("Location: dashboardClient.php?message=success");
                    exit();
                } else {
                    // Si le créneau n'est pas trouvé, annuler la transaction
                    $conn->rollBack();
                    header("Location: dashboardClient.php?message=error");
                    exit();
                }
            } else {
                // Si la réservation n'est pas trouvée (ou n'appartient pas à l'utilisateur), annuler la transaction
                $conn->rollBack();
                header("Location: dashboardClient.php?message=error");
                exit();
            }
        } catch (PDOException $e) {
            // Annuler la transaction en cas d'erreur
            $conn->rollBack();
            header("Location: dashboardClient.php?message=error");
            exit();
        }
    }

    // Récupérer les informations du client
    $stmt = $conn->prepare("SELECT * FROM clients WHERE client_id = :id");
    $stmt->bindParam(':id', $client_id);
    $stmt->execute();
    $client_info = $stmt->fetch(PDO::FETCH_ASSOC);

    // Récupérer les réservations pour ce client en joignant la table agendas
    $stmt_reservations = $conn->prepare("
        SELECT
            r.reservation_id,
            r.date_creation,
            a.heure_08h, a.heure_09h, a.heure_10h, a.heure_11h, a.heure_12h,
            a.heure_13h, a.heure_14h, a.heure_15h, a.heure_16h, a.heure_17h, a.heure_18h,
            p.nom AS nom_professionnel,
            s.nom_service,
            a.date as date_rdv
        FROM reservations r
        JOIN professionnels p ON r.professionnel_id = p.professionnel_id
        JOIN services s ON r.service_id = s.service_id
        JOIN agendas a ON r.agenda_id = a.agenda_id
        WHERE r.client_id = :id
        ORDER BY a.date DESC, r.date_creation DESC
    ");
    $stmt_reservations->bindParam(':id', $client_id);
    $stmt_reservations->execute();
    $reservations = $stmt_reservations->fetchAll(PDO::FETCH_ASSOC);

} catch (PDOException $e) {
    echo "Erreur de connexion à la base de données : " . $e->getMessage();
}
?>
<!DOCTYPE html>
<html lang="fr">
<!-- Head -->
<?php include 'head.php'; ?>
<body>
    <!-- Header -->
    <?php include 'header.php'; ?>
    <!-- Main page vous êtes coiffeur-->
    <main role="main">
        <div>
            <h2>Informations du Profil</h2>
            <?php if ($client_info): ?>
                <p><strong>Nom :</strong> <?= htmlspecialchars($client_info['nom']); ?></p>
                <p><strong>Email :</strong> <?= htmlspecialchars($client_info['email']); ?></p>
            <?php else: ?>
                <p>Impossible de charger les informations du client.</p>
            <?php endif; ?>

            <h2>Vos Rendez-vous</h2>
            <?php if (isset($_GET['message']) && $_GET['message'] == 'success'): ?>
                <p style="color: green;">Le rendez-vous a été annulé avec succès.</p>
            <?php endif; ?>
            <?php if (isset($_GET['message']) && $_GET['message'] == 'error'): ?>
                <p style="color: red;">Une erreur est survenue lors de l'annulation.</p>
            <?php endif; ?>

            <?php if (!empty($reservations)): ?>
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Heure</th>
                            <th>Professionnel</th>
                            <th>Service</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($reservations as $res): ?>
                            <tr>
                                <td><?= htmlspecialchars($res['date_rdv']); ?></td>
                                <?php
                                    $heure_rdv_display = 'N/A';
                                    // On boucle de 8h à 18h pour trouver l'heure du rendez-vous
                                    for ($h = 8; $h <= 18; $h++) {
                                        $heure_col = 'heure_' . sprintf('%02d', $h) . 'h';
                                        // Si la colonne pour cette heure est égale à 0, c'est que le créneau est pris
                                        if (isset($res[$heure_col]) && $res[$heure_col] == 0) {
                                            $heure_rdv_display = sprintf('%02d', $h) . ':00';
                                            break;
                                        }
                                    }
                                ?>
                                <td><?= htmlspecialchars($heure_rdv_display); ?></td>
                                <td><?= htmlspecialchars($res['nom_professionnel']); ?></td>
                                <td><?= htmlspecialchars($res['nom_service']); ?></td>
                                <td>
                                    <!-- Formulaire pour la suppression -->
                                    <form action="dashboardClient.php" method="post" onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer ce rendez-vous ?');">
                                        <input type="hidden" name="reservation_id" value="<?= htmlspecialchars($res['reservation_id']); ?>">
                                        <button type="submit" style="background-color: #e74c3c; color: white; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer;">Supprimer</button>
                                    </form>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            <?php else: ?>
                <p>Vous n'avez pas encore de réservations.</p>
            <?php endif; ?>
            
        </div>
        <div style="margin-top: 2em;">
            <a href="logout.php" style="padding: 10px 20px; background-color: #2c3e50; color: white; border-radius: 5px; text-decoration: none;">Se déconnecter</a>
        </div>
    </main>

    <!-- Footer -->
    <?php include 'footer.php'; ?>
</body>
</html>
