import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/residence_creation/logic/field_validator.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_state.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_form_values.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_payload_builder.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';
import 'package:immoplus_pro/features/residence_creation/models/place_suggestion.dart';
import 'package:immoplus_pro/features/residence_creation/models/residence_field_keys.dart';
import 'package:immoplus_pro/features/residence_creation/models/server_validation_errors.dart';
import 'package:immoplus_pro/features/residence_creation/repositories/residence_creation_repository.dart';
import 'package:immoplus_pro/services/analytics_service.dart';

class ResidenceCreationCubit extends Cubit<ResidenceCreationState> {
  /// [residenceId] : modifie cette résidence au lieu d'en créer une.
  ResidenceCreationCubit({
    ResidenceCreationRepository? repository,
    this.residenceId,
  })  : _repository = repository ?? ResidenceCreationRepository(),
        super(const ResidenceCreationState());

  final ResidenceCreationRepository _repository;
  final String? residenceId;

  bool get isEditing => residenceId != null;

  Future<void> load() async {
    emit(const ResidenceCreationState());
    try {
      final flow = await _repository.getCreationFlow();
      final residence =
          isEditing ? await _repository.getResidence(residenceId!) : null;
      emit(ResidenceCreationState(
        loadStatus: FlowLoadStatus.ready,
        flow: flow,
        values: residence == null
            ? ResidenceFormValues.initial(flow)
            : ResidenceFormValues.fromResidence(flow, residence),
      ));
      if (!isEditing) getIt<AnalyticsService>().logPropertyCreationStarted();
    } catch (_) {
      emit(const ResidenceCreationState(loadStatus: FlowLoadStatus.failed));
    }
  }

  void setValue(String key, Object? value) {
    emit(state.copyWith(
      values: {...state.values, key: value},
      fieldErrors: _withoutErrors({key}),
    ));
  }

  Map<String, String> _withoutErrors(Set<String> keys) =>
      {...state.fieldErrors}..removeWhere((k, _) => keys.contains(k));

  /// Charge un catalogue à partir du `catalogEndpoint` d'un champ.
  Future<List<CatalogGroup>> loadCatalog(String endpoint, {String? search}) =>
      _repository.getCatalog(endpoint, search: search);

  // ── Adresse ───────────────────────────────────────────────────────────

  Future<List<PlaceSuggestion>> searchPlaces(String input,
          {String? sessionToken}) =>
      _repository.searchPlaces(input, sessionToken: sessionToken);

  /// Transforme une suggestion en adresse + position GPS.
  Future<PlaceSelection> resolvePlace(PlaceSuggestion suggestion,
      {String? sessionToken}) async {
    final position = await _repository.getPlacePosition(suggestion.placeId,
        sessionToken: sessionToken);
    return PlaceSelection(address: suggestion.description, position: position);
  }

  // ── Photos ────────────────────────────────────────────────────────────

  List<ImageUploadItem> get _photos =>
      List.of(state.values[ResidenceFieldKeys.photos] as List<ImageUploadItem>);

  void addPhotos(List<File> files, {int? maxFiles}) {
    final room = maxFiles == null ? files.length : maxFiles - _photos.length;
    for (final file in files.take(room.clamp(0, files.length))) {
      _uploadPhoto(file);
    }
  }

  /// Envoie un fichier vers `POST /files` (photos et vidéo du formulaire).
  Future<String> uploadFile(File file) => _repository.uploadFile(file);

  Future<void> _uploadPhoto(File file) async {
    final item = ImageUploadItem(file: file, status: UploadStatus.uploading);
    _setPhotos([..._photos, item]);

    try {
      final id = await uploadFile(file);
      updatePhoto(item.copyWith(status: UploadStatus.success, uploadedId: id));
    } catch (e) {
      updatePhoto(item.copyWith(
        status: UploadStatus.failed,
        errorMessage: e is DioException
            ? (e.message ?? 'Échec de l\'envoi')
            : 'Échec de l\'envoi',
      ));
    }
  }

  void updatePhoto(ImageUploadItem item) {
    final photos = _photos;
    final index = photos.indexWhere((p) => p.id == item.id);
    if (index < 0) return;
    photos[index] = item;
    _setPhotos(photos);
  }

  void removePhoto(String id) =>
      _setPhotos(_photos..removeWhere((p) => p.id == id));

  void _setPhotos(List<ImageUploadItem> photos) => emit(state.copyWith(
        values: {...state.values, ResidenceFieldKeys.photos: photos},
        fieldErrors: _withoutErrors({ResidenceFieldKeys.photos}),
      ));

  // ── Navigation ────────────────────────────────────────────────────────

  void previous() {
    if (state.stepIndex == 0) return;
    emit(state.copyWith(stepIndex: state.stepIndex - 1));
  }

  /// Valide l'étape courante puis passe à la suivante, ou soumet si c'est la
  /// dernière.
  Future<void> next() async {
    final errors = _validateStep(state.currentStep!);
    emit(state.copyWith(fieldErrors: errors, generalErrors: const []));
    if (errors.isNotEmpty) return;

    if (state.isLastStep) {
      await _submit();
    } else {
      emit(state.copyWith(stepIndex: state.stepIndex + 1));
    }
  }

  Map<String, String> _validateStep(CreationStep step) {
    final errors = <String, String>{};
    for (final field in step.fields) {
      if (!field.isVisible(state.values)) continue;
      final message = FieldValidator.validate(field, state.values[field.key]);
      if (message != null) errors[field.key] = message;
    }
    return errors;
  }

  // ── Soumission ────────────────────────────────────────────────────────

  Future<void> _submit() async {
    final flow = state.flow!;
    final payload = ResidencePayloadBuilder.build(flow, state.values);
    final propertyType = payload['propertyType'] as String? ?? '';
    final price = (payload['baseNightlyPrice'] as num?)?.toDouble() ?? 0;
    final analytics = getIt<AnalyticsService>();

    emit(state.copyWith(isSubmitting: true, generalErrors: const []));

    if (isEditing) {
      await _update(payload);
      return;
    }

    analytics.logPropertyCreationSubmitted(
      typeBien: propertyType,
      prix: price,
      commune: '',
    );

    try {
      final created = await _repository.createResidence(payload);
      analytics.logPropertyCreationSuccess(
          idBien: created.id, typeBien: propertyType, prix: price);
      emit(state.copyWith(isSubmitting: false, created: created));
    } on DioException catch (e) {
      analytics.logPropertyCreationFailed(
        typeBien: propertyType,
        errorCode: e.response?.statusCode?.toString(),
      );
      _showServerErrors(e);
    } catch (_) {
      analytics.logPropertyCreationFailed(typeBien: propertyType);
      emit(state.copyWith(
        isSubmitting: false,
        generalErrors: const ['Une erreur est survenue. Veuillez réessayer.'],
      ));
    }
  }

  Future<void> _update(Map<String, dynamic> payload) async {
    try {
      await _repository.updateResidence(residenceId!, payload);
      emit(state.copyWith(isSubmitting: false, updated: true));
    } on DioException catch (e) {
      _showServerErrors(e);
    } catch (_) {
      emit(state.copyWith(
        isSubmitting: false,
        generalErrors: const ['Une erreur est survenue. Veuillez réessayer.'],
      ));
    }
  }

  /// Affiche les erreurs du serveur sur les champs concernés et ramène
  /// l'utilisateur à la première étape à corriger.
  void _showServerErrors(DioException error) {
    final flow = state.flow!;
    final knownKeys = {
      for (final f in flow.allFields)
        ...(ResidenceFieldKeys.payloadKeys[f.key] ?? [f.key]),
    };
    final parsed = ServerValidationErrors.fromDioException(
      error,
      knownPayloadKey: knownKeys.contains,
    );

    final fieldErrors = {
      for (final e in parsed.byPayloadKey.entries)
        ResidenceFieldKeys.fieldKeyForPayloadKey(e.key): e.value,
    };
    final general = [
      ...parsed.general,
      if (parsed.isEmpty) 'Une erreur est survenue. Veuillez réessayer.',
    ];

    final firstStepWithError = flow.steps.indexWhere(
      (s) => s.fields.any((f) => fieldErrors.containsKey(f.key)),
    );

    emit(state.copyWith(
      isSubmitting: false,
      fieldErrors: fieldErrors,
      generalErrors: general,
      stepIndex: firstStepWithError >= 0 ? firstStepWithError : null,
    ));
  }
}
