import 'package:isar/isar.dart';
part 'onboarding_entity.g.dart';

@collection
class OnboardingEntity {
  Id id = 1;
  bool? opened;

  OnboardingEntity({required this.id, required this.opened});
}
