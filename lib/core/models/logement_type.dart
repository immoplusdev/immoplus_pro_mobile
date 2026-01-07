class PropertyType {
  final String icon;
  final String text;
  final String label;

  const PropertyType({
    required this.icon,
    required this.text,
    required this.label,
  });

  // Méthode utile pour la comparaison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyType &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          text == other.text;

  @override
  int get hashCode => icon.hashCode ^ text.hashCode;
}
