import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
}
