class CatalogItem {
  const CatalogItem({
    required this.code,
    required this.label,
    this.icon,
    this.countKey,
    this.description,
  });

  final String code;
  final String label;
  final String? icon;

  /// Clé du compteur dans `roomCounts` (catalogue pièces et couchages).
  final String? countKey;
  final String? description;

  factory CatalogItem.fromJson(Map<String, dynamic> json) => CatalogItem(
        code: json['code'] as String,
        label: json['label'] as String,
        icon: json['icon'] as String?,
        countKey: json['countKey'] as String?,
        description: json['description'] as String?,
      );
}

class CatalogGroup {
  const CatalogGroup({
    required this.key,
    required this.label,
    required this.items,
  });

  final String key;
  final String label;
  final List<CatalogItem> items;

  factory CatalogGroup.fromJson(Map<String, dynamic> json) => CatalogGroup(
        key: json['key'] as String,
        label: json['label'] as String,
        items: (json['items'] as List)
            .map((e) => CatalogItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
