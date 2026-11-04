import 'package:immoplus_pro/utils/api_error_dialog.dart';
import 'package:immoplus_pro/data/enums/api_error_code.dart';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/core/error/error_presenter.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/authentification/authentification_page.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ErrorPresenter)
class UiErrorPresenter implements ErrorPresenter {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  Future<void> showDialog({
    required String title,
    required String message,
    String? actionLabel,
    FutureOr<void> Function()? onAction,
    String? reference,
  }) {
    return AppErrorDialog.show(
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction == null ? null : () => onAction(),
      reference: reference,
    );
  }

  @override
  void showToast({required String title, required String message}) {
    ToastUtils.showError(title: title, description: message);
  }

  bool _offlineDialogOpen = false;

  @override
  Future<void> showOfflineDialog({
    FutureOr<void> Function()? onRestored,
  }) async {
    if (_offlineDialogOpen) return;
    _offlineDialogOpen = true;

    _connectivitySub?.cancel();
    _connectivitySub = Connectivity().onConnectivityChanged.listen(
      (results) async {
        if (results.every((r) => r == ConnectivityResult.none)) return;
        _connectivitySub?.cancel();
        _connectivitySub = null;
        hideOfflineDialog();
        // Laisse le réseau devenir réellement utilisable avant de relancer.
        await Future<void>.delayed(const Duration(seconds: 1));
        await onRestored?.call();
      },
    );

    try {
      await AppErrorDialog.show(
        title: 'Pas de connexion',
        message: onRestored == null
            ? 'Vérifiez votre connexion internet puis réessayez.'
            : 'Vérifiez votre connexion internet. Votre demande sera '
                'relancée automatiquement dès le retour du réseau.',
      );
    } finally {
      _offlineDialogOpen = false;
      _connectivitySub?.cancel();
      _connectivitySub = null;
    }
  }

  @override
  void hideOfflineDialog() {
    if (!_offlineDialogOpen) return;
    final context = NavigationService.navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context, rootNavigator: true).maybePop();
    }
  }

  @override
  bool showDedicatedDialog(ApiErrorCode code, {String? message}) {
    if (!code.hasDedicatedDialog) return false;
    ApiErrorDialog.showForCode(code, message: message);
    return true;
  }

  @override
  void openSignIn() {
    AppRouter.router.pushNamed(AuthenticationPage.name);
  }
}
