<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?php require_once 'constant.php'; ?>
    <title><?= TITRE_DU_SITE?></title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <!-- Header -->
    <?php include 'header.php'; ?>
<!-- Navigation Menu -->
    <nav>
        <ul>
            <li><a href="#accueil">Accueil</a></li>
            <li><a href="#service">Service</a></li>
            <li><a href="#avis">Avis</a></li>
            <li><a href="#professionnels">Professionnels</a></li>
        </ul>  
    </nav>
    <main role="main">
        <section id="accueil">
            <h2>Votre nouveau rendez-vous beauté, 24/7.</h2>
            <p>Trouvez et réservez votre coiffeur idéal en quelques clics. Simple, rapide et toujours disponible.</p>
        </section>
        <section id="service">
            <h2>Comment ça marche ?</h2>
            <div class="service-blocks">
                <div class="service-block">
                    <h3>1. Trouvez un professionnel</h3>
                    <p>Parcourez notre liste de coiffeurs et choisissez celui qui vous convient le mieux selon vos critères.</p>
                </div>
                <div class="service-block">
                    <h3>2. Réservez en ligne</h3>
                    <p>Sélectionnez la prestation, la date et l’heure qui vous arrangent, puis validez votre rendez-vous en quelques clics.</p>
                </div>
                <div class="service-block">
                    <h3>3. Profitez de votre rendez-vous</h3>
                    <p>Rendez-vous chez le professionnel choisi et profitez d’un service de qualité, sans attente.</p>
                </div>
            </div>
        </section>
        <section id="avis">
            <h2>Ils nous font confiance</h2>
            <p>L'avis de nos utilisateurs est notre plus grande fierté.</p>
        </section>
        <section id="professionnels">
            <h2>Vous êtes coiffeur ?</h2>
            <p>Rejoignez notre plateforme pour gagner en visibilité, gérer votre agenda sans effort et développer votre clientèle. Concentrez-vous sur votre art, nous nous occupons du reste.</p>
        </section>
    </main>
    <!-- Footer -->
    <?php include 'footer.php'; ?>
</body> 
</html>