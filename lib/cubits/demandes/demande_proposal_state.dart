import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';

sealed class DemandeProposalState {
  const DemandeProposalState();
}

class DemandeProposalInitial extends DemandeProposalState {
  const DemandeProposalInitial();
}

class DemandeProposalLoadingMatches extends DemandeProposalState {
  const DemandeProposalLoadingMatches();
}

class DemandeProposalMatchesLoaded extends DemandeProposalState {
  final List<AlertProMatchItem> matches;
  final AlertProMatchItem? selectedMatch;

  const DemandeProposalMatchesLoaded({
    required this.matches,
    this.selectedMatch,
  });

  DemandeProposalMatchesLoaded copyWith({
    List<AlertProMatchItem>? matches,
    AlertProMatchItem? selectedMatch,
  }) {
    return DemandeProposalMatchesLoaded(
      matches: matches ?? this.matches,
      selectedMatch: selectedMatch ?? this.selectedMatch,
    );
  }
}

class DemandeProposalSubmitting extends DemandeProposalState {
  final AlertProMatchItem selectedMatch;
  const DemandeProposalSubmitting(this.selectedMatch);
}

class DemandeProposalSuccess extends DemandeProposalState {
  final AlertProMatchItem proposedProperty;
  final AlertProposalResponse? response;

  const DemandeProposalSuccess({
    required this.proposedProperty,
    this.response,
  });
}

class DemandeProposalError extends DemandeProposalState {
  final String error;
  const DemandeProposalError(this.error);
}
