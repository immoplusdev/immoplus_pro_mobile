import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/messaging_repository.dart';

class QuickRepliesSheet extends StatefulWidget {
  const QuickRepliesSheet({
    super.key,
    required this.onSelectReply,
  });

  final ValueChanged<String> onSelectReply;

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<String> onSelectReply,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (_) => QuickRepliesSheet(onSelectReply: onSelectReply),
    );
  }

  @override
  State<QuickRepliesSheet> createState() => _QuickRepliesSheetState();
}

class _QuickRepliesSheetState extends State<QuickRepliesSheet> {
  List<String> _replies = [];
  bool _isLoading = true;
  bool _isEditing = false;
  final _newController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReplies();
  }

  @override
  void dispose() {
    _newController.dispose();
    super.dispose();
  }

  Future<void> _loadReplies() async {
    try {
      final list = await MessagingRepository.getQuickReplies();
      if (mounted) {
        setState(() {
          _replies = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addReply() async {
    final text = _newController.text.trim();
    if (text.isEmpty) return;
    if (_replies.length >= 10) {
      EasyLoading.showError('Maximum 10 réponses rapides autorisées.');
      return;
    }
    final updated = [..._replies, text];
    setState(() => _replies = updated);
    _newController.clear();
    await _save(updated);
  }

  Future<void> _removeReply(int index) async {
    final updated = List<String>.from(_replies)..removeAt(index);
    setState(() => _replies = updated);
    await _save(updated);
  }

  Future<void> _save(List<String> list) async {
    try {
      await MessagingRepository.updateQuickReplies(list);
    } catch (_) {
      EasyLoading.showError('Erreur de sauvegarde des réponses rapides.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.flash_1, color: Color(0xFF2563EB), size: 24),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Réponses rapides',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(_isEditing ? Iconsax.tick_circle : Iconsax.edit_2, size: 20),
                onPressed: () => setState(() => _isEditing = !_isEditing),
              ),
            ],
          ),
          Text(
            'Touchez une réponse pour l\'insérer dans le compositeur.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_replies.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Aucune réponse rapide configurée.',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _replies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final text = _replies[index];
                  return InkWell(
                    onTap: _isEditing
                        ? null
                        : () {
                            widget.onSelectReply(text);
                            Navigator.of(context).pop();
                          },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              text,
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF1E293B)),
                            ),
                          ),
                          if (_isEditing)
                            IconButton(
                              icon: Icon(Iconsax.trash,
                                  size: 18, color: AppColors.redFF0000),
                              onPressed: () => _removeReply(index),
                            )
                          else
                            Icon(Iconsax.arrow_right_3,
                                size: 16, color: Colors.grey.shade400),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (_isEditing && _replies.length < 10) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newController,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Ajouter une réponse rapide...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Iconsax.add_circle, color: AppColors.primary),
                  onPressed: _addReply,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
