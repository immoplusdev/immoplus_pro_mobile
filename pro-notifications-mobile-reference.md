# Fiche de référence — Notifications Marketing Pro (pro_notifications)

> **Destinataires :** Développeurs mobiles (iOS / Android)
> **Dernière mise à jour :** 2026-07-17
> **Source :** `src/infrastructure/features/pro-notifications/`
> **Audience cible :** Utilisateurs avec rôle `pro_particulier` ou `pro_entreprise`

---

## Structure du payload `data` reçu côté mobile

```json
{
  "type": "marketing",
  "code": "PRO-ONB-02"
}
```

| Champ | Type | Valeur | Description |
|-------|------|--------|-------------|
| `type` | `string` | Toujours `"marketing"` | Catégorie de la notification |
| `code` | `string` | Voir tableaux ci-dessous | Identifiant unique du template |

> La logique de redirection côté mobile se fait **uniquement sur le champ `code`**.

---

## Onboarding Pro Particulier — `PRO-ONB-*`

Rôle ciblé : `pro_particulier` uniquement.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile |
|------|-------------|-------|-------|--------|--------------------|
| `PRO-ONB-01` | Immédiat (création compte Pro) | Bienvenue dans la communauté Immo+ Pro 🏆 | Votre compte est en cours de configuration | Push | Écran **Accueil Pro** |
| `PRO-ONB-02` | J+1 après inscription | Soumettez votre premier bien en 5 minutes | Photos + description + prix = votre annonce en ligne | Push | Écran **Publication résidence** |
| `PRO-ONB-03` | J+3 après inscription | Astuce Pro : les annonces avec 5+ photos reçoivent 3x plus de demandes | Complétez votre galerie pour maximiser vos réservations | Push | Écran **Gestion résidence / Photos** |
| `PRO-ONB-04` | J+7 après inscription — 14h00 | Comment fixer le bon prix ? | Les résidences similaires sont louées entre `{{prix_min}}` et `{{prix_max}}` FCFA | Push | Écran **Gestion résidence / Prix** |
| `PRO-ONB-05` | J+14 après inscription | `{{titre_onb05}}` | *(dynamique)* | Push | Écran **Accueil Pro** |
| `PRO-ONB-06` | J+21 après inscription | Voici comment d'autres pros ont doublé leurs réservations | Restez connecté et mettez à jour votre calendrier : +40% de réservations | Push | Écran **Calendrier** |
| `PRO-ONB-07` | J+30 après inscription | Un mois de partenariat — Merci de faire confiance à ImmoPlus Pro 💼 | Récapitulatif : `{{nb_vues}}` vues, `{{nb_demandes}}` demandes, `{{nb_reservations}}` réservations | Push | Écran **Dashboard / Statistiques** |

---

## Onboarding Pro Entreprise — `PRO-ONBENT-*`

Rôle ciblé : `pro_entreprise` uniquement.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile |
|------|-------------|-------|-------|--------|--------------------|
| `PRO-ONBENT-01` | Immédiat (création compte Entreprise) | Bienvenue chez Immo+ Pro Entreprise 🏢 | Votre espace professionnel vous attend | Push | Écran **Accueil Pro** |
| `PRO-ONBENT-02` | J+2 après inscription | Configurez votre portfolio en quelques étapes | Ajoutez tous vos biens pour maximiser votre visibilité | Push | Écran **Gestion résidences / Ajout bien** |
| `PRO-ONBENT-04` | J+10 après inscription | Votre tableau de bord est prêt | Suivez vos performances en temps réel | Push | Écran **Dashboard / Statistiques** |

---

## Calendrier — Activation — `PRO-CAL-01` à `PRO-CAL-04`

Notifications liées à l'absence de disponibilités renseignées sur une résidence validée.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile | `referenceId` |
|------|-------------|-------|-------|--------|--------------------|---------------|
| `PRO-CAL-01` | Immédiat — résidence validée par admin | 🏠 Votre résidence est en ligne ! | Dernière étape : renseignez vos disponibilités pour recevoir vos premières réservations | Push | Écran **Calendrier résidence** *(voir note A)* | `residenceId` |
| `PRO-CAL-02` | J+3 sans calendrier renseigné | ⚠️ Votre calendrier est vide | Sans disponibilités, vous risquez de manquer des réservations. Ajoutez vos dates maintenant. | Push | Écran **Calendrier résidence** *(voir note A)* | `residenceId` |
| `PRO-CAL-03` | J+7 sans calendrier renseigné | 📊 Des clients recherchent dans votre zone | Un calendrier à jour augmente vos chances d'apparaître dans les résultats. | Push | Écran **Calendrier résidence** *(voir note A)* | `residenceId` |
| `PRO-CAL-04` | J+14 sans calendrier renseigné | 🚀 Boostez votre visibilité | Les résidences avec un calendrier à jour reçoivent davantage de demandes. | Push | Écran **Calendrier résidence** *(voir note A)* | `residenceId` |

---

## Calendrier — Routine quotidienne — `PRO-CAL-DAILY-*`

Rappels quotidiens envoyés à tous les Pros avec au moins une résidence validée.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile |
|------|-------------|-------|-------|--------|--------------------|
| `PRO-CAL-DAILY-AM` | Quotidien — 08h00 | 📅 Votre résidence est-elle disponible aujourd'hui ? | Mettez à jour votre calendrier si nécessaire pour recevoir des réservations. | Push | Écran **Calendrier** |
| `PRO-CAL-DAILY-PM` | Quotidien — 19h00 | 📢 Avez-vous reçu une réservation directe hors ImmoPlus ? | Si oui, mettez à jour votre calendrier afin d'éviter toute double réservation. | Push | Écran **Calendrier** |

---

## Calendrier — Événements — `PRO-CAL-EVT-*`

Déclenchés par des événements spécifiques (action client ou temporel).

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile | `referenceId` |
|------|-------------|-------|-------|--------|--------------------|---------------|
| `PRO-CAL-EVT-02` | Immédiat — client consulte le calendrier de la résidence | 👀 Des clients regardent `{{nom_residence}}` | Votre résidence reçoit de l'intérêt ! Mettez votre calendrier à jour pour convertir ces visites. | Push (priorité haute) | Écran **Calendrier résidence** *(voir note A)* | `residenceId` |
| `PRO-CAL-EVT-03` | Vendredi — 14h00 | 📆 Weekend en vue — disponibilités à jour ? | Le weekend est la période la plus active sur ImmoPlus. Vérifiez votre calendrier avant ce soir. | Push | Écran **Calendrier** | aucun |

---

## Réengagement inactif — `PRO-REENG-*`

Rôles ciblés : `pro_particulier` et `pro_entreprise`.

| Code | Inactivité | Titre | Corps | Canaux | Redirection mobile | `referenceId` |
|------|-----------|-------|-------|--------|--------------------|---------------|
| `PRO-REENG-07` | 7 jours | Vous avez des clients potentiels en attente 👁️ | Votre résidence a été vue `{{nb_vues_semaine}}` fois cette semaine | Push | Écran **Mes résidences** *(voir note A)* | `residenceId` (optionnel) |
| `PRO-REENG-14` | 14 jours | Conseil : répondez aux demandes rapidement pour +60% d'acceptations | Vérifiez vos demandes en attente | Push | Écran **Demandes / Réservations** | aucun |
| `PRO-REENG-60` | 60 jours | Votre résidence est-elle toujours disponible ? | Mettez à jour votre disponibilité pour rester visible | Push + SMS | Écran **Calendrier** | aucun |

---

## Nurturing post-publication — `PRO-NURT-*`

Notifications déclenchées par l'activité sur les annonces du Pro.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile | `referenceId` |
|------|-------------|-------|-------|--------|--------------------|---------------|
| `PRO-NURT-01` | Immédiat — premières vues du jour sur une résidence | Votre résidence reçoit ses premières visites ! 👀 | `{{nb_vues_jour}}` personnes ont consulté votre annonce aujourd'hui | Push | Fiche **Détail résidence** *(voir note A)* | `residenceId` |
| `PRO-NURT-02` | Immédiat — nouvelle demande reçue | Astuce : répondez aux demandes en moins de 1h | Les propriétaires réactifs ont 80% de chances de conclure | Push | Écran **Demandes** | aucun |
| `PRO-NURT-03` | J+7 après publication — bilan hebdo | Bilan semaine : `{{nb_vues}}` vues sur votre résidence | Voici comment améliorer votre annonce pour plus de réservations | Push | Fiche **Détail résidence / Stats** *(voir note A)* | `residenceId` |

---

## Performance — `PRO-PERF-*`

Notifications basées sur les métriques de performance des résidences.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile | `referenceId` |
|------|-------------|-------|-------|--------|--------------------|---------------|
| `PRO-PERF-01` | Dimanche — 10h00 (récap hebdo) | 📊 Récap de la semaine | `{{nb_vues}}` vues · `{{nb_demandes}}` demandes · Revenus potentiels : `{{montant}}` FCFA | Push | Écran **Dashboard / Stats résidence** *(voir note A)* | `residenceId` |
| `PRO-PERF-02` | Immédiat — résidence atteint 100 vues | 🎯 100 personnes ont vu votre résidence ! | C'est le moment de vérifier vos disponibilités | Push | Fiche **Détail résidence** *(voir note A)* | `residenceId` |
| `PRO-PERF-05` | Immédiat — pic de vues sur résidence | 🔥 Votre résidence cartonne ! `{{nb_vues}}` vues en `{{duree}}` | Mettez à jour votre calendrier maintenant pour accueillir les visites. | Push | Fiche **Détail résidence** *(voir note A)* | `residenceId` |
| `PRO-PERF-06` | Immédiat — forte demande dans un quartier | 🔍 `{{nb_recherches}}` personnes recherchent une résidence à `{{quartier}}` en ce moment ! | Mettez à jour votre calendrier et soyez prêt. | Push | Écran **Calendrier** / **Mes résidences** | aucun |

---

## Post-checkout — `PRO-CHECKOUT-*`

Notifications envoyées après la fin d'un séjour (réservation validée et payée).

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile | `referenceId` |
|------|-------------|-------|-------|--------|--------------------|---------------|
| `PRO-CHECKOUT-01` | J+1 après date de fin de séjour | 🌟 La résidence est libérée — Prête pour le prochain client ? | Vérifiez l'état et remettez votre calendrier à jour | Push | Écran **Calendrier résidence** *(voir note B)* | `reservationId` |
| `PRO-CHECKOUT-02` | J+2 après date de fin de séjour | Votre solde est disponible pour retrait 💰 | `{{montant}}` FCFA vous attendent dans votre wallet | Push | Écran **Wallet** *(voir note B)* | `reservationId` |

---

## Saisonnalité — `PRO-SEASON-*`

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile |
|------|-------------|-------|-------|--------|--------------------|
| `PRO-SEASON-02` | Immédiat — forte demande détectée dans un quartier | ⚡ Forte demande à `{{quartier}}` cette semaine | Vos biens sont très recherchés ! | Push | Écran **Mes résidences / Calendrier** |

---

## Wallet — `PRO-WALLET-*`

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile |
|------|-------------|-------|-------|--------|--------------------|
| `PRO-WALLET-02` | Quotidien — solde wallet ≥ 100 000 FCFA | 💵 Vous avez `{{montant}}` FCFA à retirer | N'attendez pas, transférez sur votre compte Mobile Money | Push | Écran **Wallet** |

---

## Gamification / Milestones — `PRO-MILESTONE-*`

Notifications de félicitations déclenchées par des étapes clés atteintes par le Pro.

| Code | Déclencheur | Titre | Corps | Canaux | Redirection mobile | `referenceId` |
|------|-------------|-------|-------|--------|--------------------|---------------|
| `PRO-MILESTONE-FIRST-RESIDENCE` | Immédiat — 1ère résidence publiée | 🏠 Votre première résidence est en ligne ! | Félicitations ! Votre annonce est maintenant visible par des centaines de clients. | Push | Fiche **Détail résidence** *(voir note A)* | `residenceId` |
| `PRO-MILESTONE-FIRST-RESERVATION` | Immédiat — 1ère réservation reçue | 🎉 Votre première réservation sur ImmoPlus ! | Félicitations ! Confirmez rapidement pour débuter votre aventure Pro. | Push | Écran **Réservations** | aucun |
| `PRO-MILESTONE-10-RESERVATIONS` | Quotidien — total atteint 10 réservations payées | 🏆 10 réservations sur ImmoPlus, félicitations ! | Vous êtes sur la bonne voie. Continuez comme ça ! | Push | Écran **Dashboard / Statistiques** | aucun |
| `PRO-MILESTONE-50-RESERVATIONS` | Quotidien — total atteint 50 réservations payées | 🏆 50 réservations sur ImmoPlus, félicitations ! | Vous faites partie de nos meilleurs Pros. Merci de votre confiance. | Push | Écran **Dashboard / Statistiques** | aucun |
| `PRO-MILESTONE-100-RESERVATIONS` | Quotidien — total atteint 100 réservations payées | 🏆 100 réservations sur ImmoPlus, félicitations ! | Vous êtes un vrai champion ImmoPlus Pro ! | Push | Écran **Dashboard / Statistiques** | aucun |
| `PRO-MILESTONE-5STARS` | Immédiat — note 5 étoiles reçue | ⭐ Votre note 5 étoiles fait la différence | Vos clients vous adorent ! Continuez à offrir une expérience exceptionnelle. | Push | Écran **Avis / Notation** | aucun |

---

## Notes importantes sur les redirections

### Note A — Codes liés à une résidence spécifique

Codes concernés : `PRO-CAL-01`, `PRO-CAL-02`, `PRO-CAL-03`, `PRO-CAL-04`, `PRO-CAL-EVT-02`, `PRO-NURT-01`, `PRO-NURT-03`, `PRO-PERF-01`, `PRO-PERF-02`, `PRO-PERF-05`, `PRO-REENG-07`, `PRO-MILESTONE-FIRST-RESIDENCE`

Le `referenceId` (UUID de la résidence) est stocké côté serveur pour la déduplication mais **n'est pas inclus dans le payload push actuel**.

**Comportement actuel :** rediriger vers la liste générale des résidences du Pro.

**Comportement cible (après correction API) :**
```json
{
  "type": "marketing",
  "code": "PRO-CAL-01",
  "referenceId": "uuid-de-la-residence"
}
```
→ Redirection : `/pro/residences/:referenceId/calendrier` ou `/pro/residences/:referenceId`

---

### Note B — Codes liés à une réservation spécifique

Codes concernés : `PRO-CHECKOUT-01`, `PRO-CHECKOUT-02`

Le `referenceId` est ici l'UUID de la **réservation** (pas de la résidence), mais il **n'est pas dans le payload push actuel**.

**Comportement actuel :**
- `PRO-CHECKOUT-01` → Écran Calendrier général
- `PRO-CHECKOUT-02` → Écran Wallet

**Comportement cible (après correction API) :**
```json
{
  "type": "marketing",
  "code": "PRO-CHECKOUT-01",
  "referenceId": "uuid-de-la-reservation"
}
```
→ Redirection : `/pro/reservations/:referenceId`

---

## Correction requise côté API

Pour activer le deep linking sur tous les codes qui ont un `referenceId`, modifier le processor :

**Fichier :** `src/infrastructure/features/pro-notifications/pro-notifications.processor.ts` — ligne ~273

```ts
// Avant
data: { type: PushNotificationType.Marketing, code },

// Après
data: { type: PushNotificationType.Marketing, code, ...(referenceId && { referenceId }) },
```

Payload complet reçu côté mobile après correction :

```json
{
  "type": "marketing",
  "code": "PRO-CAL-01",
  "referenceId": "550e8400-e29b-41d4-a716-446655440000"
}
```

---

## Récapitulatif des redirections par écran Pro

| Écran mobile | Codes déclencheurs |
|---|---|
| Accueil Pro | `PRO-ONB-01`, `PRO-ONBENT-01`, `PRO-ONB-05` |
| Publication résidence | `PRO-ONB-02` |
| Gestion résidence / Photos | `PRO-ONB-03` |
| Gestion résidence / Prix | `PRO-ONB-04` |
| Gestion résidences / Ajout bien | `PRO-ONBENT-02` |
| Dashboard / Statistiques | `PRO-ONB-07`, `PRO-ONBENT-04`, `PRO-PERF-01`, `PRO-MILESTONE-10-RESERVATIONS`, `PRO-MILESTONE-50-RESERVATIONS`, `PRO-MILESTONE-100-RESERVATIONS` |
| Calendrier (général) | `PRO-ONB-06`, `PRO-CAL-DAILY-AM`, `PRO-CAL-DAILY-PM`, `PRO-CAL-EVT-03`, `PRO-REENG-60`, `PRO-PERF-06`, `PRO-SEASON-02` |
| Calendrier résidence (deep link) | `PRO-CAL-01`, `PRO-CAL-02`, `PRO-CAL-03`, `PRO-CAL-04`, `PRO-CAL-EVT-02`, `PRO-CHECKOUT-01` |
| Fiche Détail résidence (deep link) | `PRO-NURT-01`, `PRO-NURT-03`, `PRO-PERF-02`, `PRO-PERF-05`, `PRO-MILESTONE-FIRST-RESIDENCE` |
| Mes résidences | `PRO-REENG-07` |
| Demandes | `PRO-NURT-02` |
| Demandes / Réservations | `PRO-REENG-14` |
| Réservations | `PRO-MILESTONE-FIRST-RESERVATION` |
| Détail réservation (deep link) | `PRO-CHECKOUT-01`, `PRO-CHECKOUT-02` |
| Wallet | `PRO-WALLET-02`, `PRO-CHECKOUT-02` |
| Avis / Notation | `PRO-MILESTONE-5STARS` |
