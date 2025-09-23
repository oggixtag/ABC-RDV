<!DOCTYPE html>
	<header>
		<div class="header-container">
			<div class="header-item">
				<?php
				// Récupérer le nom du fichier de la page actuelle
				$current_page = basename($_SERVER['PHP_SELF']);

				// Afficher le lien "accueil" uniquement si la page actuelle n'est pas index.php
				if ($current_page != 'index.php') {
					echo '<a href="index.php"><img src="img/resized/logo no arrière-plain 150.png" /></a>';
				} else {
					echo '<img src="img/resized/logo no arrière-plain 150.png" />';
				}
				?>
			</div>
			<div class="header-item">
				<?php
				// Déterminer le titre à afficher en fonction de la page actuelle
				if ($current_page == 'rechercheProParVille.php') {
					echo '<h1>Recherche d’un professionnel</h1>';
				} else if ($current_page == 'professionnelChoisi.php') {
					echo '<h1>Prestations proposées</h1>';
				} else if ($current_page == 'prendreRdv.php') {
					echo '<h1>Prise de rendez-vous</h1>';
				} else if ($current_page == 'traitementRdv.php') {
					echo '<h1>Récapitulatif de votre rendez-vous</h1>';
				} else if ($current_page == 'login.php') {
					echo '<h1>Login du le site ' . CONST_TITRE_DU_PRJ . '</h1>';
				} else if ($current_page == 'dashboardClient.php') {
					echo '<h1>Tableau de Bord pour les Clients</h1>';
				} else if ($current_page == 'dashboardPro.php') {
					echo '<h1>Tableau de Bord pour les Professionnels</h1>';
				} else {
					echo '<h1>Bienvenue sur le site ' . CONST_TITRE_DU_PRJ . '</h1>';
				}
				?>
			</div>
			<div class="header-item">
				<?php
				// Afficher le lien "login" uniquement si la page actuelle n'est pas login.php, dashboardClient.php ou dashboardPro.php
				if ($current_page != 'login.php' && $current_page != 'dashboardClient.php' && $current_page != 'dashboardPro.php') {
					echo '<h1 class="button-style"><a href="login.php">login</a></h1>';
				}
				// Afficher le lien "Se déconnecter" uniquement sur les pages de tableau de bord
				if ($current_page == 'dashboardClient.php' || $current_page == 'dashboardPro.php') {
					echo '<h1 class="button-style"><a href="logout.php">Logout</a></h1>';
				}
				?>
			</div>
		</div>
	</header>
