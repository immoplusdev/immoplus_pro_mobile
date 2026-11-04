import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';

/// Valide la valeur d'un champ selon les règles de la configuration.
/// Retourne le message d'erreur, ou `null` si la valeur est valide.
abstract class FieldValidator {
  static const String requiredMessage = 'Ce champ est requis';

  static String? validate(CreationField field, Object? value) {
    switch (field.type) {
      case CreationFieldType.text:
      case CreationFieldType.textarea:
        return _validateText(field, value as String? ?? '');
      case CreationFieldType.money:
      case CreationFieldType.counter:
        return _validateNumber(field, value as num?);
      case CreationFieldType.mediaUpload:
        return _validateMedia(field, value);
      case CreationFieldType.multiSelectCatalog:
        return field.required && (value as Iterable?)?.isNotEmpty != true
            ? requiredMessage
            : null;
      case CreationFieldType.singleSelectCards:
      case CreationFieldType.chips:
      case CreationFieldType.timeChips:
      case CreationFieldType.time:
        return field.required && value == null ? requiredMessage : null;
      case CreationFieldType.googlePlacesAutocomplete:
        return field.required && value == null
            ? 'Choisissez une adresse dans les suggestions'
            : null;
      case CreationFieldType.counters:
      case CreationFieldType.bottomSheetCatalog:
      case CreationFieldType.toggle:
      case CreationFieldType.unknown:
        return null;
    }
  }

  static String? _validateText(CreationField field, String value) {
    final text = value.trim();
    if (text.isEmpty) return field.required ? requiredMessage : null;
    if (field.minLength != null && text.length < field.minLength!) {
      return 'Minimum ${field.minLength} caractères';
    }
    if (field.maxLength != null && text.length > field.maxLength!) {
      return 'Maximum ${field.maxLength} caractères';
    }
    return null;
  }

  static String? _validateNumber(CreationField field, num? value) {
    if (value == null) return field.required ? requiredMessage : null;
    if (field.min != null && value < field.min!) {
      return 'Minimum ${field.min}';
    }
    if (field.max != null && value > field.max!) {
      return 'Maximum ${field.max}';
    }
    return null;
  }

  static String? _validateMedia(CreationField field, Object? value) {
    if (value is! List<ImageUploadItem>) return null;
    if (value.any((i) => i.status == UploadStatus.uploading)) {
      return 'Téléchargement en cours, patientez un instant';
    }
    final uploaded = value.where((i) => i.isUploaded).length;
    if (field.minFiles != null && uploaded < field.minFiles!) {
      return 'Ajoutez au moins ${field.minFiles} photos';
    }
    if (field.maxFiles != null && uploaded > field.maxFiles!) {
      return 'Maximum ${field.maxFiles} photos';
    }
    return null;
  }
}
