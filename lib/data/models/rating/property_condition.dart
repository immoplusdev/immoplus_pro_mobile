import 'package:freezed_annotation/freezed_annotation.dart';

enum PropertyCondition {
  @JsonValue('Excellente')
  excellent('Excellente'),

  @JsonValue('Bonne')
  good('Bonne'),

  @JsonValue('À nettoyer')
  toClean('À nettoyer'),

  @JsonValue('Dégradée')
  degraded('Dégradée');

  final String label;
  const PropertyCondition(this.label);
}
