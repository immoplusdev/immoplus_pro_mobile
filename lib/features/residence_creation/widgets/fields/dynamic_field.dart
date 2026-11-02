import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_cubit.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_state.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';
import 'package:immoplus_pro/features/residence_creation/models/residence_field_keys.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/amenities_field.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/counters_field.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/location_fields.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/media_fields.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/option_fields.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/property_type_field.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/rooms_and_beds_field.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/text_input_field.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/time_field.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/toggle_field.dart';

/// Affiche le widget correspondant au type d'un champ de la configuration.
/// Un champ masqué par sa condition `visibleWhen` n'est pas affiché.
class DynamicField extends StatelessWidget {
  const DynamicField({super.key, required this.field, required this.state});

  final CreationField field;
  final ResidenceCreationState state;

  @override
  Widget build(BuildContext context) {
    if (!field.isVisible(state.values)) return const SizedBox.shrink();

    final cubit = context.read<ResidenceCreationCubit>();
    final value = state.values[field.key];
    final error = state.fieldErrors[field.key];
    void set(Object? v) => cubit.setValue(field.key, v);

    switch (field.type) {
      case CreationFieldType.text:
      case CreationFieldType.textarea:
      case CreationFieldType.money:
        return TextInputField(
          field: field,
          value: value,
          errorText: error,
          onChanged: set,
        );
      case CreationFieldType.singleSelectCards:
        return field.catalogEndpoint != null
            ? PropertyTypeField(
                field: field,
                value: value as String?,
                errorText: error,
                loadCatalog: cubit.loadCatalog,
                onChanged: set,
              )
            : OptionCardsField(
                field: field,
                value: value,
                errorText: error,
                onChanged: set,
              );
      case CreationFieldType.chips:
      case CreationFieldType.timeChips:
        return ChipsField(
          field: field,
          value: value,
          errorText: error,
          onChanged: set,
        );
      case CreationFieldType.counters:
        return CountersField(
          field: field,
          value: Map<String, int>.from(value as Map),
          errorText: error,
          onChanged: set,
        );
      case CreationFieldType.counter:
        return CounterFieldsGroup(
          fields: [field],
          values: state.values,
          errors: state.fieldErrors,
          onChanged: cubit.setValue,
        );
      case CreationFieldType.bottomSheetCatalog:
        return RoomsAndBedsField(
          field: field,
          value: Map<String, int>.from(value as Map),
          errorText: error,
          loadCatalog: cubit.loadCatalog,
          onChanged: set,
        );
      case CreationFieldType.multiSelectCatalog:
        return AmenitiesField(
          field: field,
          value: List<String>.from(value as List),
          errorText: error,
          loadCatalog: cubit.loadCatalog,
          onChanged: set,
        );
      case CreationFieldType.select:
        return ReferenceSelectField(
          field: field,
          value: value as SelectedRef?,
          errorText: error,
          onChanged: set,
        );
      case CreationFieldType.mapPoint:
        return MapPointField(
          field: field,
          value: value as GeoPoint?,
          errorText: error,
          onPicked: (address) {
            set(GeoPoint(
              latitude: address.latitude!,
              longitude: address.longitude!,
            ));
            final currentAddress =
                state.values[ResidenceFieldKeys.address] as String?;
            if ((currentAddress ?? '').trim().isEmpty &&
                address.description != null) {
              cubit.setValue(ResidenceFieldKeys.address, address.description);
            }
          },
        );
      case CreationFieldType.mediaUpload:
        return field.key == ResidenceFieldKeys.video
            ? VideoField(
                field: field,
                videoId: value as String?,
                errorText: error,
                uploadFile: cubit.uploadFile,
                onChanged: set,
              )
            : PhotosField(
                field: field,
                photos: List<ImageUploadItem>.from(value as List),
                errorText: error,
                onPicked: (files) =>
                    cubit.addPhotos(files, maxFiles: field.maxFiles),
                onUpdated: cubit.updatePhoto,
                onRemoved: cubit.removePhoto,
              );
      case CreationFieldType.time:
        return TimeField(
          field: field,
          value: value as String?,
          errorText: error,
          onChanged: set,
        );
      case CreationFieldType.toggle:
        return ToggleField(
          field: field,
          value: value as bool? ?? false,
          onChanged: set,
        );
      case CreationFieldType.unknown:
        return const SizedBox.shrink();
    }
  }
}
