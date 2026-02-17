/// Statuts possibles d'un meuble côté backend.
///
/// - [active]   → Meuble visible et disponible (valeur par défaut)
/// - [inactive] → Meuble masqué temporairement
/// - [deleted]  → Meuble supprimé logiquement (soft delete)
enum FurnitureStatus {
  active,
  inactive,
  deleted;
}
