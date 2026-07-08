# Lebonprix 237 Manager — Version de base

Application Flutter de gestion pour Lebonprix 237 (by Elite Empire SARL).

## ⚠️ Important — comment obtenir votre fichier .apk

Ce projet est **le code source complet, prêt à compiler**. Je n'ai pas pu générer le .apk
directement car cet environnement n'a ni le SDK Android ni Flutter installés, et n'a pas
accès à Internet pour télécharger les dépendances. Voici comment obtenir l'APK — 3 options :

### Option A — Vous avez Flutter installé sur votre PC (le plus simple)
1. Installez Flutter si ce n'est pas déjà fait : https://docs.flutter.dev/get-started/install
2. Ouvrez un terminal dans un dossier vide et lancez :
   ```
   flutter create lebonprix237
   ```
3. Remplacez le dossier `lib/` généré et le fichier `pubspec.yaml` par ceux fournis ici.
4. Dans le terminal, à la racine du projet :
   ```
   flutter pub get
   flutter build apk --release
   ```
5. Votre APK sera dans : `build/app/outputs/flutter-apk/app-release.apk`
   → transférez-le sur votre téléphone Android et installez-le (autorisez "sources inconnues").

### Option B — Vous n'avez pas Flutter installé (solution en ligne, gratuite)
1. Créez un compte gratuit sur **Codemagic** (codemagic.io) ou utilisez **GitHub Actions**.
2. Poussez ce projet sur un dépôt GitHub.
3. Codemagic détecte automatiquement Flutter et propose un bouton "Build APK".
4. Téléchargez l'APK généré depuis leur interface.

### Option C — Via Android Studio
1. Installez Android Studio (inclut le SDK Android) + le plugin Flutter.
2. Ouvrez le dossier du projet.
3. Menu Build > Build APK(s).

## Identifiants de connexion par défaut
- Identifiant : `admin`
- Mot de passe : `admin237`

⚠️ Pensez à changer ce mot de passe une fois l'application en production (actuellement en dur
dans `db_helper.dart` pour cette version de base — une vraie gestion des comptes employés
avec création/modification depuis l'app viendra en V2).

## Ce qui est inclus dans cette version de base
- ✅ Connexion (Admin / structure prête pour Employé)
- ✅ Tableau de bord (statistiques clients, devis, CA, encaissé, alertes stock)
- ✅ Clients (créer, modifier, supprimer, rechercher, lien direct WhatsApp)
- ✅ Devis (numérotation automatique DV-2026-0001, statuts, export PDF)
- ✅ Factures (numérotation automatique FA-2026-0001, paiements partiels, solde restant, export PDF)
- ✅ Stock (matières premières préchargées : Plexiglass, Bois MDF, Vinyle, Papier photo, LED,
  Colle, Emballages, Accessoires — entrées/sorties, alertes seuil minimum)
- ✅ Base de données locale SQLite (persistant, fonctionne hors-ligne)
- ✅ Design Material 3 aux couleurs de la charte graphique (Rouge #E30613, Noir #111111)

## Ce qui viendra en V2 (non inclus dans cette version de base)
- Firebase Sync (sauvegarde cloud)
- Module Production détaillé (états découpe/impression/assemblage)
- Bon de commande et Bon de livraison avec signature
- Comptabilité complète (recettes/dépenses/caisse) avec graphiques
- Gestion multi-employés avec création de comptes depuis l'app
- Notifications push (stock faible, livraisons)
- Génération PDF pour Bon de commande, Bon de livraison, Reçu

## Structure du projet
```
lib/
├── main.dart                    # Point d'entrée
├── core/
│   ├── theme/app_theme.dart     # Couleurs & thème Material 3
│   └── database/db_helper.dart  # SQLite (création des tables)
├── models/                      # Client, Devis, Facture, StockItem, User
├── providers/                   # Gestion d'état (Provider)
├── services/pdf_service.dart    # Génération PDF devis/factures
├── widgets/                     # Composants réutilisables
└── screens/                     # Écrans (login, dashboard, clients, devis, factures, stock)
```

Dites-moi si vous voulez que je développe un des modules V2 en priorité.
