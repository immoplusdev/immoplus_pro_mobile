import 'package:freezed_annotation/freezed_annotation.dart';

enum GuestBehavior {
  @JsonValue('Respectueux')
  respectful('Respectueux'),

  @JsonValue('Acceptable')
  acceptable('Acceptable'),

  @JsonValue('Problématique')
  problematic('Problématique');

  final String label;
  const GuestBehavior(this.label);
}
