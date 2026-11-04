import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/outlined_action_button.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/pill_button.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/catalog_loader.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/counter_stepper.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/field_shell.dart';

/// Champ `bottom_sheet_catalog` (pièces et couchages). La valeur est une
/// `Map<String, int>` : `countKey` du catalogue -> quantité.
class RoomsAndBedsField extends StatefulWidget {
  const RoomsAndBedsField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.loadCatalog,
    required this.onChanged,
  });

  final CreationField field;
  final Map<String, int> value;
  final String? errorText;
  final CatalogLoader loadCatalog;
  final ValueChanged<Map<String, int>> onChanged;

  @override
  State<RoomsAndBedsField> createState() => _RoomsAndBedsFieldState();
}

class _RoomsAndBedsFieldState extends State<RoomsAndBedsField> {
  /// Libellés des éléments déjà choisis, pour résumer la sélection sans
  /// recharger le catalogue.
  final Map<String, String> _labels = {};

  Future<void> _openSheet() async {
    final result = await showModalBottomSheet<Map<String, int>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: _RoomsAndBedsSheet(
          field: widget.field,
          initial: widget.value,
          loadCatalog: widget.loadCatalog,
          onLabels: _labels.addAll,
        ),
      ),
    );
    if (result != null) widget.onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.value.entries.where((e) => e.value > 0).toList();
    return FieldShell(
      errorText: widget.errorText,
      helperText: widget.field.helperText,
      labelStyle: FieldLabelStyle.plain,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedActionButton(
            label: widget.field.label ?? 'Ajouter',
            trailingIcon: Icons.add,
            onPressed: _openSheet,
          ),
          if (selected.isNotEmpty) ...[
            AppSpacing.gap12,
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final entry in selected)
                  Chip(
                    label: Text(
                        '${entry.value} × ${_labels[entry.key] ?? entry.key}'),
                    labelStyle: AppTypography.captionSemiBold
                        .copyWith(color: AppColors.primary),
                    backgroundColor: AppColors.blue40,
                    side: BorderSide.none,
                    onDeleted: () =>
                        widget.onChanged({...widget.value}..remove(entry.key)),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RoomsAndBedsSheet extends StatefulWidget {
  const _RoomsAndBedsSheet({
    required this.field,
    required this.initial,
    required this.loadCatalog,
    required this.onLabels,
  });

  final CreationField field;
  final Map<String, int> initial;
  final CatalogLoader loadCatalog;
  final ValueChanged<Map<String, String>> onLabels;

  @override
  State<_RoomsAndBedsSheet> createState() => _RoomsAndBedsSheetState();
}

class _RoomsAndBedsSheetState extends State<_RoomsAndBedsSheet> {
  late final Map<String, int> _counts = {...widget.initial};
  String _search = '';
  late Future<List<CatalogGroup>> _future = _load();

  Future<List<CatalogGroup>> _load() async {
    final groups = await widget.loadCatalog(
      widget.field.catalogEndpoint!,
      search: _search,
    );
    widget.onLabels({
      for (final item in groups.expand((g) => g.items))
        if (item.countKey != null) item.countKey!: item.label,
    });
    return groups;
  }

  void _setCount(String countKey, int value) => setState(() {
        value <= 0 ? _counts.remove(countKey) : _counts[countKey] = value;
      });

  @override
  Widget build(BuildContext context) {
    // Sur Android en plein écran (bouton de navigation par-dessus la feuille),
    // le bouton « Valider » doit rester au-dessus de la barre système.
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.field.label ?? '', style: AppTypography.h4),
            AppSpacing.gap12,
            CatalogSearchField(
              hint: widget.field.searchPlaceholder,
              onSearch: (text) => setState(() {
                _search = text;
                _future = _load();
              }),
            ),
            AppSpacing.gap8,
            Expanded(
              child: SingleChildScrollView(
                child: CatalogFutureBuilder(
                  future: _future,
                  onRetry: () => setState(() => _future = _load()),
                  builder: (groups) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final group in groups) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.md),
                          child: Text(group.label,
                              style: AppTypography.bodySmallSemiBold
                                  .copyWith(color: AppColors.gray400)),
                        ),
                        for (final item
                            in group.items.where((i) => i.countKey != null))
                          _ItemRow(
                            item: item,
                            count: _counts[item.countKey] ?? 0,
                            onChanged: (v) => _setCount(item.countKey!, v),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            AppSpacing.gap8,
            PillButton(
              label: 'Valider',
              onPressed: () => Navigator.of(context).pop(_counts),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.item,
    required this.count,
    required this.onChanged,
  });

  final CatalogItem item;
  final int count;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label, style: AppTypography.bodyMedium),
                if (item.description != null)
                  Text(item.description!,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.gray400)),
              ],
            ),
          ),
          CounterStepper(value: count, onChanged: onChanged),
        ],
      ),
    );
  }
}
