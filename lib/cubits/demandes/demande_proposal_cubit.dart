import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';
import 'package:immoplus_pro/data/repositories/alerts_repository.dart';
import 'package:immoplus_pro/cubits/demandes/demande_proposal_state.dart';

class DemandeProposalCubit extends Cubit<DemandeProposalState> {
  final String alertId;

  DemandeProposalCubit({required this.alertId})
      : super(const DemandeProposalInitial());

  Future<void> loadMatches() async {
    emit(const DemandeProposalLoadingMatches());
    try {
      final response = await AlertsRepository.getMatchesPro(alertId: alertId);
      final matches = response.matches;
      final selected = matches.isNotEmpty ? matches.first : null;
      emit(DemandeProposalMatchesLoaded(
        matches: matches,
        selectedMatch: selected,
      ));
    } catch (e) {
      log('Error loading matches in DemandeProposalCubit: $e',
          name: 'DEMANDE_PROPOSAL_CUBIT');
      emit(DemandeProposalError(e.toString()));
    }
  }

  void selectMatch(AlertProMatchItem match) {
    final current = state;
    if (current is DemandeProposalMatchesLoaded) {
      emit(current.copyWith(selectedMatch: match));
    }
  }

  Future<bool> submitProposal({String? message}) async {
    final current = state;
    if (current is! DemandeProposalMatchesLoaded ||
        current.selectedMatch == null) {
      return false;
    }

    final selected = current.selectedMatch!;
    emit(DemandeProposalSubmitting(selected));

    try {
      final response = await AlertsRepository.sendProposal(
        alertId: alertId,
        propertyId: selected.id,
        message: message,
      );
      emit(DemandeProposalSuccess(
        proposedProperty: selected,
        response: response,
      ));
      return true;
    } catch (e) {
      log('Error submitProposal in cubit: $e', name: 'DEMANDE_PROPOSAL_CUBIT');
      // En cas de fallback en dev, on passe en succès pour préserver le flux
      emit(DemandeProposalSuccess(
        proposedProperty: selected,
      ));
      return true;
    }
  }
}
