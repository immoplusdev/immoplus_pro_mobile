import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/data/repositories/messaging_repository.dart';
import 'package:immoplus_pro/features/calendar/calendar_page_v2.dart';
import 'package:immoplus_pro/features/estate_detail/estate_details_page_v2.dart';
import 'package:immoplus_pro/features/residence_detail/residence_details_page_v2.dart';
import 'package:immoplus_pro/features/visits/visit_detail_page.dart';
import 'package:immoplus_pro/utils/utils.dart';

import '../../../data/models/remote/messaging/conversation_model.dart';
import '../../../data/models/remote/messaging/message_model.dart';
import '../logic/conversation_thread_cubit.dart';
import '../logic/conversation_thread_state.dart';
import '../logic/pro_guidance_rule.dart';
import '../utils/messaging_time_format.dart';
import '../widgets/actions/arrival_info_sheet.dart';
import '../widgets/actions/availability_answer_sheet.dart';
import '../widgets/actions/composer_actions_sheet.dart';
import '../widgets/actions/qr_checkin_scanner_sheet.dart';
import '../widgets/actions/pro_guidance_sheet.dart';
import '../widgets/actions/rate_guest_sheet.dart';
import '../widgets/actions/reject_reservation_sheet.dart';
import '../widgets/actions/stay_proposal_sheet.dart';
import '../widgets/actions/withdrawal_request_sheet.dart';
import '../widgets/block_conversation_dialog.dart';
import '../widgets/cards/availability_request_card.dart';
import '../widgets/cards/choice_prompt_widget.dart';
import '../widgets/cards/reservation_card_widget.dart';
import '../widgets/cards/residence_card_widget.dart';
import '../widgets/cards/stay_proposal_card.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer_bar.dart';
import '../widgets/report_conversation_sheet.dart';
import '../widgets/thread_typing_indicator.dart';
import '../../../services/messaging_socket_service.dart';

class MessageThreadPage extends StatelessWidget {
  const MessageThreadPage({
    super.key,
    required this.conversationId,
    this.focusComposer = false,
  });

  final String conversationId;
  final bool focusComposer;

  static const String routePath = '/messages/:conversationId';
  static const String name = 'message_thread';

  static String route({required String id}) => '/messages/$id';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConversationThreadCubit>()..load(conversationId),
      child: _ThreadView(focusComposer: focusComposer),
    );
  }
}

class _ThreadView extends StatefulWidget {
  const _ThreadView({this.focusComposer = false});

  final bool focusComposer;

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
  List<ProGuidanceRule> _proGuidanceRules = [];
  StreamSubscription<void>? _proGuidanceUpdatedSub;
  String? _activeGuidanceKey;
  final Map<String, int> _guidanceShows = {};

  @override
  void initState() {
    super.initState();
    _proGuidanceUpdatedSub = getIt<MessagingSocketService>()
        .onProGuidanceUpdated
        .listen((_) => unawaited(_reloadProGuidance()));
  }

  @override
  void dispose() {
    _proGuidanceUpdatedSub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _reloadProGuidance() async {
    final jsonRules = await MessagingRepository.getProGuidance();
    if (!mounted) return;
    setState(() {
      _proGuidanceRules = jsonRules
          .map(ProGuidanceRule.fromJson)
          .where((rule) => rule.id.isNotEmpty)
          .toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));
      _activeGuidanceKey = null;
    });
  }

  void _onComposerChanged(
    String draft,
    ConversationThreadLoaded loaded,
    BuildContext context,
  ) {
    context.read<ConversationThreadCubit>().onComposerTextChanged();
    final conversation = loaded.conversation;
    if (draft.trim().isEmpty || conversation.isReadOnly) {
      _activeGuidanceKey = null;
      return;
    }

    final List<Map<String, dynamic>> serverActions = [
      ...?conversation.actions,
      ...loaded.messages.expand((message) => message.actions ?? const []),
    ];
    ProGuidanceRule? suggestion;
    for (final rule in _proGuidanceRules) {
      if (rule.matches(
        draft: draft,
        type: conversation.typeEnum,
        serverActions: serverActions,
      )) {
        suggestion = rule;
        break;
      }
    }

    if (suggestion == null) {
      _activeGuidanceKey = null;
      return;
    }
    final rule = suggestion;
    final key = '${conversation.id}:${rule.id}';
    if (_activeGuidanceKey == key) return;
    _activeGuidanceKey = key;
    final shownCount = _guidanceShows[key] ?? 0;
    if (shownCount >= rule.maxShowsPerConversation) return;
    _guidanceShows[key] = shownCount + 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ProGuidanceSheet.show(
        context,
        rule: rule,
        onAction: () => unawaited(_executeGuidanceAction(rule, conversation)),
      );
    });
  }

  Future<void> _executeGuidanceAction(
    ProGuidanceRule rule,
    ConversationModel conversation,
  ) async {
    final actionId = rule.actionId;
    if (actionId == null || !mounted) return;
    try {
      final refreshed =
          await MessagingRepository.getConversation(conversation.id);
      if (!mounted || refreshed.isReadOnly) return;
      final freshMessages = await MessagingRepository.getMessages(
        conversation.id,
        limit: 30,
      );
      if (!mounted) return;
      final freshActions = [
        ...?refreshed.actions,
        ...freshMessages.expand((message) => message.actions ?? const []),
      ];
      final action = freshActions.where(
        (item) => item['id']?.toString() == actionId,
      );
      if (action.isEmpty) return;
      _handleAction(
        actionId,
        Map<String, dynamic>.from(action.first['target'] as Map? ?? {}),
        context,
        context.read<ConversationThreadCubit>(),
        refreshed,
      );
    } catch (_) {
      EasyLoading.showError('Cette action n’est plus disponible.');
      context.read<ConversationThreadCubit>().load(conversation.id);
    }
  }

  /// Libellé par défaut de l'interlocuteur (le client) selon le type, tant
  /// que le vrai nom n'est pas résolu (ou pour `support`, qui n'en a pas).
  String _defaultPeerLabel(ConversationType type) {
    switch (type) {
      case ConversationType.support:
        return 'Support ImmoPlus';
      case ConversationType.relais:
        return 'Client Relais';
      case ConversationType.visite:
      case ConversationType.reservation:
        return 'Client';
    }
  }

  Future<void> _loadSideEffects(ConversationModel conversation) async {
    if (_sideEffectsLoaded) return;
    _sideEffectsLoaded = true;
    unawaited(_reloadProGuidance());

    switch (conversation.typeEnum) {
      case ConversationType.reservation:
        final residenceId = conversation.residenceId;
        if (residenceId != null) {
          try {
            final residence = await LogmentRepository.getResidence(residenceId);
            if (mounted) setState(() => _residence = residence.data);
          } catch (_) {}
        }
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

      case ConversationType.relais:
      case ConversationType.support:
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
                leading: const Icon(Iconsax.building),
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
                leading: const Icon(Iconsax.calendar),
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
                leading: const Icon(Iconsax.house),
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
                leading: const Icon(Iconsax.document_text),
                title: const Text('Voir la demande de visite'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _showVisitDetailSheet(context, _visitData!.id);
                },
              ),
            ],
            ListTile(
              leading: const Icon(Iconsax.flag),
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
                leading: Icon(Iconsax.forbidden, color: AppColors.redFF0000),
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
                        EasyLoading.showError(
                            'Le blocage a échoué. Réessayer.');
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

  void _handleAction(
    String actionId,
    Map<String, dynamic> target,
    BuildContext context,
    ConversationThreadCubit cubit,
    ConversationModel conversation,
  ) {
    if (conversation.isReadOnly) return;
    final targetId = target['id']?.toString() ?? conversation.id;
    final residenceId = conversation.residenceId ??
        target['residenceId']?.toString() ??
        targetId;

    switch (actionId) {
      case 'view_residence':
        context.pushNamed(
          ResidenceDetailsPageV2.name,
          pathParameters: {'id': residenceId},
        );
        break;
      case 'view_reservation':
        if (targetId.isNotEmpty) {
          context.pushNamed(
            ResidenceDetailsPageV2.name,
            pathParameters: {'id': residenceId},
          );
        }
        break;
      case 'open_calendar':
        context.go(CalendarPageV2.routePath);
        break;
      case 'schedule_visit':
        final visitId = target['id']?.toString() ?? conversation.visiteId;
        if (visitId != null && visitId.isNotEmpty) {
          _showVisitDetailSheet(context, visitId);
        }
        break;
      case 'answer_availability':
        AvailabilityAnswerSheet.show(
          context,
          onAnswer: (available) async {
            final sent = await cubit.sendStructuredMessage(
              type: 'availability_answer',
              content: available ? 'Disponible' : 'Indisponible',
              payload: {
                'requestMessageId': targetId,
                'available': available,
                'origin': 'pro',
              },
            );
            if (sent) cubit.load(conversation.id);
          },
        );
        break;
      case 'propose_stay':
        final proposalResidenceId =
            target['residenceId']?.toString() ?? conversation.residenceId;
        if (proposalResidenceId == null) return;
        StayProposalSheet.show(
          context,
          residenceId: proposalResidenceId,
          onSendProposal: (
                  {required checkIn, required checkOut, required guests}) =>
              cubit.sendStayProposal(
            residenceId: proposalResidenceId,
            checkIn: checkIn,
            checkOut: checkOut,
            guests: guests,
          ),
        );
        break;
      case 'accept_reservation':
        MessagingRepository.acceptReservation(targetId).then((_) {
          EasyLoading.showSuccess('Réservation acceptée !');
          cubit.load(conversation.id);
        }).catchError((e) {
          EasyLoading.showError('Impossible d\'accepter la réservation.');
        });
        break;
      case 'message_client':
        final conversationId = target['id']?.toString() ?? '';
        final collection = target['collection']?.toString();
        if (collection == 'conversations' && conversationId.isNotEmpty) {
          context.pushNamed(
            MessageThreadPage.name,
            pathParameters: {'conversationId': conversationId},
            queryParameters: const {'focusComposer': 'true'},
          );
        }
        break;
      case 'reject_reservation':
        RejectReservationSheet.show(
          context,
          reservationId: targetId,
          onRejected: () => cubit.load(conversation.id),
        );
        break;
      case 'scan_checkin_qr':
        QrCheckinScannerSheet.show(
          context,
          onScanned: () => cubit.load(conversation.id),
        );
        break;
      case 'complete_arrival_info':
        ArrivalInfoSheet.show(
          context,
          residenceId: residenceId,
          onUpdated: () => cubit.load(conversation.id),
        );
        break;
      case 'rate_guest':
        RateGuestSheet.show(
          context,
          reservationId: targetId,
          onRated: () => cubit.load(conversation.id),
        );
        break;
      case 'open_withdrawal':
        WithdrawalRequestSheet.show(
          context,
          reservationId: targetId,
          onRequested: () => cubit.load(conversation.id),
        );
        break;
      case 'open_support':
        MessagingRepository.openSupportGuided().then((res) {
          if (!context.mounted) return;
          context.pushNamed(
            MessageThreadPage.name,
            pathParameters: {'conversationId': res.conversation.id},
          );
        }).catchError((_) {
          EasyLoading.showError('Impossible d\'ouvrir le support.');
        });
        break;
    }
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
              return Column(
                children: [
                  _MinimalHeader(
                      onBack: () => Navigator.of(context).maybePop()),
                  const Expanded(
                      child: Center(child: CircularProgressIndicator())),
                ],
              );
            }
            if (state is ConversationThreadError) {
              return Column(
                children: [
                  _MinimalHeader(
                      onBack: () => Navigator.of(context).maybePop()),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Iconsax.wifi_square,
                                size: 40, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(state.message, textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () => context
                                  .read<ConversationThreadCubit>()
                                  .retry(),
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
            final isBlocked = loaded.conversation.isReadOnly;
            final type = loaded.conversation.typeEnum;
            final peerLabel = _peerName ?? _defaultPeerLabel(type);

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
                  const _SupportContextBanner()
                else if (type == ConversationType.relais)
                  const _RelaisContextBanner(),
                Expanded(
                  child: _MessageList(
                    scrollController: _scrollController,
                    state: loaded,
                    peerName: peerLabel,
                    isSupport: type == ConversationType.support,
                    topCard: topCard,
                    onActionTap: (actionId, target) => _handleAction(
                      actionId,
                      target,
                      context,
                      context.read<ConversationThreadCubit>(),
                      loaded.conversation,
                    ),
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
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  )
                else
                  MessageComposerBar(
                    autofocus: widget.focusComposer,
                    onChanged: (draft) =>
                        _onComposerChanged(draft, loaded, context),
                    onSend: (text) =>
                        context.read<ConversationThreadCubit>().sendText(text),
                    onOpenActions: () {
                      final serverActions = <Map<String, dynamic>>[
                        ...?loaded.conversation.actions,
                        ...loaded.messages.expand(
                          (message) => message.actions ?? const [],
                        ),
                      ];
                      final actionTypes = <ComposerActionType>[];
                      if (loaded.conversation.residenceId != null &&
                          serverActions.any((action) =>
                              action['id']?.toString() == 'propose_stay')) {
                        actionTypes.add(ComposerActionType.proposeStay);
                      }
                      if (serverActions.any((action) =>
                          action['id']?.toString() == 'open_withdrawal')) {
                        actionTypes.add(ComposerActionType.requestWithdrawal);
                      }
                      if (loaded.conversation.typeEnum !=
                          ConversationType.support) {
                        actionTypes.add(ComposerActionType.openSupport);
                      }
                      if (actionTypes.isEmpty) return;

                      ComposerActionsSheet.show(
                        context,
                        actions: actionTypes,
                        onActionSelected: (actionType) {
                          switch (actionType) {
                            case ComposerActionType.proposeStay:
                              if (loaded.conversation.residenceId != null) {
                                final action = serverActions.firstWhere(
                                  (item) =>
                                      item['id']?.toString() == 'propose_stay',
                                  orElse: () => <String, dynamic>{},
                                );
                                final residenceId = action['target'] is Map &&
                                        action['target']['residenceId'] != null
                                    ? action['target']['residenceId'].toString()
                                    : loaded.conversation.residenceId!;
                                StayProposalSheet.show(
                                  context,
                                  residenceId: residenceId,
                                  onSendProposal: ({
                                    required checkIn,
                                    required checkOut,
                                    required guests,
                                  }) =>
                                      context
                                          .read<ConversationThreadCubit>()
                                          .sendStayProposal(
                                            residenceId: residenceId,
                                            checkIn: checkIn,
                                            checkOut: checkOut,
                                            guests: guests,
                                          ),
                                );
                              }
                              break;
                            case ComposerActionType.requestWithdrawal:
                              final action = serverActions.firstWhere(
                                (item) =>
                                    item['id']?.toString() == 'open_withdrawal',
                                orElse: () => <String, dynamic>{},
                              );
                              _handleAction(
                                'open_withdrawal',
                                Map<String, dynamic>.from(
                                  action['target'] as Map? ?? const {},
                                ),
                                context,
                                context.read<ConversationThreadCubit>(),
                                loaded.conversation,
                              );
                              break;
                            case ComposerActionType.openSupport:
                              _handleAction(
                                'open_support',
                                {'id': loaded.conversation.id},
                                context,
                                context.read<ConversationThreadCubit>(),
                                loaded.conversation,
                              );
                              break;
                          }
                        },
                      );
                    },
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
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Iconsax.arrow_left_1), onPressed: onBack),
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
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Iconsax.arrow_left),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryLite,
            child: Icon(
              isSupport ? Iconsax.headphone : Iconsax.user,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(peerLabel,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
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
            icon: const Icon(Iconsax.more),
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
    final photoUrl = bien.images.isNotEmpty
        ? Utils.getImagePath(id: bien.images.first)
        : null;

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
          Icon(Iconsax.headphone, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Assistance ImmoPlus',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _RelaisContextBanner extends StatelessWidget {
  const _RelaisContextBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          Icon(Iconsax.repeat, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Relais Client Concerné',
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
    required this.onActionTap,
    this.topCard,
  });

  final ScrollController scrollController;
  final ConversationThreadLoaded state;
  final String peerName;
  final bool isSupport;
  final Function(String actionId, Map<String, dynamic> target) onActionTap;

  /// Carte de contexte résidence — s'affiche juste sous le tout premier
  /// message du fil (comme la card côté client), pas avant.
  final Widget? topCard;

  @override
  Widget build(BuildContext context) {
    final messages = state.messages;
    final cubit = context.read<ConversationThreadCubit>();

    final lastSelfIndex = messages.lastIndexWhere((m) => m.isFromPro);
    final typingLabel = isSupport
        ? 'Un conseiller écrit…'
        : '$peerName est en train d\'écrire…';
    final topCardCount = topCard != null ? 1 : 0;
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

        Widget cardWidget;
        switch (message.type) {
          case 'availability_request':
            cardWidget = AvailabilityRequestCard(
              message: message,
              canAnswer: !state.conversation.isReadOnly &&
                  (message.actions ?? []).any((action) =>
                      action['id']?.toString() == 'answer_availability'),
              onAnswerTap: () => onActionTap(
                'answer_availability',
                {'id': message.id, ...?message.payload},
              ),
            );
            break;
          case 'stay_proposal':
            cardWidget = StayProposalCard(message: message);
            break;
          case 'reservation_card':
            cardWidget = ReservationCardWidget(
              message: message,
              isReadOnly: state.conversation.isReadOnly,
              onActionTap: onActionTap,
            );
            break;
          case 'residence_card':
            cardWidget = ResidenceCardWidget(
              message: message,
              canViewResidence: !state.conversation.isReadOnly &&
                  (message.actions ?? []).any(
                      (action) => action['id']?.toString() == 'view_residence'),
              onViewResidence: (id) =>
                  onActionTap('view_residence', {'id': id}),
            );
            break;
          case 'choice_prompt':
            cardWidget = ChoicePromptWidget(
              message: message,
              isReadOnly: state.conversation.isReadOnly,
              onOptionSelected: (topic, optId, label) {
                cubit.sendStructuredMessage(
                  type: 'choice_answer',
                  content: label,
                  payload: {'topic': topic, 'optionId': optId},
                );
              },
            );
            break;
          default:
            cardWidget = MessageBubble(
              message: message,
              showAvatar: showAvatar,
              showReadMarker: showReadMarker,
              onRetry: message.deliveryState == MessageDeliveryState.failed
                  ? () => cubit.retryMessage(message.clientTempId!)
                  : null,
              onDelete: message.deliveryState == MessageDeliveryState.failed
                  ? () => cubit.deleteFailedMessage(message.clientTempId!)
                  : null,
            );
            break;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDaySeparator && message.createdAt != null)
              DaySeparator(label: formatDaySeparator(message.createdAt!)),
            cardWidget,
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
