import 'package:immoplus_pro/common/enums.dart';
import 'package:isar_community/isar.dart';

part 'user_model_schema.g.dart';

@collection
class UserModelSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? userId;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  @Index(unique: true, replace: true)
  String? email;
  String? accessToken;
  String? refreshToken;
  String? roleName;
  String? activite;
  String? nomEntreprise;
  String? emailEntreprise;
  String? photoIdentite;
  String? pieceIdentite;
  String? avatar;
  String? role;

  /// return true if user is an  professional Company
  bool get isEntreprise => roleName == Roles.pro_entreprise.name;
  // bool get isEntreprise => true;

  /// Retourne le nom à afficher : nomEntreprise si isEntreprise, sinon firstName
  String get displayName => isEntreprise ? (nomEntreprise ?? '') : (firstName ?? '');

  /// Retourne le texte de salutation complet
  String get greetingText =>
      isEntreprise ? 'Entreprise : $displayName' : 'Bonjour, $displayName 👋';
}
