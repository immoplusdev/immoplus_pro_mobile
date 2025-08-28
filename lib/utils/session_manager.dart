import 'dart:developer';

import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/login_page/login_page.dart';
import 'package:immoplus_pro/features/onboarding/data/onboarding_entity.dart';
import 'package:immoplus_pro/main.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

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
    AppRouter.router.goNamed(LoginPage.name);
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

  Future<bool> appIsAlreadyOpened() async {
    return isarInstance.writeTxn<bool>(
      () async {
        final data = await isarInstance.onboardingEntitys.get(1);
        if (data != null) {
          log("OPENED TRUE");
          return true;
        } else {
          log("OPENED FALSE");
          return false;
        }
      },
    );
  }
}
