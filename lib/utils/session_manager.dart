import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/cubits/banners/banners_cubit.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/data/models/configs/config_model.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/authentification/authentification_page.dart';
import 'package:immoplus_pro/features/onboarding/data/onboarding_entity.dart';
import 'package:immoplus_pro/main.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';

@singleton
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  UserModelSchema? currentUser;

  ConfigModel? configModel = ConfigModel.fromJson({
    "data": {
      "id": "6133a1fd-3292-42d8-9d1a-c37c57cac7ca",
      "websiteUrl": null,
      "normalVisitPrice": 100,
      "expressVisitPrice": 100,
      "pourcentageCommissionReservation": 1,
      "projectName": "My Project",
      "projectUrl": null,
      "smsSenderName": null,
      "proximityRadius": null,
      "standardShippingPrice": null,
      "flashShippingPrice": null,
      "contactEmail": "support@immoplus.ci",
      "contactPhoneNumber": "2250720154645",
      "createdAt": "2024-08-19T16:16:50.682Z",
      "updatedAt": "2024-08-27T11:08:45.420Z",
      "deletedAt": null,
      "categories": [],
      "categoryPaymentTypes": [],
      "defaultStatus": [],
      "galleryGroups": [],
      "languages": [],
      "orderPaymentTypes": [],
      "paymentStatus": [],
      "productTypes": [],
      "servicePaymentTypes": [],
      "serviceStatus": [],
      "shippingStatus": [],
      "shippingTypes": [],
      "visitPaymentTypes": [],
      "typesResidence": [
        {"text": "Appartement", "value": "appartement"},
        {"text": "Maison", "value": "maison"},
        {"text": "Villa", "value": "villa"}
      ],
      "typesDemandeVisite": [
        {"text": "all.enum.express", "value": "express"},
        {"text": "all.enum.normal", "value": "normal"}
      ]
    }
  });

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
    try {
      final context = NavigationService.navigatorKey.currentContext;
      if (context != null) {
        context.read<BannersCubit>().stopPolling();
      }
    } catch (e) {
      log('SessionManager: Error stopping banners polling on logout: $e');
    }
    await clearSession();
    OneSignal.logout();
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
