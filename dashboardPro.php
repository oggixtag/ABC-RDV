<?php
// Démarrer la session
session_start();

// Vérifier si l'utilisateur est connecté et est un professionnel
if (!isset($_SESSION['user_type']) || $_SESSION['user_type'] !== 'professionnel') {
    header("Location: login.php");
    exit();
}

$nom_professionnel = $_SESSION['user_name'];
$professionnel_id = $_SESSION['user_id'];

// Inclure la connexion à la base de données
$servername = "mysql-abcrdv.alwaysdata.net";
$username = "abcrdv";
$password = "*E8D46CE25265E545D225A8A6F1BAF642FEBEE5CB";
$dbname = "abcrdv_prd_db";

$success_message = '';
$error_message = '';
$conn = null;

try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // GESTION DE LA MISE À JOUR DU PROFIL
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['update_profile'])) {
        $new_nom = htmlspecialchars($_POST['nom'] ?? '');
        $new_adresse = htmlspecialchars($_POST['adresse'] ?? '');
        $new_telephone = htmlspecialchars($_POST['telephone'] ?? '');
        $new_notes = htmlspecialchars($_POST['notes'] ?? '');
        
        $stmt_update = $conn->prepare("UPDATE abcrdv_prd_db.professionnels SET nom = :nom, adresse = :adresse, telephone = :telephone, notes = :notes WHERE professionnel_id = :id");
        $stmt_update->bindParam(':nom', $new_nom);
        $stmt_update->bindParam(':adresse', $new_adresse);
        $stmt_update->bindParam(':telephone', $new_telephone);
        $stmt_update->bindParam(':notes', $new_notes);
        $stmt_update->bindParam(':id', $professionnel_id);
        
        if ($stmt_update->execute()) {
            $success_message = "Votre profil a été mis à jour avec succès.";
        } else {
            $error_message = "Une erreur est survenue lors de la mise à jour.";
        }
    }

    // GESTION DES PRESTATIONS
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Ajouter une prestation
        if (isset($_POST['add_prestation'])) {
            $nom_service = htmlspecialchars($_POST['nom_service'] ?? '');
            $prix = floatval($_POST['prix'] ?? 0);
            $duree = intval($_POST['duree'] ?? 0);

            if (!empty($nom_service) && $prix > 0 && $duree > 0) {
                try {
                    // Démarrer une transaction
                    $conn->beginTransaction();
                    // Vérifier si le service existe déjà
                    $stmt_check_service = $conn->prepare("SELECT service_id FROM services WHERE nom_service = :nom_service");
                    $stmt_check_service->bindParam(':nom_service', $nom_service);
                    $stmt_check_service->execute();
                    $service = $stmt_check_service->fetch(PDO::FETCH_ASSOC);

                    if ($service) {
                        $service_id = $service['service_id'];
                    } else {
                        // Ajouter le service à la table services s'il n'existe pas
                        $stmt_add_service = $conn->prepare("INSERT INTO abcrdv_prd_db.services (nom_service) VALUES (:nom_service)");
                        $stmt_add_service->bindParam(':nom_service', $nom_service);
                        $stmt_add_service->execute();
                        $service_id = $conn->lastInsertId();
                    }

                    // Insérer le service dans la table de liaison professionnel_services
                    $stmt_add_pro_service = $conn->prepare("INSERT INTO abcrdv_prd_db.professionnel_services (professionnel_id, service_id, prix, duree) VALUES (:pro_id, :service_id, :prix, :duree)");
                    $stmt_add_pro_service->bindParam(':pro_id', $professionnel_id);
                    $stmt_add_pro_service->bindParam(':service_id', $service_id);
                    $stmt_add_pro_service->bindParam(':prix', $prix);
                    $stmt_add_pro_service->bindParam(':duree', $duree);
                    $stmt_add_pro_service->execute();

                    $conn->commit();
                    $success_message = "La prestation a été ajoutée avec succès.";

                } catch (PDOException $e) {
                    $conn->rollBack();
                    $error_message = "Erreur lors de l'ajout de la prestation : " . $e->getMessage();
                }
            } else {
                $error_message = "Veuillez remplir tous les champs correctement.";
            }
        }
        // Modifier une prestation
        if (isset($_POST['edit_prestation'])) {
            $service_id_to_edit = $_POST['service_id_edit'] ?? null;
            $new_nom_service = htmlspecialchars($_POST['nom_service_edit'] ?? '');
            $new_prix = floatval($_POST['prix_edit'] ?? 0);
            $new_duree = intval($_POST['duree_edit'] ?? 0);

            if ($service_id_to_edit && !empty($new_nom_service) && $new_prix > 0 && $new_duree > 0) {
                try {
                    $conn->beginTransaction();

                    // Mettre à jour le nom du service dans la table 'services'
                    $stmt_update_service_name = $conn->prepare("UPDATE abcrdv_prd_db.services SET nom_service = :nom WHERE service_id = :id");
                    $stmt_update_service_name->bindParam(':nom', $new_nom_service);
                    $stmt_update_service_name->bindParam(':id', $service_id_to_edit);
                    $stmt_update_service_name->execute();
                    
                    // Mettre à jour les informations dans la table de liaison 'professionnel_services'
                    $stmt_update_pro_service = $conn->prepare("UPDATE abcrdv_prd_db.professionnel_services SET prix = :prix, duree = :duree WHERE professionnel_id = :pro_id AND service_id = :service_id");
                    $stmt_update_pro_service->bindParam(':prix', $new_prix);
                    $stmt_update_pro_service->bindParam(':duree', $new_duree);
                    $stmt_update_pro_service->bindParam(':pro_id', $professionnel_id);
                    $stmt_update_pro_service->bindParam(':service_id', $service_id_to_edit);
                    $stmt_update_pro_service->execute();

                    $conn->commit();
                    $success_message = "La prestation a été mise à jour avec succès.";
                } catch (PDOException $e) {
                    $conn->rollBack();
                    $error_message = "Erreur lors de la mise à jour de la prestation : " . $e->getMessage();
                }
            } else {
                $error_message = "Les informations de la prestation à modifier sont incomplètes.";
            }
        }
        // Supprimer une prestation
        if (isset($_POST['delete_prestation'])) {
            $service_id_to_delete = $_POST['service_id_delete'] ?? null;
            if ($service_id_to_delete) {
                // Supprimer l'entrée dans la table de liaison
                $stmt_delete_prestation = $conn->prepare("DELETE FROM professionnel_services WHERE service_id = :id AND professionnel_id = :pro_id");
                $stmt_delete_prestation->bindParam(':id', $service_id_to_delete);
                $stmt_delete_prestation->bindParam(':pro_id', $professionnel_id);
                if ($stmt_delete_prestation->execute()) {
                    $success_message = "La prestation a été supprimée avec succès.";
                } else {
                    $error_message = "Une erreur est survenue lors de la suppression de la prestation.";
                }
            }
        }
        // GESTION DE LA SUPPRESSION D'UN RENDEZ-VOUS
        if (isset($_POST['delete_reservation_id'])) {
            $reservation_id = $_POST['delete_reservation_id'];
            try {
                $conn->beginTransaction();
                // 1. Récupérer les informations du rendez-vous à supprimer
                $stmt_get_reservation = $conn->prepare("SELECT agenda_id FROM abcrdv_prd_db.reservations WHERE reservation_id = :id AND professionnel_id = :pro_id");
                $stmt_get_reservation->bindParam(':id', $reservation_id);
                $stmt_get_reservation->bindParam(':pro_id', $professionnel_id);
                $stmt_get_reservation->execute();
                $reservation_info = $stmt_get_reservation->fetch(PDO::FETCH_ASSOC);

                if ($reservation_info) {
                    $agenda_id = $reservation_info['agenda_id'];

                    // 2. Trouver l'heure du rendez-vous dans l'agenda pour la libérer
                    $stmt_get_agenda = $conn->prepare("SELECT * FROM abcrdv_prd_db.agendas WHERE agenda_id = :id");
                    $stmt_get_agenda->bindParam(':id', $agenda_id);
                    $stmt_get_agenda->execute();
                    $agenda_info = $stmt_get_agenda->fetch(PDO::FETCH_ASSOC);

                    if ($agenda_info) {
                        $heure_to_free = '';
                        for ($h = 8; $h <= 18; $h++) {
                            $heure_col = 'heure_' . sprintf('%02d', $h) . 'h';
                            if (isset($agenda_info[$heure_col]) && $agenda_info[$heure_col] == 0) {
                                $heure_to_free = $heure_col;
                                break;
                            }
                        }

                        // 3. Mettre à jour l'agenda pour libérer le créneau
                        if (!empty($heure_to_free)) {
                            $stmt_free_slot = $conn->prepare("UPDATE abcrdv_prd_db.agendas SET $heure_to_free = 1 WHERE agenda_id = :id");
                            $stmt_free_slot->bindParam(':id', $agenda_id);
                            $stmt_free_slot->execute();
                        }
                    }

                    // 4. Supprimer le rendez-vous de la table des réservations
                    $stmt_delete_res = $conn->prepare("DELETE FROM reservations WHERE reservation_id = :id");
                    $stmt_delete_res->bindParam(':id', $reservation_id);
                    $stmt_delete_res->execute();

                    $conn->commit();
                    $success_message = "Le rendez-vous a été supprimé avec succès.";
                } else {
                    $error_message = "Rendez-vous non trouvé ou vous n'êtes pas autorisé à le supprimer.";
                }
            } catch (PDOException $e) {
                $conn->rollBack();
                $error_message = "Erreur lors de la suppression du rendez-vous : " . $e->getMessage();
            }
        }
        // GESTION DE LA MODIFICATION D'UN RENDEZ-VOUS
        if (isset($_POST['edit_reservation_id'])) {
            $reservation_id = $_POST['edit_reservation_id'];
            $new_service_id = $_POST['new_service_id'];
            $new_member_id = $_POST['new_member_id'];
            $new_date = $_POST['new_date'];
            $new_hour = $_POST['new_hour'];

            try {
                $conn->beginTransaction();
				
                // 1. Récupérer l'ancien agenda pour libérer le créneau
                $stmt_get_old_res = $conn->prepare("SELECT agenda_id FROM abcrdv_prd_db.reservations WHERE reservation_id = :id");
                $stmt_get_old_res->bindParam(':id', $reservation_id);
                $stmt_get_old_res->execute();
                $old_agenda_id = $stmt_get_old_res->fetchColumn();

                $stmt_get_old_agenda = $conn->prepare("SELECT * FROM abcrdv_prd_db.agendas WHERE agenda_id = :id");
                $stmt_get_old_agenda->bindParam(':id', $old_agenda_id);
                $stmt_get_old_agenda->execute();
                $old_agenda_info = $stmt_get_old_agenda->fetch(PDO::FETCH_ASSOC);

                $old_hour_col = '';
                if ($old_agenda_info) {
                    for ($h = 8; $h <= 18; $h++) {
                        $heure_col = 'heure_' . sprintf('%02d', $h) . 'h';
                        if (isset($old_agenda_info[$heure_col]) && $old_agenda_info[$heure_col] == 0) {
                            $old_hour_col = $heure_col;
                            break;
                        }
                    }
                    if (!empty($old_hour_col)) {
                        $stmt_free_slot = $conn->prepare("UPDATE abcrdv_prd_db.agendas SET $old_hour_col = 1 WHERE agenda_id = :id");
                        $stmt_free_slot->bindParam(':id', $old_agenda_id);
                        $stmt_free_slot->execute();
                    }
                }

                // 2. Trouver ou créer le nouvel agenda et le nouveau créneau
                $stmt_get_new_agenda = $conn->prepare("SELECT agenda_id FROM abcrdv_prd_db.agendas WHERE membre_id = :membre_id AND date = :date");
                $stmt_get_new_agenda->bindParam(':membre_id', $new_member_id);
                $stmt_get_new_agenda->bindParam(':date', $new_date);
                $stmt_get_new_agenda->execute();
                $new_agenda_id = $stmt_get_new_agenda->fetchColumn();

                if (!$new_agenda_id) {
                    $stmt_create_new_agenda = $conn->prepare("INSERT INTO abcrdv_prd_db.agendas (membre_id, date) VALUES (:membre_id, :date)");
                    $stmt_create_new_agenda->bindParam(':membre_id', $new_member_id);
                    $stmt_create_new_agenda->bindParam(':date', $new_date);
                    $stmt_create_new_agenda->execute();
                    $new_agenda_id = $conn->lastInsertId();
                }

                $new_hour_col = 'heure_' . sprintf('%02d', intval($new_hour)) . 'h';
                $stmt_book_slot = $conn->prepare("UPDATE abcrdv_prd_db.agendas SET $new_hour_col = 0 WHERE agenda_id = :id");
                $stmt_book_slot->bindParam(':id', $new_agenda_id);
                $stmt_book_slot->execute();

                // 3. Mettre à jour la réservation
                $stmt_update_res = $conn->prepare("UPDATE abcrdv_prd_db.reservations SET service_id = :service_id, membre_id = :membre_id, agenda_id = :agenda_id WHERE reservation_id = :id");
                $stmt_update_res->bindParam(':service_id', $new_service_id);
                $stmt_update_res->bindParam(':membre_id', $new_member_id);
                $stmt_update_res->bindParam(':agenda_id', $new_agenda_id);
                $stmt_update_res->bindParam(':id', $reservation_id);
                $stmt_update_res->execute();

                $conn->commit();
                $success_message = "Le rendez-vous a été mis à jour avec succès.";

            } catch (PDOException $e) {
                $conn->rollBack();
                $error_message = "Erreur lors de la mise à jour du rendez-vous : " . $e->getMessage();
            }
        }
    }

    // GESTION DES MEMBRES DE L'ÉQUIPE
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Ajouter un membre
        if (isset($_POST['add_member'])) {
            $new_member_name = htmlspecialchars($_POST['nom_membre'] ?? '');
            if (!empty($new_member_name)) {
				
				try {
					// Démarre une transaction pour garantir que l'ajout du membre et la création de l'agenda sont atomiques
					$conn->beginTransaction();
					
					// Vérifier si le membre existe déjà
					$stmt_check_membre = $conn->prepare("SELECT membre_id FROM abcrdv_prd_db.membres_equipe WHERE nom_membre = :nom_membre");
					$stmt_check_membre->bindParam(':nom_membre', $new_member_name);
					$stmt_check_membre->execute();
					$membre = $stmt_check_membre->fetch(PDO::FETCH_ASSOC);
					
					if ($membre) {
						$membre_id = $membre['membre_id'];
					} else {
						// Ajouter le membre s'il n'existe pas
						$stmt_add_member = $conn->prepare("INSERT INTO abcrdv_prd_db.membres_equipe (nom_membre, professionnel_id) VALUES (:nom, :pro_id)");
						$stmt_add_member->bindParam(':nom', $new_member_name);
						$stmt_add_member->bindParam(':pro_id', $professionnel_id);
						$stmt_add_member->execute();
						// Récupérer l'ID du membre nouvellement inséré
						$membre_id = $conn->lastInsertId();
					}
					
					// Insérer le membre dans la table de liaison agendas
					// 2. Créer l'agenda pour les 3 prochains mois pour ce nouveau membre
					$start_date = new DateTime();
					$end_date = new DateTime('+3 months');
					$interval = new DateInterval('P1D');
					$period = new DatePeriod($start_date, $interval, $end_date);

					foreach ($period as $date) {
						$day_of_week = $date->format('N'); // 1 (lundi) à 7 (dimanche)
						
						// On ne gère que les jours de la semaine (lundi à vendredi)
						if ($day_of_week >= 1 && $day_of_week <= 5) {
							$date_formattee = $date->format('Y-m-d');
							
							// Préparer la requête d'insertion pour l'agenda
							$stmt_agenda = $conn->prepare("INSERT INTO abcrdv_prd_db.agendas (membre_id, date, heure_08h, heure_09h, heure_10h, heure_11h, heure_12h, heure_13h, heure_14h, heure_15h, heure_16h, heure_17h, heure_18h) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
							
							// Exécuter la requête, en mettant toutes les heures de 8h à 18h à 1 (disponible)
							$stmt_agenda->execute([
								$membre_id, 
								$date_formattee,
								1, // heure_08h
								1, // heure_09h
								1, // heure_10h
								1, // heure_11h
								1, // heure_12h
								1, // heure_13h
								1, // heure_14h
								1, // heure_15h
								1, // heure_16h
								1, // heure_17h
								1  // heure_18h
							]);
						}
					}
					
					// Valider la transaction si tout s'est bien passé
					$conn->commit();
					$success_message = "Membre de l'équipe et son agenda ajoutés avec succès.";
					
				} catch (PDOException $e){
					$conn->rollBack();
					$error_message = "Erreur lors de l'ajout du membre de l'équipe : " . $e->getMessage();
				}
				
				

            } else {
                $error_message = "Le nom du membre ne peut pas être vide.";
            }
        }
        // Modifier un membre
        if (isset($_POST['edit_member'])) {
            $membre_id_to_edit = $_POST['membre_id_edit'] ?? null;
            $new_member_name = htmlspecialchars($_POST['nom_membre_edit'] ?? '');
            if ($membre_id_to_edit && !empty($new_member_name)) {
                $stmt_edit_member = $conn->prepare("UPDATE abcrdv_prd_db.membres_equipe SET nom_membre = :nom WHERE membre_id = :id AND professionnel_id = :pro_id");
                $stmt_edit_member->bindParam(':nom', $new_member_name);
                $stmt_edit_member->bindParam(':id', $membre_id_to_edit);
                $stmt_edit_member->bindParam(':pro_id', $professionnel_id);
                if ($stmt_edit_member->execute()) {
                    $success_message = "Le membre de l'équipe a été mis à jour avec succès.";
                } else {
                    $error_message = "Une erreur est survenue lors de la mise à jour du membre.";
                }
            } else {
                $error_message = "Les informations du membre à modifier sont incomplètes.";
            }
        }
        // Supprimer un membre
        if (isset($_POST['delete_member'])) {
            $membre_id_to_delete = $_POST['membre_id_delete'] ?? null;
            if ($membre_id_to_delete) {

                //$stmt_delete_member = $conn->prepare("DELETE FROM membres_equipe WHERE membre_id = :id AND professionnel_id = :pro_id");
                //$stmt_delete_member->bindParam(':id', $membre_id_to_delete);
                //$stmt_delete_member->bindParam(':pro_id', $professionnel_id);
                //if ($stmt_delete_member->execute()) {
                //    $success_message = "Le membre de l'équipe a été supprimé avec succès.";
                //} else {
                //    $error_message = "Une erreur est survenue lors de la suppression du membre.";
                //}

				try {
					$conn->beginTransaction();

					// Supprimer d'abord les réservations liées à ce membre
					$stmt_reservations = $conn->prepare("DELETE FROM reservations WHERE membre_id = ?");
					$stmt_reservations->execute([$membre_id_to_delete]);

					// Supprimer ensuite les agendas du membre
					$stmt_agendas = $conn->prepare("DELETE FROM agendas WHERE membre_id = ?");
					$stmt_agendas->execute([$membre_id_to_delete]);

					// Supprimer enfin le membre
					$stmt_membre = $conn->prepare("DELETE FROM membres_equipe WHERE membre_id = ? AND professionnel_id = ?");
					$stmt_membre->execute([$membre_id_to_delete, $professionnel_id]);

					$conn->commit();
					$success_message = "Membre de l'équipe supprimé avec succès.";
				} catch (Exception $e) {
					$conn->rollBack();
					$error_message = "Erreur lors de la suppression du membre : " . $e->getMessage();
				}
				
            }
        }
    }
	
    // Récupérer les informations du professionnel (les plus récentes si une mise à jour a eu lieu)
    $stmt = $conn->prepare("SELECT * FROM abcrdv_prd_db.professionnels WHERE professionnel_id = :id");
    $stmt->bindParam(':id', $professionnel_id);
    $stmt->execute();
    $professionnel_info = $stmt->fetch(PDO::FETCH_ASSOC);

    // Récupérer les prestations du professionnel
    $stmt_services = $conn->prepare("
        SELECT ps.service_id, s.nom_service, ps.prix, ps.duree
        FROM abcrdv_prd_db.professionnel_services ps
        JOIN abcrdv_prd_db.services s ON ps.service_id = s.service_id
        WHERE ps.professionnel_id = :id
        ORDER BY s.nom_service ASC
    ");
    $stmt_services->bindParam(':id', $professionnel_id);
    $stmt_services->execute();
    $prestations = $stmt_services->fetchAll(PDO::FETCH_ASSOC);

    // Récupérer les membres de l'équipe
    $stmt_members = $conn->prepare("SELECT * FROM abcrdv_prd_db.membres_equipe WHERE professionnel_id = :id ORDER BY nom_membre ASC");
    $stmt_members->bindParam(':id', $professionnel_id);
    $stmt_members->execute();
    $members = $stmt_members->fetchAll(PDO::FETCH_ASSOC);

    // Récupérer les réservations pour ce professionnel en joignant la table agendas
    $stmt_reservations = $conn->prepare("
        SELECT
            r.reservation_id,
            c.nom AS nom_client,
            s.service_id,
            s.nom_service,
            me.membre_id,
            me.nom_membre AS nom_membre_equipe,
            a.date as date_rdv,
            a.agenda_id,
            a.heure_08h, a.heure_09h, a.heure_10h, a.heure_11h, a.heure_12h,
            a.heure_13h, a.heure_14h, a.heure_15h, a.heure_16h, a.heure_17h, a.heure_18h
        FROM abcrdv_prd_db.reservations r
        JOIN abcrdv_prd_db.clients c ON r.client_id = c.client_id
        JOIN abcrdv_prd_db.services s ON r.service_id = s.service_id
        JOIN abcrdv_prd_db.membres_equipe me ON r.membre_id = me.membre_id
        JOIN abcrdv_prd_db.agendas a ON r.agenda_id = a.agenda_id
        WHERE r.professionnel_id = :id
		and (a.heure_08h=0 or a.heure_09h=0 or a.heure_10h=0 or a.heure_11h=0 or a.heure_12h=0 or a.heure_13h=0 or a.heure_14h=0 or a.heure_15h=0 or a.heure_16h=0 or a.heure_17h=0 or a.heure_18h=0)
        ORDER BY me.nom_membre, a.date ASC
    ");
    $stmt_reservations->bindParam(':id', $professionnel_id);
    $stmt_reservations->execute();
    $reservations = $stmt_reservations->fetchAll(PDO::FETCH_ASSOC);
    
    // Organiser les réservations par membre de l'équipe
    $reservations_by_member = [];
    foreach ($reservations as $reservation) {
        $member_name = $reservation['nom_membre_equipe'];
        if (!isset($reservations_by_member[$member_name])) {
            $reservations_by_member[$member_name] = [];
        }
        $reservations_by_member[$member_name][] = $reservation;
    }

    // Récupérer les agendas pour les 7 prochains jours
    $stmt_agendas = $conn->prepare("
		select a.* 
		from agendas a
		join (
			SELECT m.membre_id,m.nom_membre
			FROM abcrdv_prd_db.professionnels p 
			JOIN abcrdv_prd_db.membres_equipe m on p.professionnel_id = m.professionnel_id
			where p.professionnel_id = :id ) me
		on a.membre_id = me.membre_id
		where 1=1
		AND date >= CURDATE() AND date < CURDATE() + INTERVAL 7 DAY 
		ORDER BY date ASC, membre_id ASC
    ");
    $stmt_agendas->bindParam(':id', $professionnel_id);
    $stmt_agendas->execute();
    $agendas = $stmt_agendas->fetchAll(PDO::FETCH_ASSOC);
    $agendas_by_member_date = [];
    foreach ($agendas as $agenda) {
        $agendas_by_member_date[$agenda['membre_id']][$agenda['date']] = $agenda;
    }

} catch (PDOException $e) {
    $error_message = "Erreur de connexion à la base de données : " . $e->getMessage();
}
?>
<!DOCTYPE html>
<html lang="fr">
<!-- Head -->
<?php include 'head.php'; ?>
<style>

body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; }
.profile-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}
.btn-edit {
    padding: 8px 16px;
    background-color: #3498db;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
    transition: background-color 0.3s ease;
}
.btn-edit:hover {
    background-color: #2980b9;
}
.btn-cancel {
    padding: 8px 16px;
    background-color: #95a5a6;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
    transition: background-color 0.3s ease;
}
.btn-cancel:hover {
    background-color: #7f8c8d;
}
.profile-view, .profile-edit-form, .members-section, .services-section {
    background-color: #f9f9f9;
    padding: 2em;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    margin-top: 2em;
}
.profile-edit-form {
    display: none; /* Cache le formulaire par défaut */
}
.form-group {
    margin-bottom: 1.5em;
}
.form-group label {
    display: block;
    margin-bottom: 0.5em;
    font-weight: bold;
    color: #333;
}
.form-group input, .form-group textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
    font-size: 16px;
}
.btn-save, .btn-add, .btn-delete {
    background-color: #27ae60;
    color: white;
    padding: 12px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
    transition: background-color 0.3s ease;
}
.btn-save:hover, .btn-add:hover {
    background-color: #219d54;
}
.btn-delete {
    background-color: #e74c3c;
    padding: 8px 16px;
    font-size: 14px;
}
.btn-delete:hover {
    background-color: #c0392b;
}
.btn-edit-member, .btn-edit-prestation, .btn-edit-reservation {
    background-color: #3498db;
    padding: 8px 16px;
    font-size: 14px;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}
.btn-edit-member:hover, .btn-edit-prestation:hover, .btn-edit-reservation:hover {
    background-color: #2980b9;
}
.message {
    padding: 1em;
    margin-bottom: 1em;
    border-radius: 4px;
    font-weight: bold;
}
.message-success {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}
.message-error {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 2em;
}
th, td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
}
th {
    background-color: #f2f2f2;
}
/* Styles pour la modale */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0,0,0,0.4);
    justify-content: center;
    align-items: center;
}
.modal-content {
    background-color: #fefefe;
    margin: auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
    max-width: 500px;
    border-radius: 8px;
    text-align: center;
}
.close-btn {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}
.close-btn:hover, .close-btn:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}
/* Styles du nouveau tableau d'agenda */
.agenda-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 1em;
    background-color: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    overflow: hidden;
}
.agenda-table th, .agenda-table td {
    border: 1px solid #e0e0e0;
    padding: 10px;
    text-align: center;
}
.agenda-table th {
    background-color: #f7f7f7;
    font-weight: bold;
}
.agenda-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px;
    background-color: #f0f0f0;
    border-radius: 8px;
    margin-bottom: 10px;
}
.agenda-header button {
    background: none;
    border: none;
    font-size: 24px;
    cursor: pointer;
}
.agenda-slot-cell {
    cursor: pointer;
    transition: background-color 0.2s ease;
}
.agenda-slot-cell.available {
    background-color: #e8f5e9; /* Vert clair */
}
.agenda-slot-cell.available:hover {
    background-color: #c8e6c9; /* Vert un peu plus foncé */
}
.agenda-slot-cell.booked {
    background-color: #ffebee; /* Rouge clair */
    cursor: not-allowed;
    color: #b71c1c;
}
.agenda-slot-cell.selected {
    background-color: #4CAF50 !important; /* Vert plus foncé pour la sélection */
    color: white;
}
</style>
<body>
    <!-- Header -->
    <?php include 'header.php'; ?>
    <!-- Main page pour les professionnels -->
    <main role="main">
        <div>
            <div class="profile-header">
                <h2>Informations du Profil</h2>
                <button id="editBtn" class="btn-edit">Modifier les informations</button>
            </div>

            <?php if (!empty($success_message)): ?>
                <div class="message message-success"><?= htmlspecialchars($success_message) ?></div>
            <?php endif; ?>
            <?php if (!empty($error_message)): ?>
                <div class="message message-error"><?= htmlspecialchars($error_message) ?></div>
            <?php endif; ?>

            <?php if ($professionnel_info): ?>
                <!-- Vue des informations du profil (par défaut) -->
                <div id="profile-view" class="profile-view">
                    <p><strong>Nom :</strong> <?= htmlspecialchars($professionnel_info['nom']); ?></p>
                    <p><strong>Adresse :</strong> <?= htmlspecialchars($professionnel_info['adresse']); ?></p>
                    <p><strong>Téléphone :</strong> <?= htmlspecialchars($professionnel_info['telephone']); ?></p>
                    <p><strong>Email :</strong> <?= htmlspecialchars($professionnel_info['email']); ?></p>
                    <p><strong>Notes :</strong> <?= htmlspecialchars($professionnel_info['notes']); ?></p>
                </div>

                <!-- Formulaire de modification du profil (caché par défaut) -->
                <div id="profile-edit-form" class="profile-edit-form">
                    <form method="POST">
                        <input type="hidden" name="update_profile" value="1">
                        <div class="form-group">
                            <label for="nom">Nom :</label>
                            <input type="text" id="nom" name="nom" value="<?= htmlspecialchars($professionnel_info['nom']); ?>" required>
                        </div>
                        <div class="form-group">
                            <label for="adresse">Adresse :</label>
                            <input type="text" id="adresse" name="adresse" value="<?= htmlspecialchars($professionnel_info['adresse']); ?>">
                        </div>
                        <div class="form-group">
                            <label for="telephone">Téléphone :</label>
                            <input type="text" id="telephone" name="telephone" value="<?= htmlspecialchars($professionnel_info['telephone']); ?>">
                        </div>
                        <p><strong>Email :</strong> <?= htmlspecialchars($professionnel_info['email']); ?></p>
                        <div class="form-group">
                            <label for="notes">Notes :</label>
                            <textarea id="notes" name="notes"><?= htmlspecialchars($professionnel_info['notes']); ?></textarea>
                        </div>
                        <button type="submit" class="btn-save">Enregistrer les modifications</button>
                        <button type="button" id="cancelBtn" class="btn-cancel">Annuler</button>
                    </form>
                </div>

                <script>
                    document.getElementById('editBtn').addEventListener('click', function() {
                        document.getElementById('profile-view').style.display = 'none';
                        document.getElementById('profile-edit-form').style.display = 'block';
                    });
                    document.getElementById('cancelBtn').addEventListener('click', function() {
                        document.getElementById('profile-view').style.display = 'block';
                        document.getElementById('profile-edit-form').style.display = 'none';
                    });
                </script>
            <?php else: ?>
                <p>Impossible de charger les informations du professionnel.</p>
            <?php endif; ?>

            <h2 style="margin-top: 2em;">Gérer vos prestations</h2>
            <div class="services-section">
                <!-- Formulaire d'ajout d'une prestation -->
                <h3>Ajouter une nouvelle prestation</h3>
                <form method="POST" style="margin-bottom: 2em;">
                    <input type="hidden" name="add_prestation" value="1">
                    <div class="form-group" style="display: flex; flex-direction:column; gap: 10px; align-items: flex-start;">
                        <div >
                            <label for="nom_service">Nom de la prestation</label>
                            <input type="text" id="nom_service" name="nom_service" placeholder="Ex: Coupe de cheveux" required>
                        </div>
                        <div>
                            <label for="prix">Prix (€)</label>
                            <input type="number" id="prix" name="prix" placeholder="Ex: 25.00" step="0.01" required>
                        </div>
                        <div>
                            <label for="duree">Durée (minutes)</label>
                            <input type="number" id="duree" name="duree" placeholder="Ex: 60" required>
                        </div>
                        <button type="submit" class="btn-add" style="flex-shrink: 0;">Ajouter</button>
                    </div>
                </form>

                <!-- Tableau des prestations existantes -->
                <h3>Prestations existantes</h3>
                <?php if (!empty($prestations)): ?>
                    <table>
                        <thead>
                            <tr>
                                <th>Nom de la prestation</th>
                                <th>Prix</th>
                                <th>Durée (min)</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($prestations as $prestation): ?>
                                <tr>
                                    <td><?= htmlspecialchars($prestation['nom_service']); ?></td>
                                    <td><?= htmlspecialchars(number_format($prestation['prix'], 2)); ?> €</td>
                                    <td><?= htmlspecialchars($prestation['duree']); ?></td>
                                    <td>
                                        <form method="POST" style="display: inline-block;">
                                            <input type="hidden" name="delete_prestation" value="1">
                                            <input type="hidden" name="service_id_delete" value="<?= htmlspecialchars($prestation['service_id']); ?>">
                                            <button type="button" class="btn-delete" onclick="showModal('Êtes-vous sûr de vouloir supprimer cette prestation ?', () => this.closest('form').submit());">Supprimer</button>
                                        </form>
                                        <button type="button" class="btn-edit-prestation" onclick="toggleEditPrestationForm(<?= htmlspecialchars($prestation['service_id']); ?>)">Modifier</button>
                                        <div id="edit-prestation-form-<?= htmlspecialchars($prestation['service_id']); ?>" style="display: none; margin-top: 1em;">
                                            <form method="POST">
                                                <input type="hidden" name="edit_prestation" value="1">
                                                <input type="hidden" name="service_id_edit" value="<?= htmlspecialchars($prestation['service_id']); ?>">
                                                <div class="form-group" style="display: flex; gap: 10px;">
                                                    <input type="text" name="nom_service_edit" value="<?= htmlspecialchars($prestation['nom_service']); ?>" required>
                                                    <input type="number" name="prix_edit" value="<?= htmlspecialchars($prestation['prix']); ?>" step="0.01" required>
                                                    <input type="number" name="duree_edit" value="<?= htmlspecialchars($prestation['duree']); ?>" required>
                                                    <button type="submit" class="btn-save">Enregistrer</button>
                                                </div>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                    <script>
                        function toggleEditPrestationForm(serviceId) {
                            const form = document.getElementById(`edit-prestation-form-${serviceId}`);
                            if (form.style.display === 'none') {
                                form.style.display = 'block';
                            } else {
                                form.style.display = 'none';
                            }
                        }
                    </script>
                <?php else: ?>
                    <p>Aucune prestation n'a encore été ajoutée.</p>
                <?php endif; ?>
            </div>

            <h2 style="margin-top: 2em;">Gérer vos équipes</h2>
            <div class="members-section">
                <!-- Formulaire d'ajout de membre -->
                <h3>Ajouter un nouveau membre</h3>
                <form method="POST" style="margin-bottom: 2em;">
                    <input type="hidden" name="add_member" value="1">
                    <div class="form-group" style="display: flex; gap: 10px;">
                        <input type="text" name="nom_membre" placeholder="Nom du membre de l'équipe" required>
                        <button type="submit" class="btn-add">Ajouter</button>
                    </div>
                </form>

                <!-- Tableau des membres existants -->
                <h3>Membres existants</h3>
                <?php if (!empty($members)): ?>
                    <table>
                        <thead>
                            <tr>
                                <th>Nom du membre</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($members as $member): ?>
                                <tr>
                                    <td><?= htmlspecialchars($member['nom_membre']); ?></td>
                                    <td>
                                        <form method="POST" style="display: inline-block;">
                                            <input type="hidden" name="delete_member" value="1">
                                            <input type="hidden" name="membre_id_delete" value="<?= htmlspecialchars($member['membre_id']); ?>">
                                            <button type="button" class="btn-delete" onclick="showModal('Êtes-vous sûr de vouloir supprimer ce membre ?', () => this.closest('form').submit());">Supprimer</button>
                                        </form>
                                        <!-- Formulaire de modification (initialement caché) -->
                                        <button type="button" class="btn-edit-member" onclick="toggleEditForm(<?= htmlspecialchars($member['membre_id']); ?>)">Modifier</button>
                                        <div id="edit-form-<?= htmlspecialchars($member['membre_id']); ?>" style="display: none; margin-top: 1em;">
                                            <form method="POST">
                                                <input type="hidden" name="edit_member" value="1">
                                                <input type="hidden" name="membre_id_edit" value="<?= htmlspecialchars($member['membre_id']); ?>">
                                                <div class="form-group" style="display: flex; gap: 10px;">
                                                    <input type="text" name="nom_membre_edit" value="<?= htmlspecialchars($member['nom_membre']); ?>" required>
                                                    <button type="submit" class="btn-save">Enregistrer</button>
                                                </div>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                    <script>
                        function toggleEditForm(memberId) {
                            const form = document.getElementById(`edit-form-${memberId}`);
                            if (form.style.display === 'none') {
                                form.style.display = 'block';
                            } else {
                                form.style.display = 'none';
                            }
                        }
                    </script>
                <?php else: ?>
                    <p>Aucun membre d'équipe n'a encore été ajouté.</p>
                <?php endif; ?>
            </div>

            <h2>Vos Rendez-vous</h2>
            <?php if (!empty($members)): ?>
                <?php foreach ($members as $member): ?>
                    <h3>Rendez-vous de <?= htmlspecialchars($member['nom_membre']); ?></h3>
                    <?php 
                        $member_name = $member['nom_membre'];
                        if (isset($reservations_by_member[$member_name]) && !empty($reservations_by_member[$member_name])):
                    ?>
                        <table>
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Heure</th>
                                    <th>Client</th>
                                    <th>Service</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($reservations_by_member[$member_name] as $res): ?>
                                    <tr>
                                        <td><?= htmlspecialchars($res['date_rdv']); ?></td>
                                        <?php
                                            $heure_rdv_display = 'N/A';
                                            $booked_hour = null;
                                            // On boucle de 8h à 18h pour trouver l'heure du rendez-vous
                                            for ($h = 8; $h <= 18; $h++) {
                                                $heure_col = 'heure_' . sprintf('%02d', $h) . 'h';
                                                // Si la colonne pour cette heure est égale à 0, c'est que le créneau est pris
                                                if (isset($res[$heure_col]) && $res[$heure_col] == 0) {
                                                    $heure_rdv_display = sprintf('%02d', $h) . ':00';
                                                    $booked_hour = sprintf('%02d', $h);
                                                    break;
                                                }
                                            }
                                        ?>
                                        <td><?= htmlspecialchars($heure_rdv_display); ?></td>
                                        <td><?= htmlspecialchars($res['nom_client']); ?></td>
                                        <td><?= htmlspecialchars($res['nom_service']); ?></td>
                                        <td>
                                            <form method="POST" style="display: inline-block;">
                                                <input type="hidden" name="delete_reservation_id" value="<?= htmlspecialchars($res['reservation_id']); ?>">
                                                <button type="button" class="btn-delete" onclick="showModal('Êtes-vous sûr de vouloir supprimer ce rendez-vous ?', () => this.closest('form').submit());">Supprimer</button>
                                            </form>
                                            <button type="button" class="btn-edit-reservation" onclick="toggleEditReservationForm(
                                                '<?= htmlspecialchars($res['reservation_id']); ?>', 
                                                '<?= htmlspecialchars($res['service_id']); ?>', 
                                                '<?= htmlspecialchars($res['membre_id']); ?>', 
                                                '<?= htmlspecialchars($res['date_rdv']); ?>',
                                                '<?= htmlspecialchars($booked_hour); ?>'
                                            )">Modifier</button>
                                        </td>
                                    </tr>
                                    <!-- Formulaire de modification pour ce rendez-vous (initialement caché) -->
                                    <tr id="edit-reservation-form-row-<?= htmlspecialchars($res['reservation_id']); ?>" style="display:none;">
                                        <td colspan="5">
                                            <div class="edit-reservation-form">
                                                <form id="form-<?= htmlspecialchars($res['reservation_id']); ?>" method="POST">
                                                    <input type="hidden" name="edit_reservation_id" value="<?= htmlspecialchars($res['reservation_id']); ?>">
                                                    <input type="hidden" id="new_member_id_<?= htmlspecialchars($res['reservation_id']); ?>" name="new_member_id">
                                                    <input type="hidden" id="new_date_<?= htmlspecialchars($res['reservation_id']); ?>" name="new_date">
                                                    <input type="hidden" id="new_hour_<?= htmlspecialchars($res['reservation_id']); ?>" name="new_hour">
                                                    
                                                    <h4>Modifier la prestation</h4>
                                                    <div style="display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 1em;">
                                                        <?php foreach ($prestations as $prestation_option): ?>
                                                            <div style="display:flex; align-items:center; gap:5px;">
                                                                <input type="radio" id="prestation_<?= htmlspecialchars($res['reservation_id']); ?>_<?= htmlspecialchars($prestation_option['service_id']); ?>" name="new_service_id" value="<?= htmlspecialchars($prestation_option['service_id']); ?>" 
                                                                    <?= ($prestation_option['service_id'] == $res['service_id']) ? 'checked' : ''; ?>>
                                                                <label for="prestation_<?= htmlspecialchars($res['reservation_id']); ?>_<?= htmlspecialchars($prestation_option['service_id']); ?>"><?= htmlspecialchars($prestation_option['nom_service']); ?></label>
                                                            </div>
                                                        <?php endforeach; ?>
                                                    </div>

                                                    <h4>Modifier l'agenda</h4>
                                                    <div style="margin-bottom: 1em;">
                                                        <label for="select_member_<?= htmlspecialchars($res['reservation_id']); ?>">Sélectionner un membre d'équipe :</label>
                                                        <select id="select_member_<?= htmlspecialchars($res['reservation_id']); ?>" onchange="displayAgenda(this.value, '<?= htmlspecialchars($res['reservation_id']); ?>')">
                                                            <?php foreach ($members as $member_option): ?>
                                                                <option value="<?= htmlspecialchars($member_option['membre_id']); ?>" <?= ($member_option['membre_id'] == $res['membre_id']) ? 'selected' : ''; ?>>
                                                                    <?= htmlspecialchars($member_option['nom_membre']); ?>
                                                                </option>
                                                            <?php endforeach; ?>
                                                        </select>
                                                    </div>
                                                    
                                                    <div id="agenda-container-<?= htmlspecialchars($res['reservation_id']); ?>"></div>

                                                    <button type="submit" class="btn-save" style="margin-top: 1em;">Enregistrer les modifications</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    <?php else: ?>
                        <p>Ce membre n'a pas de rendez-vous en agenda.</p>
                    <?php endif; ?>
                <?php endforeach; ?>
            <?php else: ?>
                <p>Vous n'avez pas encore de réservations.</p>
            <?php endif; ?>

        </div>

    </main>

    <!-- Modale de confirmation -->
    <div id="confirmModal" class="modal">
        <div class="modal-content">
            <span class="close-btn">&times;</span>
            <p id="modalMessage"></p>
            <button id="modalConfirmBtn" class="btn-delete">Confirmer</button>
            <button id="modalCancelBtn" class="btn-cancel">Annuler</button>
        </div>
    </div>

    <!-- Footer -->
    <?php include 'footer.php'; ?>
    
    <script>
        // Fonctions pour la modale personnalisée
        const confirmModal = document.getElementById('confirmModal');
        const modalMessage = document.getElementById('modalMessage');
        const modalConfirmBtn = document.getElementById('modalConfirmBtn');
        const modalCancelBtn = document.getElementById('modalCancelBtn');
        const closeModalBtn = document.querySelector('.close-btn');

        let confirmAction = null;

        function showModal(message, action) {
            modalMessage.textContent = message;
            confirmAction = action;
            confirmModal.style.display = 'flex';
        }

        closeModalBtn.onclick = function() {
            confirmModal.style.display = 'none';
        }

        modalCancelBtn.onclick = function() {
            confirmModal.style.display = 'none';
        }

        modalConfirmBtn.onclick = function() {
            if (confirmAction) {
                confirmAction();
            }
            confirmModal.style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target == confirmModal) {
                confirmModal.style.display = 'none';
            }
        }

        // Données d'agenda récupérées de PHP
        const agendas_data = <?= json_encode($agendas_by_member_date); ?>;
        const members_data = <?= json_encode($members); ?>;
        const timeSlots = ["08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18"];
        const daysOfWeek = ["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"]; // Ajusté pour le dimanche en premier

        function getNextSevenDays() {
            const days = [];
            const today = new Date();
            for (let i = 0; i < 7; i++) {
                const date = new Date(today);
                date.setDate(today.getDate() + i);
                days.push({
                    fullDate: date.toISOString().slice(0, 10),
                    dayName: daysOfWeek[date.getDay()],
                    dayOfMonth: date.getDate()
                });
            }
            return days;
        }

        // Fonction pour afficher le formulaire de modification
        function toggleEditReservationForm(reservationId, serviceId, memberId, date, hour) {
            const formRow = document.getElementById(`edit-reservation-form-row-${reservationId}`);
            if (formRow.style.display === 'none') {
                formRow.style.display = 'table-row';
                // Afficher l'agenda par défaut pour le membre sélectionné
                displayAgenda(memberId, reservationId, date, hour);
            } else {
                formRow.style.display = 'none';
            }
        }

        // Fonction pour générer et afficher l'agenda
        function displayAgenda(memberId, reservationId, originalDate = null, originalHour = null) {
            const container = document.getElementById(`agenda-container-${reservationId}`);
            container.innerHTML = '';
            
            const days = getNextSevenDays();
            
            const table = document.createElement('table');
            table.className = 'agenda-table';

            // Création de l'en-tête du tableau (Jours)
            const thead = table.createTHead();
            const headerRow = thead.insertRow();
            headerRow.innerHTML = '<th>Heure</th>';
            days.forEach(day => {
                const th = document.createElement('th');
                th.textContent = `${day.dayName} ${day.dayOfMonth}`;
                headerRow.appendChild(th);
            });

            // Création du corps du tableau (Créneaux)
            const tbody = table.createTBody();
            timeSlots.forEach(hour => {
                const row = tbody.insertRow();
                const hourCell = row.insertCell();
                hourCell.textContent = `${hour}:00`;
                hourCell.style.fontWeight = 'bold';

                days.forEach(day => {
                    const slotCell = row.insertCell();
                    slotCell.className = 'agenda-slot-cell';
                    
                    const memberAgenda = agendas_data[memberId] || {};
                    const dayAgenda = memberAgenda[day.fullDate] || {};
                    const isBooked = dayAgenda[`heure_${hour}h`] === 0;
                    
                    const isOriginalSlot = (originalDate === day.fullDate && originalHour === hour && memberId == document.getElementById(`select_member_${reservationId}`).value);

                    if (isBooked && !isOriginalSlot) {
                        slotCell.classList.add('booked');
                        slotCell.textContent = `${hour}:00`;
                    } else {
                        slotCell.classList.add('available');
                        slotCell.textContent = `${hour}:00`;
                        slotCell.onclick = () => selectSlot(reservationId, memberId, day.fullDate, hour, slotCell);
                    }
                    
                    if (isOriginalSlot) {
                        slotCell.classList.add('selected');
                        slotCell.textContent = `${hour}:00 (actuel)`;
                    }
                });
            });

            container.appendChild(table);
        }

        // Fonction pour sélectionner un créneau et mettre à jour les champs du formulaire
        function selectSlot(reservationId, memberId, date, hour, cell) {
            const form = document.getElementById(`form-${reservationId}`);
            document.getElementById(`new_member_id_${reservationId}`).value = memberId;
            document.getElementById(`new_date_${reservationId}`).value = date;
            document.getElementById(`new_hour_${reservationId}`).value = hour;

            // Retirer la classe 'selected' de tous les autres créneaux du même formulaire
            const allSlots = form.querySelectorAll('.agenda-slot-cell');
            allSlots.forEach(slot => {
                slot.classList.remove('selected');
                if (slot.textContent.includes('(actuel)')) {
                    slot.textContent = slot.textContent.replace(' (actuel)', '');
                }
            });

            // Ajouter la classe 'selected' au créneau cliqué
            cell.classList.add('selected');
        }
    </script>
</body>
</html>
