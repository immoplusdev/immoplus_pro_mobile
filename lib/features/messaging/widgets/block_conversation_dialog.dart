import 'package:flutter/cupertino.dart';

/// Confirmation de blocage, calquée sur la convention Cupertino déjà
/// utilisée pour les dialogues destructifs (`account_page_v2.dart` —
/// déconnexion/suppression de compte).
Future<void> showBlockConversationDialog(
  BuildContext context, {
  required String peerLabel,
  required Future<bool> Function() onConfirm,
}) {
  return showCupertinoDialog<void>(
    context: context,
    builder: (dialogContext) {
      bool isLoading = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return CupertinoAlertDialog(
            title: Text('Bloquer $peerLabel ?'),
            content: const Text(
              'Vous ne pourrez plus envoyer ni recevoir de messages dans '
              'cette conversation.',
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed:
                    isLoading ? null : () => Navigator.of(dialogContext).pop(),
                child: const Text('Annuler'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);
                        await onConfirm();
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      },
                child: isLoading
                    ? const CupertinoActivityIndicator()
                    : const Text('Bloquer'),
              ),
            ],
          );
        },
      );
    },
  );
}
