import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/calendar/calendar_page_v2.dart';
import 'package:immoplus_pro/features/estate_detail/estate_details_page_v2.dart';
import 'package:immoplus_pro/features/residence_detail/residence_details_page_v2.dart';
import 'package:immoplus_pro/features/visits/visit_detail_page.dart';
import 'package:immoplus_pro/utils/utils.dart';

import '../../../data/models/remote/messaging/conversation_model.dart';
import '../../../data/models/remote/messaging/message_model.dart';
import '../logic/conversation_thread_cubit.dart';
import '../logic/conversation_thread_state.dart';
import '../utils/messaging_time_format.dart';
import '../widgets/block_conversation_dialog.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer_bar.dart';
import '../widgets/report_conversation_sheet.dart';
import '../widgets/thread_typing_indicator.dart';

class MessageThreadPage extends StatelessWidget {
  const MessageThreadPage({super.key, required this.conversationId});

  final String conversationId;

  static const String routePath = '/messages/:conversationId';
  static const String name = 'message_thread';

  static String route({required String id}) => '/messages/$id';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConversationThreadCubit>()..load(conversationId),
      child: const _ThreadView(),
    );
  }
}

class _ThreadView extends StatefulWidget {
  const _ThreadView();

  @override
  State<_ThreadView> createState() => _ThreadViewState();
}

class _ThreadViewState extends State<_ThreadView> {
  final _scrollController = ScrollController();
  ResidenceModel? _residence;
  DemandeVisiteModel? _visitData;
  String? _peerName;
  bool _sideEffectsLoaded = false;
  int _lastMessageCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Libellé par défaut de l'interlocuteur (le client) selon le type, tant
  /// que le vrai nom n'est pas résolu (ou pour `support`, qui n'en a pas).
  String _defaultPeerLabel(ConversationType type) {
    switch (type) {
      case ConversationType.support:
        return 'Support ImmoPlus';
      case ConversationType.visite:
      case ConversationType.reservation:
        return 'Client';
    }
  }

  Future<void> _loadSideEffects(ConversationModel conversation) async {
    if (_sideEffectsLoaded) return;
    _sideEffectsLoaded = true;

    switch (conversation.typeEnum) {
      case ConversationType.reservation:
        final residenceId = conversation.residenceId;
        if (residenceId != null) {
          try {
            final residence = await LogmentRepository.getResidence(residenceId);
            if (mounted) setState(() => _residence = residence.data);
          } catch (_) {}
        }
        // Pas d'endpoint "profil client par id" côté Pro — le nom du client
        // reste au libellé générique par défaut pour ce type.
        break;

      case ConversationType.visite:
        final visiteId = conversation.visiteId;
        if (visiteId != null) {
          try {
            final response =
                await BienImmobilierRepository.getVisit(id: visiteId);
            if (!mounted) return;
            setState(() {
              _visitData = response.data;
              final firstName = response.data.client?.firstName;
              if (firstName != null && firstName.isNotEmpty) {
                _peerName = firstName;
              }
            });
          } catch (_) {}
        }
        break;

      case ConversationType.support:
        // Pas d'identité individuelle — libellé fixe.
        break;
    }
  }

  void _scrollToBottomIfNeeded(int messageCount) {
    if (messageCount == _lastMessageCount) return;
    // Premier lot chargé (0 → N) : atterrissage instantané, pas d'animation
    // qui ferait défiler tout l'historique sous les yeux de l'utilisateur.
    // Nouveau message pendant que le fil est déjà ouvert : petit défilement
    // animé, plus fluide qu'un saut brut.
    final isInitialLoad = _lastMessageCount == 0;
    _lastMessageCount = messageCount;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final target = _scrollController.position.maxScrollExtent;
      if (isInitialLoad) {
        _scrollController.jumpTo(target);
      } else {
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Présence non affichée pour `support` (pas d'interlocuteur fixe — pas de
  /// promesse de délai que le backend ne garantit pas).
  String _presenceLabel(ConversationThreadLoaded state) {
    if (state.conversation.typeEnum == ConversationType.support) return '';
    final peer = state.peerPresence;
    if (peer == null) return '';
    if (peer.online) return 'En ligne';
    if (peer.lastSeenAt != null) return formatLastSeen(peer.lastSeenAt!);
    return '';
  }

  void _showVisitDetailSheet(BuildContext context, String visiteId) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.60,
        child: VisitDetailPage(id: visiteId),
      ),
    );
  }

  void _openMenu(BuildContext context, ConversationThreadLoaded state) {
    final conversation = state.conversation;
    final isBlocked = conversation.statusEnum == ConversationStatus.blocked;
    final type = conversation.typeEnum;
    final peerLabel = _peerName ?? _defaultPeerLabel(type);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (type == ConversationType.reservation &&
                conversation.residenceId != null) ...[
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Voir la résidence'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.pushNamed(
                    ResidenceDetailsPageV2.name,
                    pathParameters: {'id': conversation.residenceId!},
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('Gérer disponibilité'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.go(CalendarPageV2.routePath);
                },
              ),
            ],
            if (type == ConversationType.visite &&
                _visitData?.bienImmobilier != null) ...[
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Voir le bien'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.pushNamed(
                    EstateDetailsPageV2.name,
                    pathParameters: {'id': _visitData!.bienImmobilier!.id},
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.event_note_outlined),
                title: const Text('Voir la demande de visite'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _showVisitDetailSheet(context, _visitData!.id);
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('Signaler'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                ReportConversationSheet.show(
                  context,
                  onSubmit: ({required reason, details}) => context
                      .read<ConversationThreadCubit>()
                      .report(reason: reason, details: details),
                );
              },
            ),
            // "Bloquer" n'a pas de sens pour le support : boîte partagée,
            // pas d'interlocuteur unique à bloquer.
            if (!isBlocked && type != ConversationType.support)
              ListTile(
                leading: Icon(Icons.block, color: AppColors.redFF0000),
                title: Text('Bloquer',
                    style: TextStyle(color: AppColors.redFF0000)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  final cubit = context.read<ConversationThreadCubit>();
                  showBlockConversationDialog(
                    context,
                    peerLabel: peerLabel,
                    onConfirm: () async {
                      final ok = await cubit.block();
                      if (!ok && context.mounted) {
                        EasyLoading.showError('Le blocage a échoué. Réessayer.');
                      }
                      return ok;
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<ConversationThreadCubit, ConversationThreadState>(
          listener: (context, state) {
            if (state is ConversationThreadLoaded) {
              _loadSideEffects(state.conversation);
              _scrollToBottomIfNeeded(state.messages.length);
            }
          },
          builder: (context, state) {
            if (state is ConversationThreadLoading) {
              // Toujours un moyen de sortir même si le chargement traîne
              // (réseau lent) — jamais un écran figé sans retour possible.
              return Column(
                children: [
                  _MinimalHeader(onBack: () => Navigator.of(context).maybePop()),
                  const Expanded(
                      child: Center(child: CircularProgressIndicator())),
                ],
              );
            }
            if (state is ConversationThreadError) {
              return Column(
                children: [
                  _MinimalHeader(onBack: () => Navigator.of(context).maybePop()),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wifi_off,
                                size: 40, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(state.message, textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () =>
                                  context.read<ConversationThreadCubit>().retry(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(color: AppColors.primary),
                              ),
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            final loaded = state as ConversationThreadLoaded;
            final isBlocked =
                loaded.conversation.statusEnum == ConversationStatus.blocked;
            final type = loaded.conversation.typeEnum;
            final peerLabel = _peerName ?? _defaultPeerLabel(type);

            // Carte de contexte façon Airbnb (comme côté client) : premier
            // élément du fil, pas un bandeau figé — elle défile avec la
            // conversation. Alignée à gauche, côté client/peer : c'est sa
            // demande, pas un message du pro.
            Widget? topCard;
            if (type == ConversationType.reservation && _residence != null) {
              topCard = _ResidenceContextCard(
                  residence: _residence!,
                  residenceId: loaded.conversation.residenceId!);
            }

            return Column(
              children: [
                _Header(
                  peerLabel: peerLabel,
                  isSupport: type == ConversationType.support,
                  presenceLabel: _presenceLabel(loaded),
                  onMenuTap: () => _openMenu(context, loaded),
                ),
                if (type == ConversationType.visite &&
                    _visitData?.bienImmobilier != null)
                  _VisiteContextCard(visitData: _visitData!)
                else if (type == ConversationType.support)
                  const _SupportContextBanner(),
                Expanded(
                  child: _MessageList(
                    scrollController: _scrollController,
                    state: loaded,
                    peerName: peerLabel,
                    isSupport: type == ConversationType.support,
                    topCard: topCard,
                  ),
                ),
                if (loaded.moderationBannerMessage != null)
                  _ModerationBanner(message: loaded.moderationBannerMessage!),
                if (isBlocked)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.shade100,
                    child: Text(
                      'Vous ne pouvez plus échanger de messages dans cette conversation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  )
                else
                  MessageComposerBar(
                    onChanged: (_) => context
                        .read<ConversationThreadCubit>()
                        .onComposerTextChanged(),
                    onSend: (text) =>
                        context.read<ConversationThreadCubit>().sendText(text),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// En-tête réduit (juste le retour) pour les états chargement/erreur —
/// évite un écran sans aucun moyen de sortir si le réseau traîne.
class _MinimalHeader extends StatelessWidget {
  const _MinimalHeader({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.peerLabel,
    required this.isSupport,
    required this.presenceLabel,
    required this.onMenuTap,
  });

  final String peerLabel;
  final bool isSupport;
  final String presenceLabel;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final isOnline = presenceLabel == 'En ligne';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryLite,
            child: Icon(
              isSupport ? Icons.support_agent_outlined : Icons.person,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(peerLabel,
                    style:
                        const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                if (presenceLabel.isNotEmpty)
                  Semantics(
                    label: presenceLabel,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isOnline) ...[
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: AppColors.green1CA53F,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          presenceLabel,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: onMenuTap,
          ),
        ],
      ),
    );
  }
}

/// Carte de contexte résidence — premier élément du fil, alignée à gauche
/// (côté client/peer : c'est sa demande, pas un message envoyé par le pro,
/// même logique que les bulles de [MessageBubble]). Contrairement au fil
/// côté client (qui propose "Réserver"/"Payer"), le pro n'a pas de flux de
/// paiement à afficher ici : c'est un raccourci de gestion, pas un CTA
/// consommateur.
class _ResidenceContextCard extends StatelessWidget {
  const _ResidenceContextCard(
      {required this.residence, required this.residenceId});
  final ResidenceModel residence;
  final String residenceId;

  @override
  Widget build(BuildContext context) {
    final coverImageId = (residence.miniature?.isNotEmpty ?? false)
        ? residence.miniature
        : (residence.images.isNotEmpty ? residence.images.first : null);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 2 / 3),
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Demande reçue pour cette résidence',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => context.pushNamed(
                ResidenceDetailsPageV2.name,
                pathParameters: {'id': residenceId},
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: coverImageId != null
                          ? CachedNetworkImage(
                              imageUrl: Utils.getImagePath(id: coverImageId),
                              fit: BoxFit.cover)
                          : Container(color: Colors.grey.shade200),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      residence.nom,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pushNamed(
                      ResidenceDetailsPageV2.name,
                      pathParameters: {'id': residenceId},
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                    ),
                    child: const Text('Voir la résidence',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.go(CalendarPageV2.routePath),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                    ),
                    child: const Text('Disponibilités',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VisiteContextCard extends StatelessWidget {
  const _VisiteContextCard({required this.visitData});
  final DemandeVisiteModel visitData;

  String get _statusLabel {
    switch (visitData.statusDemandeVisite) {
      case 'en_cours_validation_user':
      case 'en_cours_validation_admin':
        return 'En attente';
      case 'successful':
        return 'Confirmée';
      case 'failed':
        return 'Refusée';
      default:
        return visitData.statusDemandeVisite ?? '';
    }
  }

  String get _dateLabel {
    if (visitData.datesDemandeVisite.isEmpty) return 'Aucune date programmée';
    final date = visitData.datesDemandeVisite.last.date;
    if (date == null) return 'Aucune date programmée';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bien = visitData.bienImmobilier!;
    final photoUrl =
        bien.images.isNotEmpty ? Utils.getImagePath(id: bien.images.first) : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 36,
              height: 36,
              child: photoUrl != null
                  ? CachedNetworkImage(imageUrl: photoUrl, fit: BoxFit.cover)
                  : Container(color: Colors.grey.shade200),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bien.nom.isNotEmpty ? bien.nom : 'Bien immobilier',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$_dateLabel · $_statusLabel',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.pushNamed(
              EstateDetailsPageV2.name,
              pathParameters: {'id': bien.id},
            ),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Voir le bien',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _SupportContextBanner extends StatelessWidget {
  const _SupportContextBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          Icon(Icons.support_agent_outlined, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Assistance ImmoPlus',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.scrollController,
    required this.state,
    required this.peerName,
    required this.isSupport,
    this.topCard,
  });

  final ScrollController scrollController;
  final ConversationThreadLoaded state;
  final String peerName;
  final bool isSupport;

  /// Carte de contexte résidence — s'affiche juste sous le tout premier
  /// message du fil (comme la card côté client), pas avant.
  final Widget? topCard;

  @override
  Widget build(BuildContext context) {
    final messages = state.messages;
    final cubit = context.read<ConversationThreadCubit>();

    final lastSelfIndex = messages.lastIndexWhere((m) => m.isFromPro);
    final typingLabel =
        isSupport ? 'Un conseiller écrit…' : '$peerName est en train d\'écrire…';
    final topCardCount = topCard != null ? 1 : 0;
    // Sous le premier message s'il y en a un, sinon en tout premier (fil vide).
    final cardPosition = messages.isNotEmpty ? 1 : 0;

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: topCardCount + messages.length + (state.peerTyping ? 1 : 0),
      itemBuilder: (context, rawIndex) {
        if (topCard != null && rawIndex == cardPosition) return topCard!;
        final index = (topCard != null && rawIndex > cardPosition)
            ? rawIndex - topCardCount
            : rawIndex;

        if (index >= messages.length) {
          return ThreadTypingIndicator(label: typingLabel);
        }

        final message = messages[index];
        final previous = index > 0 ? messages[index - 1] : null;

        final showDaySeparator = previous == null ||
            (message.createdAt != null &&
                previous.createdAt != null &&
                formatDaySeparator(message.createdAt!) !=
                    formatDaySeparator(previous.createdAt!));

        final showAvatar = !message.isFromPro &&
            (previous == null || previous.isFromPro != message.isFromPro);

        final showReadMarker =
            index == lastSelfIndex && state.peerLastReadAt != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDaySeparator && message.createdAt != null)
              DaySeparator(label: formatDaySeparator(message.createdAt!)),
            MessageBubble(
              message: message,
              showAvatar: showAvatar,
              showReadMarker: showReadMarker,
              onRetry: message.deliveryState == MessageDeliveryState.failed
                  ? () => cubit.retryMessage(message.clientTempId!)
                  : null,
              onDelete: message.deliveryState == MessageDeliveryState.failed
                  ? () => cubit.deleteFailedMessage(message.clientTempId!)
                  : null,
            ),
          ],
        );
      },
    );
  }
}

class _ModerationBanner extends StatelessWidget {
  const _ModerationBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.redFF0000.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.redFF0000.withValues(alpha: 0.3)),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 13, color: AppColors.redFF0000),
      ),
    );
  }
}
