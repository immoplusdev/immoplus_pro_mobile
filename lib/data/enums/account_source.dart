import 'dart:io';

enum AccountSource {
  customerApp(value: "customer_app"),
  proApp(value: "pro_app");

  final String value;

  const AccountSource({required this.value});
}

/// Type d'application cliente auprès du backend
enum PushApp {
  client('client'),
  pro('pro');

  final String value;
  const PushApp(this.value);
}

/// Plateforme de l'appareil
enum PushPlatform {
  android('android'),
  ios('ios');

  final String value;
  const PushPlatform(this.value);

  static PushPlatform get current =>
      Platform.isIOS ? PushPlatform.ios : PushPlatform.android;
}

