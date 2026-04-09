import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/services/navigation_service.dart';

class AppDialog {
  static Future info(
          {required BuildContext context,
          required String content,
          required Widget icon,
          void Function()? rollback,
          bool barrierDismissible = false,
          String? textButton}) async =>
      showCupertinoModalPopup(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: icon,
          content: Text(
            content,
            style: GoogleFonts.inter(
              //fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: false,
              onPressed: rollback ??
                  () {
                    Navigator.pop(context);
                  },
              child: Text(textButton ?? 'OK'),
            ),
          ],
        ),
      ).then((value) {
        print('TOTO');
      });

  static Future confirm(
          {required BuildContext context,
          required String content,
          void Function()? rollback}) async =>
      showCupertinoModalPopup(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Icon(
            CupertinoIcons.exclamationmark_triangle,
            color: Colors.red,
          ),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Retour'),
              onPressed: () {
                context.pop();
              },
            ),
            CupertinoDialogAction(
              onPressed: rollback ??
                  () {
                    context.pop();
                  },
              child: const Text('Confirmer'),
            ),
          ],
        ),
      ).then((value) {
        print('TOTO');
      });

  static Future<bool?> confirmDialog({
    required BuildContext context,
    required String content,
  }) async =>
      showCupertinoModalPopup<bool?>(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Icon(
            CupertinoIcons.exclamationmark_triangle,
            color: Colors.red,
          ),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Retour'),
              onPressed: () {
                context.pop(false);
              },
            ),
            CupertinoDialogAction(
              onPressed: () {
                context.pop(true);
              },
              child: const Text('Confirmer'),
            ),
          ],
        ),
      );

  /// Dialog avec titre, description, bouton primaire (filled) et bouton secondaire optionnel (outlined).
  /// Le bouton secondaire s'affiche au-dessus du bouton primaire.
  static Future<void> show(
      {required String title,
      required String description,
      required String primaryButtonText,
      String? secondButtonText,
      VoidCallback? onPrimary,
      VoidCallback? onSecond,
      bool barrierDismissible = true,
      BuildContext? context}) {
    return showDialog<void>(
      context: context ?? NavigationService.navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                if (secondButtonText != null) ...[
                  SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        onSecond?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        secondButtonText,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                CustomButtom(
                  text: primaryButtonText,
                  borderRadius: BorderRadius.circular(28),
                  onClick: () {
                    Navigator.of(ctx).pop();
                    onPrimary?.call();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
