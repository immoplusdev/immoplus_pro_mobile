import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/data/models/reservations/owner_invitation_model.dart';
import 'package:immoplus_pro/data/repositories/owner_invitations_repository.dart';
import 'package:immoplus_pro/features/reservations/invitations/owner_invitations_state.dart';

class OwnerInvitationsCubit extends Cubit<OwnerInvitationsState> {
  OwnerInvitationsCubit() : super(const OwnerInvitationsInitial());

  Future<void> load() async {
    emit(const OwnerInvitationsLoading());
    try {
      final items = await OwnerInvitationsRepository.getOwnerInvitations();
      log('load() success: ${items.length} item(s)', name: 'OWNER_INVITATIONS_CUBIT');
      emit(OwnerInvitationsLoaded(items));
    } catch (e) {
      log('load() failed: $e', name: 'OWNER_INVITATIONS_CUBIT');
      emit(OwnerInvitationsError(e.toString()));
    }
  }

  /// Confirme une résidence précise. Retire la card localement au succès
  /// (pas de refetch nécessaire : le back a déjà tranché côté cette entrée).
  Future<bool> confirm(OwnerInvitationItem item) async {
    final current = state;
    if (current is! OwnerInvitationsLoaded) return false;
    emit(current.copyWith(actingItemId: item.id));
    try {
      await OwnerInvitationsRepository.confirmProposal(
        reverseSearchId: item.reverseSearchId,
        residenceId: item.residenceId,
      );
      final updated = current.items.where((i) => i.id != item.id).toList();
      emit(OwnerInvitationsLoaded(updated));
      return true;
    } catch (_) {
      emit(current.copyWith(clearActingItemId: true));
      return false;
    }
  }

  Future<bool> decline(OwnerInvitationItem item, {String? motif}) async {
    final current = state;
    if (current is! OwnerInvitationsLoaded) return false;
    emit(current.copyWith(actingItemId: item.id));
    try {
      await OwnerInvitationsRepository.declineProposal(
        reverseSearchId: item.reverseSearchId,
        residenceId: item.residenceId,
        motif: motif,
      );
      final updated = current.items.where((i) => i.id != item.id).toList();
      emit(OwnerInvitationsLoaded(updated));
      return true;
    } catch (_) {
      emit(current.copyWith(clearActingItemId: true));
      return false;
    }
  }
}
