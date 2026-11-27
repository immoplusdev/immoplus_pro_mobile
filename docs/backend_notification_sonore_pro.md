# Notifications sonores — app ImmoPlus Pro : changement du payload FCM

## Contexte

L'app Pro a désormais un son de notification personnalisé, embarqué dans l'app :

| Plateforme | Fichier embarqué | Valeur à envoyer |
|---|---|---|
| Android | `res/raw/immoplus_notification.ogg` | `immoplus_notification` (sans extension) |
| iOS | `immoplus_notification.caf` (bundle de l'app) | `immoplus_notification.caf` (avec extension) |

**L'app ne peut pas jouer ce son seule quand elle est en arrière-plan ou fermée.** Dans ce cas, c'est le système (Android / iOS) qui affiche la notification, à partir du payload FCM. Si le payload ne nomme pas le son :

- **iOS** : la notification arrive **sans aucun son**, ou avec le son système si `sound: "default"` est envoyé.
- **Android** : le son dépend du canal. L'app déclare un nouveau canal `immoplus_pro_sound_channel`, qui porte le son personnalisé, et l'a mis comme canal par défaut. Il vaut quand même mieux le préciser explicitement.

Quand l'app est ouverte (premier plan), rien n'est à faire côté backend.

## Ce qu'il faut changer

Pour **toutes les notifications envoyées aux utilisateurs Pro** (réservations, demandes de visite, paiements, messages, marketing…), ajouter les blocs `android.notification` et `apns.payload.aps.sound` au message FCM HTTP v1 :

```json
{
  "message": {
    "token": "<fcm_token>",
    "notification": {
      "title": "Nouvelle réservation",
      "body": "Vous avez une nouvelle demande de réservation"
    },
    "data": {
      "type": "new_reservation_waiting",
      "id": "..."
    },
    "android": {
      "priority": "high",
      "notification": {
        "channel_id": "immoplus_pro_sound_channel",
        "sound": "immoplus_notification"
      }
    },
    "apns": {
      "payload": {
        "aps": {
          "sound": "immoplus_notification.caf"
        }
      }
    }
  }
}
```

Avec le SDK Firebase Admin (Node.js), cela donne :

```js
await admin.messaging().send({
  token,
  notification: { title, body },
  data,
  android: {
    priority: 'high',
    notification: {
      channelId: 'immoplus_pro_sound_channel',
      sound: 'immoplus_notification',
    },
  },
  apns: {
    payload: { aps: { sound: 'immoplus_notification.caf' } },
  },
});
```

## Points d'attention

1. **Uniquement pour l'app Pro.** L'app client n'embarque pas ce son. Si un même service envoie aux deux apps, ne mettre ces champs que pour les tokens Pro. Un son inconnu fait retomber iOS sur le son par défaut et peut rendre Android silencieux.
2. **Le bloc `notification` doit rester présent.** Un message uniquement `data` n'affiche rien et ne joue aucun son quand l'app est fermée.
3. **Valeurs exactes.** L'id du canal et le nom du son sont sensibles à la casse et doivent correspondre exactement aux valeurs ci-dessus. Sur Android, le son s'écrit sans extension ; sur iOS, avec `.caf`.
4. **Notifications silencieuses.** Si certaines notifications doivent rester silencieuses, ne pas leur mettre `sound` et nous le signaler : il faudra un second canal Android sans son.
5. **Compatibilité avec les anciennes versions de l'app.**
   - **iOS** : un nom de son introuvable fait jouer le son système. Pas de régression.
   - **Android** : un `channel_id` inconnu fait retomber sur le canal par défaut déclaré par l'app.
   - **Conclusion** : on peut déployer sans attendre la mise à jour des apps.

## Comment vérifier

- Envoyer une notification de test à un appareil Android et à un iPhone, avec l'app **fermée**, puis l'app **en arrière-plan**.
- Le carillon ImmoPlus (deux notes, environ 1 seconde) doit se faire entendre à la place du son système.
