import 'package:isar/isar.dart';
part 'onboarding_entity.g.dart';

@collection
class OnboardingEntity {
  Id id = 1;

  /// Indique si l'utilisateur a déjà vu l'onboarding
  late bool hasReadOnboarding;

  /// Date à laquelle l'utilisateur a vu l'onboarding
  DateTime? readAt;
}
