<?php
// Démarrer la session
session_start();

// Vider le tableau des variables de session
$_SESSION = array();

// Détruire la session
session_destroy();

// Rediriger vers la page de connexion
header("Location: login.php");
exit();
?>