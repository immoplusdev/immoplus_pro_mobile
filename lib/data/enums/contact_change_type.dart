enum ContactChangeType {
  phone,
  email;

  static ContactChangeType fromString(String value) {
    return ContactChangeType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown ContactChangeType: $value'),
    );
  }

  String get toJson => name; // "phone" | "email"
}
