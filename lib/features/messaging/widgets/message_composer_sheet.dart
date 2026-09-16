import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/messaging_repository.dart';

import '../logic/conversation_thread_cubit.dart';
import '../pages/message_thread_page.dart';

/// Bottom sheet "Nouveau ticket support" — seul point d'entrée où le pro
/// peut initier une conversation (jamais pour `reservation`/`visite`).
class MessageComposerSheet extends StatefulWidget {
  const MessageComposerSheet({super.key});

  static Future<void> showForSupport(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (_) => const MessageComposerSheet(),
    );
  }

  @override
  State<MessageComposerSheet> createState() => _MessageComposerSheetState();
}

class _MessageComposerSheetState extends State<MessageComposerSheet> {
  final _controller = TextEditingController();
  bool _isSending = false;
  String? _moderationBanner;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSend => _controller.text.trim().isNotEmpty && !_isSending;

  Future<void> _send() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;
    setState(() {
      _isSending = true;
      _moderationBanner = null;
    });

    try {
      final response =
          await MessagingRepository.createSupportConversation(message: message);
      if (!mounted) return;
      Navigator.of(context).pop();
      context.pushNamed(
        MessageThreadPage.name,
        pathParameters: {'conversationId': response.conversation.id},
      );
    } on DioException catch (dioError) {
      final statusCode = dioError.response?.statusCode;
      final data = dioError.response?.data;
      final code = data is Map ? data['code']?.toString() : null;

      if (statusCode == 403) {
        if (!mounted) return;
        Navigator.of(context).pop();
        EasyLoading.showError("Vous n'avez pas accès à cette action.");
        return;
      }
      if (code == 'CONTACT_INFO_DETECTED') {
        setState(() {
          _isSending = false;
          _moderationBanner =
              data is Map ? data['message']?.toString() : null;
          _moderationBanner ??= kContactInfoDetectedFallbackMessage;
        });
        return;
      }
      setState(() => _isSending = false);
      EasyLoading.showError("Le message n'a pas pu être envoyé. Réessayer.");
    } catch (_) {
      setState(() => _isSending = false);
      EasyLoading.showError("Le message n'a pas pu être envoyé. Réessayer.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contacter le support',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Notre équipe vous répond généralement sous quelques heures.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            if (_moderationBanner != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.redFF0000.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.redFF0000.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _moderationBanner!,
                  style: TextStyle(fontSize: 13, color: AppColors.redFF0000),
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _controller,
              maxLines: 4,
              minLines: 3,
              enabled: !_isSending,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                if (_moderationBanner != null) {
                  setState(() => _moderationBanner = null);
                }
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Décrivez votre problème…',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _canSend ? _send : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  disabledForegroundColor: Colors.grey.shade400,
                  side: BorderSide(
                    color: _canSend ? AppColors.primary : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                child: _isSending
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.primary),
                      )
                    : const Text(
                        'Envoyer',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
