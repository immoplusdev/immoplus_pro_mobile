import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/common/widgets/empty_state_v2.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/features/home_v2/home_page_v2.dart';

import '../../../data/models/remote/messaging/conversation_model.dart';
import '../logic/inbox_cubit.dart';
import '../logic/inbox_state.dart';
import '../widgets/conversation_tile.dart';
import '../widgets/inbox_tabs.dart';
import '../widgets/message_composer_sheet.dart';
import 'message_thread_page.dart';

class MessagesInboxPage extends StatelessWidget {
  const MessagesInboxPage({super.key});

  static const String routePath = '/messages';
  static const String name = 'messages';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InboxCubit>()..load(),
      child: const _MessagesInboxView(),
    );
  }
}

class _MessagesInboxView extends StatelessWidget {
  const _MessagesInboxView();

  String _emptyTitle(ConversationType? type) {
    switch (type) {
      case ConversationType.reservation:
        return 'Aucune conversation liée à une réservation.';
      case ConversationType.visite:
        return 'Aucune conversation liée à une visite.';
      case ConversationType.support:
        return "Vous n'avez pas encore contacté le support.";
      case null:
        return 'Pas encore de messages';
    }
  }

  String _emptyDescription(ConversationType? type) {
    if (type == null) {
      return 'Les échanges avec vos clients au sujet de vos résidences, '
          'visites et tickets support apparaîtront ici.';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messages',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: BlocBuilder<InboxCubit, InboxState>(
        builder: (context, state) {
          return state.when(
            loading: () => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 6,
              itemBuilder: (_, __) => const _ConversationSkeleton(),
            ),
            loaded:
                (conversations, activeType, counts, isRefreshing, isSwitchingTab) {
              final isSupportTab = activeType == ConversationType.support;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: InboxTabs(
                      activeType: activeType,
                      counts: counts,
                      onSelect: (type) =>
                          context.read<InboxCubit>().selectTab(type),
                    ),
                  ),
                  if (isSupportTab)
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            final hasActiveSupportTicket = conversations
                                .any((c) => c.typeEnum == ConversationType.support);
                            if (hasActiveSupportTicket) {
                              context.pushNamed(
                                MessageThreadPage.name,
                                pathParameters: {
                                  'conversationId': conversations
                                      .firstWhere((c) =>
                                          c.typeEnum == ConversationType.support)
                                      .id
                                },
                              );
                            } else {
                              MessageComposerSheet.showForSupport(context);
                            }
                          },
                          icon: const Icon(Iconsax.add_circle, size: 18),
                          label: const Text('Nouveau ticket support'),
                        ),
                      ),
                    ),
                  Expanded(
                    child: isSwitchingTab
                        ? ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: 4,
                            itemBuilder: (_, __) => const _ConversationSkeleton(),
                          )
                        : conversations.isEmpty
                            ? SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    EmptyStateV2(
                                      icon: Iconsax.message,
                                      iconColor: AppColors.primary,
                                      iconBackgroundColor:
                                          AppColors.primaryLite,
                                      title: _emptyTitle(activeType),
                                      description: _emptyDescription(activeType),
                                    ),
                                    if (activeType == null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              context.go(HomePageV2.routePath),
                                          child:
                                              const Text('Retour au tableau de bord'),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () =>
                                    context.read<InboxCubit>().refresh(),
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: conversations.length,
                                  itemBuilder: (context, index) {
                                    final conversation = conversations[index];
                                    return ConversationTile(
                                      conversation: conversation,
                                      onTap: () async {
                                        final inboxCubit =
                                            context.read<InboxCubit>();
                                        // Le fil peut avoir changé (lu,
                                        // bloqué...) pendant qu'il était
                                        // ouvert : pas d'event dédié pour ça,
                                        // un simple refresh au retour suffit.
                                        await context.pushNamed(
                                          MessageThreadPage.name,
                                          pathParameters: {
                                            'conversationId': conversation.id
                                          },
                                        );
                                        inboxCubit.refresh();
                                      },
                                    );
                                  },
                                ),
                              ),
                  ),
                ],
              );
            },
            error: (message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off, size: 40, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => context.read<InboxCubit>().load(),
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
          );
        },
      ),
    );
  }
}

class _ConversationSkeleton extends StatelessWidget {
  const _ConversationSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget bar(double width, double height) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bar(120, 14),
                const SizedBox(height: 8),
                bar(180, 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
