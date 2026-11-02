import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/data/models/configs/address.dart';
import 'package:immoplus_pro/data/models/configs/commune_model.dart';
import 'package:immoplus_pro/data/models/configs/ville_model.dart';
import 'package:immoplus_pro/features/location_module/location_page.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';
import 'package:immoplus_pro/features/residence_creation/models/residence_field_keys.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/picker_field.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/field_shell.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/commune_selector_page.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/ville_selector_page.dart';

Future<T?> _showSelectorSheet<T>(
  BuildContext context, {
  required double heightFactor,
  required Widget child,
  bool dragEnabled = true,
}) =>
    showModalBottomSheet<T>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: dragEnabled,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) =>
          FractionallySizedBox(heightFactor: heightFactor, child: child),
    );

/// Champ `select` pour la ville et la commune, via les sélecteurs existants.
class ReferenceSelectField extends StatelessWidget {
  const ReferenceSelectField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
  });

  final CreationField field;
  final SelectedRef? value;
  final String? errorText;
  final ValueChanged<SelectedRef> onChanged;

  bool get _isCity => field.key == ResidenceFieldKeys.city;

  Future<void> _pick(BuildContext context) async {
    final picked = await _showSelectorSheet<Object>(
      context,
      heightFactor: _isCity ? 0.70 : 0.835,
      child: _isCity ? const VilleSelectorPage() : const CommuneSelectorPage(),
    );
    if (picked is VilleModel) {
      onChanged(SelectedRef(id: picked.id, label: picked.name));
    } else if (picked is CommuneModel) {
      onChanged(SelectedRef(id: picked.id, label: picked.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: field.label,
      helperText: field.helperText,
      errorText: errorText,
      labelStyle: FieldLabelStyle.plain,
      child: PickerField(
        icon: (_isCity ? FontAwesomeIcons.city : FontAwesomeIcons.mountainCity)
            .data,
        placeholder: field.placeholder ?? 'Sélectionner',
        value: value?.label,
        hasError: errorText != null,
        onTap: () => _pick(context),
      ),
    );
  }
}

/// Champ `map_point` : position du logement choisie sur la carte.
class MapPointField extends StatelessWidget {
  const MapPointField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.onPicked,
  });

  final CreationField field;
  final GeoPoint? value;
  final String? errorText;
  final ValueChanged<Address> onPicked;

  Future<void> _pick(BuildContext context) async {
    final picked = await _showSelectorSheet<Object>(
      context,
      heightFactor: 0.9,
      dragEnabled: false,
      child: const LocationPage(),
    );
    if (picked is Address &&
        picked.latitude != null &&
        picked.longitude != null) {
      onPicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: field.label,
      helperText: field.helperText,
      errorText: errorText,
      labelStyle: FieldLabelStyle.plain,
      child: PickerField(
        icon: FontAwesomeIcons.locationDot.data,
        placeholder: 'Choisir sur la carte',
        value: value == null ? null : 'Position définie',
        hasError: errorText != null,
        onTap: () => _pick(context),
      ),
    );
  }
}
