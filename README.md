# immoplus_pros

A new Flutter project.

## Getting Started. ...
   
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build Runner
`flutter pub run build_runner build --delete-conflicting-outputs`
`flutter pub run build_runner watch --delete-conflicting-outputs`

## Coding Rules
### Avoid Magic Values
Always avoid hardcoding magic values (padding, font sizes, colors, duration, etc.) directly in the UI code. 
Instead, create a private `_Constants` class within the file to manage these values. This improves maintainability and ensures consistency.

Example:
```dart
class _Constants {
  static const double horizontalPadding = 24.0;
  static const Color titleColor = Color(0xFF001B3D);
}
```

## Tester les notifications Push (Simulateur iOS)

Un dossier `notification_tests` a été créé à la racine du projet contenant plusieurs fichiers `.apns` pour simuler des clics sur des notifications push dans le simulateur iOS.

### Comment lancer un test :
1. Lancez l'application sur un **Simulateur iOS**.
2. **Méthode 1 (Drag & Drop) :** Prenez l'un des fichiers `.apns` depuis le Finder (par ex: `notification_tests/test_mktg_stats.apns`) et glissez-déposez le sur la fenêtre du simulateur.
3. **Méthode 2 (Terminal) :** Ouvrez votre terminal à la racine du projet et tapez :
   ```bash
   xcrun simctl push booted notification_tests/test_mktg_stats.apns
   ```
4. Cliquez sur la notification qui apparaît en haut du simulateur pour déclencher la redirection correspondante dans l'application.

### Tests disponibles :
- `test_rating.apns` : Ouvre la Bottom Sheet d'évaluation d'un séjour.
- `test_mktg_create_estate.apns` : Redirige vers la création d'un bien (`proOnbEnt02`).
- `test_mktg_residences.apns` : Redirige vers la liste des résidences (`proOnb03`).
- `test_mktg_stats.apns` : Redirige vers la page de statistiques (`proPerf01`).
- `test_mktg_calendar_am.apns` : Redirige vers le calendrier pour les arrivées du matin (`proCalDailyAm`).
- `test_mktg_calendar_season.apns` : Redirige vers le calendrier global (`proSeason02`).
