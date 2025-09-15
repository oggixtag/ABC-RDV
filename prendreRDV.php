<!DOCTYPE html>
<html lang="fr">
<!-- Head -->
<?php include 'head.php'; ?>
<style>
    /* Styles pour mettre en évidence le service sélectionné */
    .service-item.selected {
        background-color: #e0f7fa;
        border: 2px solid #00bcd4;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    .hidden-services {
        display: none;
    }
    .membre-selection label {
        display: block;
        margin-bottom: 10px;
    }
    .membre-selection input[type="radio"] {
        margin-right: 10px;
    }
    .agenda-container {
        margin-top: 20px;
    }
    .calendar-navigation {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
    }
    .calendar-navigation button {
        background-color: transparent;
        border: none;
        cursor: pointer;
        font-size: 1.5rem;
    }
    .calendar-navigation h4 {
        margin: 0;
    }
    .calendar-grid {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 5px;
        text-align: center;
        overflow-x: auto; /* Permet le défilement si l'écran est trop petit */
    }
    .day-column {
        display: flex;
        flex-direction: column;
        border-right: 1px solid #ccc;
    }
    .day-column:last-child {
        border-right: none;
    }
    .calendar-day-header {
        font-weight: bold;
        padding-bottom: 5px;
        margin-bottom: 10px;
    }
    .time-slot {
        padding: 10px 0;
        border: 1px solid transparent;
        border-radius: 5px;
        margin-bottom: 5px;
        cursor: pointer;
    }
    .time-slot.available {
        background-color: #f1f8e9;
        border: 1px solid #c8e6c9;
    }
    .time-slot.selected-time {
        background-color: #00bcd4;
        color: white;
        border: 1px solid #00838f;
    }
    .time-slot.unavailable {
        background-color: #ffcdd2;
        cursor: not-allowed;
    }
</style>
<body>
    <!-- Header -->
    <?php include 'header.php'; ?>
    <!-- Navigation Menu -->
    <?php include 'navigation.php'; ?>
    <!-- Main page Je prend RDV-->
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

            // Récupération des données passées par la méthode POST
            if ($_SERVER["REQUEST_METHOD"] == "POST") {
                $professionnel_id = $_POST['professionnel_id'] ?? null;
                $service_id_initial = $_POST['service_id'] ?? null; // ID du service sélectionné initialement

                if ($professionnel_id) {
                    
                    // 1. Récupérer les informations du professionnel
                    $sql_pro = "SELECT nom FROM abc_rdv_prd_db.professionnels WHERE professionnel_id = ?";
                    $stmt_pro = $connexion->prepare($sql_pro);
                    $stmt_pro->bind_param("i", $professionnel_id);
                    $stmt_pro->execute();
                    $result_pro = $stmt_pro->get_result();
                    $professionnel = $result_pro->fetch_assoc();
                    $stmt_pro->close();

                    // 2. Récupérer le service initialement sélectionné et tous les services
                    $service_initial = null;
                    $services_all = [];
                    $sql_initial = "SELECT s.service_id, s.nom_service, s.description, ps.prix, ps.duree
                                     FROM abc_rdv_prd_db.professionnel_services ps
                                     JOIN abc_rdv_prd_db.services s ON s.service_id = ps.service_id
                                     WHERE ps.professionnel_id = ?";
                    $stmt_services = $connexion->prepare($sql_initial);
                    $stmt_services->bind_param("i", $professionnel_id);
                    $stmt_services->execute();
                    $result_services = $stmt_services->get_result();
                    while ($row = $result_services->fetch_assoc()) {
                        if ($row['service_id'] == $service_id_initial) {
                            $service_initial = $row;
                        }
                        $services_all[] = $row;
                    }
                    $stmt_services->close();
                    
                    // 3. Récupérer les membres de l'équipe du professionnel
                    $membres_equipe = [];
                    $sql_membres = "SELECT membre_id, nom_membre FROM abc_rdv_prd_db.membres_equipe WHERE professionnel_id = ?";
                    $stmt_membres = $connexion->prepare($sql_membres);
                    $stmt_membres->bind_param("i", $professionnel_id);
                    $stmt_membres->execute();
                    $result_membres = $stmt_membres->get_result();
                    $membres_equipe = $result_membres->fetch_all(MYSQLI_ASSOC);
                    $stmt_membres->close();

                    // 4. Récupérer les disponibilités réelles des membres depuis la table 'agendas'
                    $disponibilites = [];
                    // Pour éviter les erreurs si la liste des membres est vide
                    if (!empty($membres_equipe)) {
                        $membre_ids = array_column($membres_equipe, 'membre_id');
                        $placeholders = implode(',', array_fill(0, count($membre_ids), '?'));
                        
                        $sql_dispos = "SELECT membre_id, date, heure_08h, heure_09h, heure_10h, heure_11h, heure_12h, heure_13h, heure_14h, heure_15h, heure_16h, heure_17h, heure_18h FROM abc_rdv_prd_db.agendas WHERE membre_id IN ($placeholders)";
                        $stmt_dispos = $connexion->prepare($sql_dispos);
                        $types = str_repeat('i', count($membre_ids));
                        $stmt_dispos->bind_param($types, ...$membre_ids);
                        $stmt_dispos->execute();
                        $result_dispos = $stmt_dispos->get_result();

                        // Tableau de correspondance entre les colonnes et les heures
                        $heures_map = [
                            'heure_08h' => '08:00',
                            'heure_09h' => '09:00',
                            'heure_10h' => '10:00',
                            'heure_11h' => '11:00',
                            'heure_12h' => '12:00',
                            'heure_13h' => '13:00',
                            'heure_14h' => '14:00',
                            'heure_15h' => '15:00',
                            'heure_16h' => '16:00',
                            'heure_17h' => '17:00',
                            'heure_18h' => '18:00',
                        ];
                        
                        while ($row = $result_dispos->fetch_assoc()) {
                            $membre_id = $row['membre_id'];
                            $date = $row['date'];
                            
                            // Si le membre ou la date n'existent pas dans le tableau de disponibilités, on les initialise
                            if (!isset($disponibilites[$membre_id])) {
                                $disponibilites[$membre_id] = [];
                            }
                            if (!isset($disponibilites[$membre_id][$date])) {
                                $disponibilites[$membre_id][$date] = [];
                            }
                            
                            // On parcourt chaque colonne d'heure pour vérifier la disponibilité
                            foreach ($heures_map as $colonne => $heure) {
                                // Si la colonne est à 1 (disponible), on ajoute l'heure au tableau
                                if ($row[$colonne] == 1) {
                                    $disponibilites[$membre_id][$date][] = $heure;
                                }
                            }
                        }
                        $stmt_dispos->close();
                    }
                    
                    if ($professionnel && $service_initial) {
                        ?>
                        <h2>Prise de rendez-vous avec <?php echo htmlspecialchars($professionnel['nom']); ?></h2>
                        <h3>Services proposés :</h3>
                        
                        <form action="traitementRdv.php" method="post">
                            <input type="hidden" name="professionnel_id" value="<?php echo htmlspecialchars($professionnel_id); ?>">
                            <input type="hidden" name="service_id" id="service_id" value="<?php echo htmlspecialchars($service_initial['service_id']); ?>">
                            <input type="hidden" name="duree_service" id="duree_service" value="<?php echo htmlspecialchars($service_initial['duree']); ?>">
                            <input type="hidden" name="date_rdv" id="selected_date_input">
                            <input type="hidden" name="heure_rdv" id="selected_time_input">

                            <!-- Affichage du service initialement sélectionné -->
                            <div class="services-list">
                                <div class="service-item selected">
                                    <h4><?php echo htmlspecialchars($service_initial['nom_service']); ?></h4>
                                    <p><?php echo htmlspecialchars($service_initial['description']); ?></p>
                                    <p>Prix: <?php echo htmlspecialchars($service_initial['prix']); ?>€ | Durée: <?php echo htmlspecialchars($service_initial['duree']); ?> min</p>
                                </div>
                            </div>
                            
                            <!-- Sélection du membre de l'équipe -->
                            <h3>Sélectionnez un membre de l'équipe :</h3>
                            <div class="membre-selection">
                                <?php 
                                // On vérifie si un membre existe et on le pré-sélectionne
                                $is_first = true;
                                foreach ($membres_equipe as $membre): ?>
                                    <label>
                                        <input type="radio" name="membre_id" value="<?php echo htmlspecialchars($membre['membre_id']); ?>" <?php echo $is_first ? 'checked' : ''; ?> required>
                                        <?php echo htmlspecialchars($membre['nom_membre']); ?>
                                    </label>
                                <?php 
                                $is_first = false;
                                endforeach; ?>
                            </div>

                            <!-- Bouton pour afficher les autres services -->
                            <?php 
                            $services_du_pro = array_filter($services_all, function($s) use ($service_id_initial) {
                                return $s['service_id'] != $service_id_initial;
                            });
                            if (!empty($services_du_pro)): ?>
                                <button id="toggleButton">Afficher plus de services</button>
                                <div id="hiddenServices" class="hidden-services">
                                    <div class="services-list">
                                        <?php foreach ($services_du_pro as $service): ?>
                                            <div class="service-item">
                                                <button type="button" class="select-service-btn" 
                                                    data-service-id="<?php echo htmlspecialchars($service['service_id']); ?>"
                                                    data-duree="<?php echo htmlspecialchars($service['duree']); ?>">Sélectionner</button>
                                                <h4><?php echo htmlspecialchars($service['nom_service']); ?></h4>
                                                <p><?php echo htmlspecialchars($service['description']); ?></p>
                                                <p>Prix: <?php echo htmlspecialchars($service['prix']); ?>€ | Durée: <?php echo htmlspecialchars($service['duree']); ?> min</p>
                                            </div>
                                        <?php endforeach; ?>
                                    </div>
                                </div>
                            <?php endif; ?>

                            <!-- Section Agenda Dynamique -->
                            <div class="agenda-container">
                                <h3>Choisissez une date et une heure :</h3>
                                <div class="calendar-navigation">
                                    <button id="prevWeekButton">&lt;</button>
                                    <h4 id="currentMonthYear"></h4>
                                    <button id="nextWeekButton">&gt;</button>
                                </div>
                                <div id="calendar" class="calendar-grid"></div>
                            </div>

                            <!-- Autres informations (client) -->
                            <div class="form-group">
                                <label for="client_nom">Votre nom:</label>
                                <input type="text" id="client_nom" name="client_nom" required>
                            </div>
                            <div class="form-group">
                                <label for="client_email">Votre email:</label>
                                <input type="email" id="client_email" name="client_email" required>
                            </div>

                            <button type="submit">Confirmer le rendez-vous</button>
                        </form>
                        <?php
                    } else {
                        echo "<p class='error-message'>Erreur : Le professionnel ou le service initial n'existent pas.</p>";
                    }
                } else {
                    echo "<p class='error-message'>Erreur : Les informations du professionnel sont manquantes.</p>";
                }
            } else {
                echo "<p class='error-message'>Accès invalide à cette page.</p>";
            }

            $connexion->close();
            ?>
        </div>
    </main>
    <!-- Footer -->
    <?php include 'footer.php'; ?>

    <script>
        document.addEventListener('DOMContentLoaded', (event) => {
            const toggleButton = document.getElementById('toggleButton');
            const hiddenServices = document.getElementById('hiddenServices');
            const serviceItems = document.querySelectorAll('.service-item');
            const initialServiceId = document.getElementById('service_id');
            const initialServiceDuration = document.getElementById('duree_service');
            const membreRadios = document.querySelectorAll('input[name="membre_id"]');
            const calendarContainer = document.getElementById('calendar');
            const selectedDateInput = document.getElementById('selected_date_input');
            const selectedTimeInput = document.getElementById('selected_time_input');
            const prevWeekButton = document.getElementById('prevWeekButton');
            const nextWeekButton = document.getElementById('nextWeekButton');
            const currentMonthYearHeader = document.getElementById('currentMonthYear');
            
            // Données passées de PHP à JavaScript
            const phpDisponibilites = <?php echo json_encode($disponibilites); ?>;
            const servicesData = <?php echo json_encode($services_all); ?>;
            
            // On récupère le membre initialement sélectionné
            let selectedMembreId = null;
            const firstCheckedRadio = document.querySelector('input[name="membre_id"]:checked');
            if (firstCheckedRadio) {
                selectedMembreId = firstCheckedRadio.value;
            }

            let selectedServiceDuration = initialServiceDuration.value;
            let selectedDate = null;
            let selectedTime = null;
            let currentDate = new Date();

            const daysOfWeek = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
            const months = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
            
            // Liste des créneaux horaires fixes basés sur la nouvelle structure de la BDD
            const timeSlotsList = ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'];


            if (toggleButton && hiddenServices) {
                toggleButton.addEventListener('click', function(e) {
                    e.preventDefault();
                    if (hiddenServices.style.display === 'none' || hiddenServices.style.display === '') {
                        hiddenServices.style.display = 'block';
                        toggleButton.textContent = 'Cacher les autres services';
                    } else {
                        hiddenServices.style.display = 'none';
                        toggleButton.textContent = 'Afficher plus de services';
                    }
                });
            }

            // Gère la sélection des autres services
            document.querySelectorAll('.select-service-btn').forEach(button => {
                button.addEventListener('click', (e) => {
                    const selectedId = e.target.getAttribute('data-service-id');
                    selectedServiceDuration = e.target.getAttribute('data-duree');
                    
                    initialServiceId.value = selectedId;
                    initialServiceDuration.value = selectedServiceDuration;
                    
                    serviceItems.forEach(item => item.classList.remove('selected'));
                    
                    const newSelectedItem = e.target.closest('.service-item');
                    if (newSelectedItem) {
                        newSelectedItem.classList.add('selected');
                    }
                    
                    if (selectedMembreId) {
                        renderCalendar(currentDate);
                    }
                    
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                });
            });

            // Gère la sélection des membres de l'équipe
            membreRadios.forEach(radio => {
                radio.addEventListener('change', (e) => {
                    selectedMembreId = e.target.value;
                    renderCalendar(currentDate);
                });
            });

            // Gère la navigation dans le calendrier
            prevWeekButton.addEventListener('click', () => {
                const newDate = new Date(currentDate);
                newDate.setDate(newDate.getDate() - 7);
                currentDate = newDate;
                renderCalendar(currentDate);
            });

            nextWeekButton.addEventListener('click', () => {
                const newDate = new Date(currentDate);
                newDate.setDate(newDate.getDate() + 7);
                currentDate = newDate;
                renderCalendar(currentDate);
            });

            // Fonction pour rendre le calendrier complet (jours et créneaux)
            function renderCalendar(startDate) {
                calendarContainer.innerHTML = '';
                
                const disponibilitesMembre = phpDisponibilites[selectedMembreId] || {};
                
                currentMonthYearHeader.textContent = `${months[startDate.getMonth()]} ${startDate.getFullYear()}`;

                const startDay = startDate.getDay();
                const diff = (startDay === 0) ? -6 : 1 - startDay; // Pour commencer par le lundi
                const weekStart = new Date(startDate);
                weekStart.setDate(startDate.getDate() + diff);

                for (let i = 0; i < 7; i++) {
                    const date = new Date(weekStart);
                    date.setDate(weekStart.getDate() + i);
                    const dateString = date.toISOString().slice(0, 10);
                    const dayColumn = document.createElement('div');
                    dayColumn.classList.add('day-column');

                    // En-tête du jour
                    const headerDiv = document.createElement('div');
                    headerDiv.classList.add('calendar-day-header');
                    headerDiv.innerHTML = `${daysOfWeek[date.getDay()]} <br> ${date.getDate()}`;
                    dayColumn.appendChild(headerDiv);

                    // Créneaux horaires pour ce jour
                    const creneauxDisponibles = disponibilitesMembre[dateString] || [];
                    
                    // On parcourt la liste des créneaux fixes
                    timeSlotsList.forEach(timeString => {
                        const isAvailable = creneauxDisponibles.includes(timeString);
                        
                        const timeDiv = document.createElement('div');
                        timeDiv.classList.add('time-slot');
                        timeDiv.textContent = timeString;
                        timeDiv.setAttribute('data-date', dateString);
                        timeDiv.setAttribute('data-time', timeString);

                        if (isAvailable) {
                            timeDiv.classList.add('available');
                            timeDiv.addEventListener('click', () => {
                                document.querySelectorAll('.time-slot').forEach(t => t.classList.remove('selected-time'));
                                timeDiv.classList.add('selected-time');
                                selectedDate = dateString;
                                selectedTime = timeString;
                                selectedDateInput.value = selectedDate;
                                selectedTimeInput.value = selectedTime;
                            });
                        } else {
                            timeDiv.classList.add('unavailable');
                        }
                        
                        dayColumn.appendChild(timeDiv);
                    });
                    
                    calendarContainer.appendChild(dayColumn);
                }
            }

            // On rend le calendrier initial au chargement de la page si un membre est disponible
            if (selectedMembreId) {
                renderCalendar(currentDate);
            }
        });
    </script>
</body>
</html>
