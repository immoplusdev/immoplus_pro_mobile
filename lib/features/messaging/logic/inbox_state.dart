import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/remote/messaging/conversation_model.dart';
import 'package:immoplus_pro/data/models/remote/messaging/conversation_type_count.dart';

part 'inbox_state.freezed.dart';

@freezed
class InboxState with _$InboxState {
  const factory InboxState.loading() = InboxLoading;

  const factory InboxState.loaded({
    required List<ConversationModel> conversations,

    /// `null` = onglet "Toutes".
    ConversationType? activeType,
    @Default([]) List<ConversationTypeCount> counts,
    @Default(false) bool isRefreshing,

    /// Distinct de [isRefreshing] : bascule d'onglet en cours — seule la
    /// liste se recharge en skeleton, pas les onglets déjà affichés, qui
    /// restent visibles avec leurs compteurs.
    @Default(false) bool isSwitchingTab,
  }) = InboxLoaded;

  const factory InboxState.error(String message) = InboxError;
}
