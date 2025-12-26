# Memo Tori — agent.md

## Mission
Créer une application Linux desktop nommée **Memo Tori**.
Son unique objectif est de permettre à un utilisateur :
1) d’entrer une idée
2) de la stocker localement

La simplicité est la contrainte principale.
Toute fonctionnalité non explicitement demandée est interdite.

---

## Périmètre fonctionnel (strict)

- Une idée = **un seul champ texte**
- Texte libre jusqu’à **5000 caractères**, espaces comprises
- Aucun titre
- Aucune métadonnée
- Aucune édition après création
- Aucune recherche
- Aucune synchronisation

---

## Interface utilisateur

### Technologie
- UI **web embarquée**
- HTML / CSS / JavaScript natifs
- **Aucun framework frontend**
- Rendu dans une fenêtre desktop (WebView, Tauri ou équivalent léger)

### Écran de démarrage
- Toujours afficher **le formulaire d’entrée**

### Formulaire
- Un `textarea`
- Compteur de caractères visible
- Limite bloquante à 5000 caractères
- Bouton `Submit`

### Navigation
- Sous le bouton : un lien **« consulter »**
- Ce lien affiche la liste complète des idées

### Liste des idées
- Ordre : **les plus récentes en haut**
- Chaque idée affiche :
  - les **300 premiers caractères**
  - une case à cocher « effacer »

### Suppression
- Cocher la case déclenche une **micro-confirmation**
- Confirmation acceptée = suppression définitive
- Aucune corbeille
- Aucune annulation

---

## Stockage des données

### Format
- **Texte brut**
- Encodage : **UTF-8 sans BOM**

### Structure
- Une idée = un **bloc de texte libre**
- Les idées sont séparées par :

```
---
```

- Le séparateur est sur une ligne seule
- Aucune donnée dérivée n’est stockée
- La troncature (300 caractères) est uniquement visuelle

### Portabilité
- Les données doivent être **transportables par simple copie du fichier**

---

## Interdits absolus (non négociables)

- Aucun accès réseau
- Aucun compte utilisateur
- Aucun cloud
- Aucune télémétrie
- Aucun tracking
- Aucun framework JavaScript
- Aucun build complexe
- Aucune dépendance lourde
- Aucun auto-update

---

## Philosophie d’implémentation

- Préférer la clarté à l’élégance
- Préférer le lisible au performant
- Préférer l’évidence à l’extensibilité
- L’application doit disparaître derrière l’acte d’écrire

---

## Critère de réussite

Une idée doit pouvoir être saisie et enregistrée
en **moins de 3 secondes**, sans réflexion technique,
sans peur de casser quoi que ce soit.

