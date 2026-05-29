# immoplus_pro

A new Flutter project.

## Getting Started

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