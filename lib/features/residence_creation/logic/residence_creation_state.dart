import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';

enum FlowLoadStatus { loading, ready, failed }

class ResidenceCreationState {
  const ResidenceCreationState({
    this.loadStatus = FlowLoadStatus.loading,
    this.flow,
    this.stepIndex = 0,
    this.values = const {},
    this.fieldErrors = const {},
    this.generalErrors = const [],
    this.isSubmitting = false,
    this.created,
    this.updated = false,
  });

  final FlowLoadStatus loadStatus;
  final CreationFlow? flow;
  final int stepIndex;

  /// Valeurs saisies, indexées par clé de champ de la configuration.
  final Map<String, dynamic> values;

  /// Message d'erreur par clé de champ (validation locale ou serveur).
  final Map<String, String> fieldErrors;

  /// Erreurs du serveur qu'on n'a pas pu rattacher à un champ.
  final List<String> generalErrors;
  final bool isSubmitting;
  final CreatedResidence? created;

  /// Vrai quand une résidence existante vient d'être modifiée.
  final bool updated;

  CreationStep? get currentStep => flow?.steps[stepIndex];
  bool get isLastStep => flow != null && stepIndex == flow!.steps.length - 1;

  ResidenceCreationState copyWith({
    FlowLoadStatus? loadStatus,
    CreationFlow? flow,
    int? stepIndex,
    Map<String, dynamic>? values,
    Map<String, String>? fieldErrors,
    List<String>? generalErrors,
    bool? isSubmitting,
    CreatedResidence? created,
    bool? updated,
  }) =>
      ResidenceCreationState(
        loadStatus: loadStatus ?? this.loadStatus,
        flow: flow ?? this.flow,
        stepIndex: stepIndex ?? this.stepIndex,
        values: values ?? this.values,
        fieldErrors: fieldErrors ?? this.fieldErrors,
        generalErrors: generalErrors ?? this.generalErrors,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        created: created ?? this.created,
        updated: updated ?? this.updated,
      );
}
