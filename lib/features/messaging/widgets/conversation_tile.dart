import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/utils/utils.dart';

import '../../../data/models/remote/messaging/conversation_model.dart';
import '../utils/messaging_time_format.dart';

class _TileInfo {
  final String title;
  final String? photoUrl;
  final String clientName;

  const _TileInfo({required this.title, this.photoUrl, required this.clientName});
}

/// Ligne de la liste de l'inbox : rendu conditionnel par `type` (résidence,
/// demande de visite, ou support), nom du client, dernier message et badge
/// non-lu. Jamais les coordonnées (email/tel) du client.
class ConversationTile extends StatefulWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  final ConversationModel conversation;
  final VoidCallback onTap;

  @override
  State<ConversationTile> createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  /// Cache partagé entre toutes les tuiles, pour la durée de vie de l'app —
  /// évite de refetch résidence/bien à chaque rebuild/scroll.
  static final Map<String, Future<_TileInfo>> _cache = {};

  Future<_TileInfo> _infoFuture() {
    final conversation = widget.conversation;
    switch (conversation.typeEnum) {
      case ConversationType.support:
        return Future.value(
          const _TileInfo(title: 'Support ImmoPlus', clientName: 'Vous'),
        );
      case ConversationType.visite:
        final id = conversation.visiteId;
        if (id == null) {
          return Future.value(
              const _TileInfo(title: 'Demande de visite', clientName: 'Client'));
        }
        final key = 'visite:$id';
        return _cache.putIfAbsent(key, () async {
          try {
            final response = await BienImmobilierRepository.getVisit(id: id);
            final bien = response.data.bienImmobilier;
            final client = response.data.client;
            final clientName = (client?.firstName.isNotEmpty ?? false)
                ? client!.firstName
                : 'Client';
            return _TileInfo(
              title: bien?.nom.isNotEmpty == true ? bien!.nom : 'Bien immobilier',
              photoUrl: bien?.miniature,
              clientName: clientName,
            );
          } catch (_) {
            return const _TileInfo(
                title: 'Bien immobilier', clientName: 'Client');
          }
        });
      case ConversationType.reservation:
        final id = conversation.residenceId;
        if (id == null) {
          return Future.value(
              const _TileInfo(title: 'Résidence', clientName: 'Client'));
        }
        final key = 'residence:$id';
        return _cache.putIfAbsent(key, () async {
          try {
            final response = await LogmentRepository.getResidence(id);
            final residence = response.data;
            return _TileInfo(
              title: residence.nom.isNotEmpty ? residence.nom : 'Résidence',
              photoUrl: residence.miniature,
              // Pas d'identité client résolue au niveau résidence côté API
              // Pro (pas d'endpoint "profil client par id") — libellé
              // générique plutôt qu'un nom non fiable.
              clientName: 'Client',
            );
          } catch (_) {
            return const _TileInfo(title: 'Résidence', clientName: 'Client');
          }
        });
    }
  }

  IconData get _fallbackIcon => widget.conversation.typeEnum ==
          ConversationType.support
      ? Icons.support_agent_outlined
      : Icons.home_outlined;

  @override
  Widget build(BuildContext context) {
    final conversation = widget.conversation;
    final hasUnread = conversation.unreadCountPro > 0;
    final isBlocked = conversation.statusEnum == ConversationStatus.blocked;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        color: hasUnread ? AppColors.primary.withValues(alpha: 0.03) : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: FutureBuilder<_TileInfo>(
          future: _infoFuture(),
          builder: (context, snapshot) {
            final info = snapshot.data;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: info?.photoUrl != null
                        ? CachedNetworkImage(
                            imageUrl: Utils.getImagePath(id: info!.photoUrl!),
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.grey.shade100,
                              child:
                                  Icon(_fallbackIcon, color: Colors.grey.shade400),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade100,
                            child:
                                Icon(_fallbackIcon, color: Colors.grey.shade400),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              info?.title ?? '…',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    hasUnread ? FontWeight.w700 : FontWeight.w600,
                                color: const Color(0xFF1F2937),
                              ),
                            ),
                          ),
                          Text(
                            formatLastMessageRelative(conversation.lastMessageAt),
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        info?.clientName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.5, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.lastMessagePreview ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: hasUnread
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: hasUnread
                                    ? const Color(0xFF1F2937)
                                    : Colors.grey.shade500,
                              ),
                            ),
                          ),
                          if (isBlocked) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('Bloqué',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.red.shade700)),
                            ),
                          ],
                          if (hasUnread) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                conversation.unreadCountPro > 99
                                    ? '99+'
                                    : '${conversation.unreadCountPro}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
