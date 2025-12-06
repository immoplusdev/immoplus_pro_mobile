import 'package:isar_community/isar.dart';

part 'onboarding_schema.g.dart';

@collection
class OnboardingSchema {
  Id id = Isar.autoIncrement;
  DateTime? date;
}
