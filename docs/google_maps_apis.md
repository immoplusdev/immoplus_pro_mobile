# Google Maps APIs — ImmoPLus Pro

Ce document recense toutes les APIs Google Maps utilisées dans l'application mobile ImmoPLus Pro.
Il a pour but de permettre au backend de créer des APIs proxy qui relayent les appels vers Google,
afin de centraliser la gestion des clés API et de sécuriser les accès.

---

## Contexte

L'application Flutter communique actuellement directement avec les APIs Google Maps depuis le client mobile.
L'objectif est de faire transiter ces appels par le backend ImmoPLus, qui devient le seul détenteur de la clé Google.

**Paramètres fixes appliqués par défaut dans le mobile :**
- `language = "fr"` — Résultats en français
- `region = "ci"` — Biais géographique vers la Côte d'Ivoire
- `components = "country:ci"` — Restriction aux lieux en Côte d'Ivoire

Ces paramètres peuvent être fixés côté backend sans avoir à les transmettre depuis le mobile.

---

## APIs à proxifier

### 1. Places Autocomplete

Utilisée pour la recherche de lieux en temps réel (champ de saisie d'adresse).

**Google Maps endpoint :**
```
GET https://maps.googleapis.com/maps/api/place/autocomplete/json
```

**Paramètres transmis par le mobile :**

| Paramètre | Type | Obligatoire | Défaut | Description |
|-----------|------|-------------|--------|-------------|
| `input` | string | oui | — | Texte saisi par l'utilisateur |
| `sessiontoken` | string | non | — | Token de session (groupe les requêtes pour la facturation) |
| `language` | string | non | `"fr"` | Langue des suggestions |
| `region` | string | non | `"ci"` | Biais régional |
| `components` | string | non | `"country:ci"` | Filtre sur le pays |
| `key` | string | oui | — | Clé API Google *(gérée par le backend)* |

**Réponse attendue (champs utilisés dans le mobile) :**
```json
{
  "status": "OK",
  "predictions": [
    {
      "id": "...",
      "description": "Abidjan, Côte d'Ivoire",
      "place_id": "ChIJ...",
      "structured_formatting": {
        "main_text": "Abidjan",
        "secondary_text": "Côte d'Ivoire",
        "main_text_matched_substrings": [{ "offset": 0, "length": 3 }]
      },
      "terms": [{ "offset": 0, "value": "Abidjan" }],
      "types": ["locality", "political"],
      "matched_substrings": [{ "offset": 0, "length": 3 }]
    }
  ]
}
```

**Fichiers source :**
- `lib/features/location_module/data/places_api_provider.dart` (ligne 20)
- `lib/features/location_module/data/places_api_repository.dart` (ligne 26)

---

### 2. Place Details (Legacy API)

Utilisée pour récupérer les coordonnées (lat/lng) et les détails d'un lieu à partir de son `place_id`
(après sélection dans la liste d'autocomplétion).

**Google Maps endpoint :**
```
GET https://maps.googleapis.com/maps/api/place/details/json
```

**Paramètres transmis par le mobile :**

| Paramètre | Type | Obligatoire | Défaut | Description |
|-----------|------|-------------|--------|-------------|
| `placeid` | string | oui | — | Identifiant du lieu (`place_id` issu de l'autocomplete) |
| `key` | string | oui | — | Clé API Google *(gérée par le backend)* |

**Réponse attendue (champs utilisés dans le mobile) :**
```json
{
  "result": {
    "geometry": {
      "location": {
        "lat": 5.3599517,
        "lng": -4.0082563
      }
    },
    "name": "Abidjan",
    "formatted_address": "Abidjan, Côte d'Ivoire",
    "place_id": "ChIJ..."
  },
  "status": "OK"
}
```

**Fichiers source :**
- `lib/features/location_module/location_controller.dart` (ligne 232)

---

### 3. Place Details (New Places API)

Version plus récente de l'API Place Details. Utilisée pour récupérer uniquement la `location`
(lat/lng) d'un lieu via la nouvelle API Google Places v1.

**Google Maps endpoint :**
```
GET https://places.googleapis.com/v1/places/{placeId}
```

**Paramètres :**

| Paramètre | Position | Obligatoire | Défaut | Description |
|-----------|----------|-------------|--------|-------------|
| `placeId` | path | oui | — | Identifiant du lieu (dans l'URL) |
| `key` | query | oui | — | Clé API Google *(gérée par le backend)* |
| `fields` | query | non | `"location"` | Champs à retourner |

**Exemple d'URL :**
```
GET https://places.googleapis.com/v1/places/ChIJN1t_tDeuEmsRUsoyG83frY4?key=...&fields=location
```

**Réponse attendue :**
```json
{
  "location": {
    "latitude": 5.3599517,
    "longitude": -4.0082563
  }
}
```

**Fichiers source :**
- `lib/features/location_module/data/places_api_provider.dart` (ligne 13)
- `lib/features/location_module/data/places_api_repository.dart` (ligne 14)

---

### 4. Geocoding — Reverse (coordonnées → adresse)

Utilisée pour convertir une position GPS (latitude, longitude) en adresse lisible.
Typiquement appelée quand l'utilisateur déplace le marqueur sur la carte.

**Google Maps endpoint :**
```
GET https://maps.googleapis.com/maps/api/geocode/json
```

**Paramètres transmis par le mobile :**

| Paramètre | Type | Obligatoire | Défaut | Description |
|-----------|------|-------------|--------|-------------|
| `latlng` | string | oui | — | Coordonnées au format `"lat,lng"` (ex: `"5.3599517,-4.0082563"`) |
| `language` | string | non | `"fr"` | Langue des résultats |
| `region` | string | non | `"ci"` | Biais régional |
| `key` | string | oui | — | Clé API Google *(gérée par le backend)* |

**Réponse attendue (champs utilisés dans le mobile) :**
```json
{
  "status": "OK",
  "results": [
    {
      "formatted_address": "Cocody, Abidjan, Côte d'Ivoire",
      "place_id": "ChIJ...",
      "geometry": {
        "location": { "lat": 5.3599517, "lng": -4.0082563 },
        "location_type": "ROOFTOP",
        "viewport": {
          "northeast": { "lat": 5.361, "lng": -4.007 },
          "southwest": { "lat": 5.358, "lng": -4.010 }
        }
      },
      "address_components": [
        { "long_name": "Cocody", "short_name": "Cocody", "types": ["sublocality"] },
        { "long_name": "Abidjan", "short_name": "Abidjan", "types": ["locality"] }
      ],
      "types": ["route"]
    }
  ]
}
```

**Fichiers source :**
- `lib/features/location_module/data/geocoding_api_provider.dart` (ligne 12)
- `lib/features/location_module/data/geocoding_api_repository.dart` (ligne 12)

---

### 5. Geocoding — Place ID → coordonnées

Utilisée pour convertir un `place_id` en coordonnées géographiques.

**Google Maps endpoint :**
```
GET https://maps.googleapis.com/maps/api/geocode/json
```
*(même endpoint que le reverse geocoding, paramètres différents)*

**Paramètres transmis par le mobile :**

| Paramètre | Type | Obligatoire | Défaut | Description |
|-----------|------|-------------|--------|-------------|
| `place_id` | string | oui | — | Identifiant Google du lieu |
| `latlng` | string | non | — | Optionnel |
| `language` | string | non | `"fr"` | Langue des résultats |
| `region` | string | non | `"ci"` | Biais régional |
| `key` | string | oui | — | Clé API Google *(gérée par le backend)* |

**Réponse attendue :** identique au reverse geocoding (voir ci-dessus).

**Fichiers source :**
- `lib/features/location_module/data/geocoding_api_provider.dart` (ligne 21)
- `lib/features/location_module/data/geocoding_api_repository.dart` (ligne 29)

---

## Tableau récapitulatif

| # | Endpoint backend suggéré | Méthode | Google Maps cible |
|---|--------------------------|---------|-------------------|
| 1 | `/location/autocomplete` | GET | Places Autocomplete |
| 2 | `/location/place-details` | GET | Place Details (legacy) |
| 3 | `/location/place-details-v1/{placeId}` | GET | Place Details (New API v1) |
| 4 | `/location/geocode/reverse` | GET | Geocoding (latlng → adresse) |
| 5 | `/location/geocode/place` | GET | Geocoding (place_id → coords) |

> **Note :** Les endpoints 4 et 5 peuvent être fusionnés en un seul `GET /location/geocode`
> avec les paramètres `latlng` et `place_id` mutuellement exclusifs.

---

## Recommandations pour le backend

1. **Centraliser la clé API** — La clé Google ne doit plus être présente dans le code mobile.
   Le backend l'injecte à chaque appel proxifié.

2. **Fixer les paramètres régionaux** — `language=fr`, `region=ci` et `components=country:ci`
   peuvent être fixés côté serveur sans les exposer dans l'API interne.

3. **Session tokens (Autocomplete)** — Le `sessiontoken` transmis par le mobile doit être
   relayé tel quel à Google pour optimiser la facturation (regroupe les appels autocomplete
   avec le place details associé).

4. **Mise en cache** — Les résultats de geocoding et de place details étant stables,
   un cache côté backend (Redis, etc.) peut réduire significativement les appels facturés.

5. **Clé API active hardcodée** — La clé `AIzaSyAbgTH8ePamGZiP3DutyAkMupCeJzTrfqE`
   est actuellement écrite en dur dans `places_api_repository.dart` (ligne 32).
   Elle doit être révoquée/rotatée une fois la migration backend effectuée.
