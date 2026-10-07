import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

import 'actions/quick_replies_sheet.dart';

/// Composer bas d'écran du fil : champ extensible + boutons d'action & d'envoi.
class MessageComposerBar extends StatefulWidget {
  const MessageComposerBar({
    super.key,
    required this.onChanged,
    required this.onSend,
    this.onOpenActions,
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSend;
  final VoidCallback? onOpenActions;

  @override
  State<MessageComposerBar> createState() => _MessageComposerBarState();
}

class _MessageComposerBarState extends State<MessageComposerBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    setState(() => _hasText = false);
  }

  void _openQuickReplies() {
    QuickRepliesSheet.show(
      context,
      onSelectReply: (replyText) {
        _controller.text = replyText;
        widget.onChanged(replyText);
        setState(() => _hasText = replyText.trim().isNotEmpty);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.onOpenActions != null)
            IconButton(
              onPressed: widget.onOpenActions,
              tooltip: 'Actions du fil',
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.add,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          IconButton(
            onPressed: _openQuickReplies,
            tooltip: 'Réponses rapides',
            icon: Icon(
              Iconsax.flash_1,
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 120),
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                maxLength: 2000,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) =>
                    const SizedBox.shrink(),
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Écrire un message…',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                onChanged: (value) {
                  widget.onChanged(value);
                  final hasText = value.trim().isNotEmpty;
                  if (hasText != _hasText) setState(() => _hasText = hasText);
                },
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: _hasText ? _send : null,
            icon: Icon(
              Iconsax.send_1,
              color: _hasText ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}
