import 'package:flutter/material.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/widgets/figma_toast.dart';
import 'package:toastification/toastification.dart';

class ToastUtils {
  static const Duration _defaultDuration = Duration(seconds: 5);

  static BuildContext get _ctx =>
      NavigationService.navigatorKey.currentContext!;

  static void showError({
    String? title,
    String? description,
    Duration? duration,
    Alignment? alignment,
  }) =>
      showCustomToast(
        type: FigmaToastType.error,
        title: title ?? 'Une erreur est survenue',
        description: description,
        duration: duration,
        alignment: alignment,
      );

  static void showSuccess({
    String? title,
    String? description,
    Duration? duration,
    Alignment? alignment,
  }) =>
      showCustomToast(
        type: FigmaToastType.success,
        title: title ?? 'Opération réussie',
        description: description,
        duration: duration,
        alignment: alignment,
      );

  static void showInfo({
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
  }) =>
      showCustomToast(
        type: FigmaToastType.info,
        title: title,
        description: description,
        duration: duration,
        alignment: alignment,
      );

  static void showWarning({
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
  }) =>
      showCustomToast(
        type: FigmaToastType.warning,
        title: title,
        description: description,
        duration: duration,
        alignment: alignment,
      );

  // ── Raccourcis ────────────────────────────────────────────────────────────

  static void error(String? message) =>
      showError(title: message ?? 'Une erreur est survenue');

  static void success(String? message) =>
      showSuccess(title: message ?? 'Opération effectuée avec succès');

  static void info(String message) => showInfo(title: message);

  static void warning(String message) => showWarning(title: message);

  static void dismissAll() => toastification.dismissAll();

  static void showCustomToast({
    required FigmaToastType type,
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
  }) {
    toastification.showCustom(
      context: _ctx,
      autoCloseDuration: duration ?? _defaultDuration,
      alignment: alignment ?? Alignment.bottomCenter,
      builder: (context, holder) => FigmaToast(
        type: type,
        title: title,
        description: description,
        holder: holder,
      ),
    );
  }
}
