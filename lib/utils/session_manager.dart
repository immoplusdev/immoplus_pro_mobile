import 'dart:developer';

import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/authentification/authentification_page.dart';
import 'package:immoplus_pro/features/login_page/login_page.dart';
import 'package:immoplus_pro/features/onboarding/data/onboarding_entity.dart';
import 'package:immoplus_pro/main.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

@singleton
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  UserModelSchema? currentUser;

  // Future<void> init() async {
  //   if (isarInstance == null) {
  //     isarInstance = await Isar.open([UserModelSchema]);
  //   }
  // }

  Future<void> saveUser(UserModelSchema user) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.userModelSchemas.put(user);
    });
    currentUser = user;
  }

  Future<UserModelSchema?> getCurrentUser() async {
    if (currentUser == null) {
      final user = await isarInstance.userModelSchemas.where().findFirst();
      if (user != null) {
        currentUser = user;
      }
    }
    print('Get User from Session: $currentUser');
    return currentUser;
  }

  Future<void> clearSession() async {
    await isarInstance.writeTxn(() async {
      await isarInstance.userModelSchemas.clear();
    });
    currentUser = null;
  }

  /// logout user clear session and navigate to login page
  Future<void> logout() async {
    await clearSession();
    AppRouter.router.goNamed(AuthenticationPage.name);
  }

  // Fonction qui sera exécutée dans le nouvel isolat
  Future<UserModelSchema?> getUserInIsolate() async {
    // Nous n'avons pas besoin du chemin du dossier ici étant donné que l'instance est déjà ouverte.
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [UserModelSchemaSchema],
      directory: dir.path,
      name: 'second',
    );
    return await isar.userModelSchemas.get(1);
  }

  /// Marque l'onboarding comme lu/vu par l'utilisateur
  Future<void> markOnboardingAsRead() async {
    await isarInstance.writeTxn(() async {
      await isarInstance.onboardingEntitys.put(
        OnboardingEntity()
          ..hasReadOnboarding = true
          ..readAt = DateTime.now(),
      );
    });
    log("Onboarding marked as read");
  }

  /// Vérifie si l'utilisateur a déjà vu l'onboarding
  Future<bool> hasReadOnboarding() async {
    final onboardingData =
        await isarInstance.onboardingEntitys.where().findFirst();
    final hasRead = onboardingData?.hasReadOnboarding ?? false;
    log("Has read onboarding: $hasRead");
    return hasRead;
  }

  /// Réinitialise le statut de l'onboarding (utile pour les tests)
  Future<void> resetOnboarding() async {
    await isarInstance.writeTxn(() async {
      await isarInstance.onboardingEntitys.clear();
    });
    log("Onboarding reset");
  }
}
