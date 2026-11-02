import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/catalog_icon_tile.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/outlined_action_button.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/catalog_loader.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/field_shell.dart';

/// Champ `single_select_cards` alimenté par un catalogue (types de logement).
/// La valeur est le `code` du type choisi.
class PropertyTypeField extends StatefulWidget {
  const PropertyTypeField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.loadCatalog,
    required this.onChanged,
  });

  final CreationField field;
  final String? value;
  final String? errorText;
  final CatalogLoader loadCatalog;
  final ValueChanged<String> onChanged;

  @override
  State<PropertyTypeField> createState() => _PropertyTypeFieldState();
}

class _PropertyTypeFieldState extends State<PropertyTypeField> {
  static const int _collapsedCount = 3;
  static const int _columns = 3;

  late Future<List<CatalogGroup>> _future = _load();
  bool _expanded = false;

  Future<List<CatalogGroup>> _load() =>
      widget.loadCatalog(widget.field.catalogEndpoint!);

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: widget.field.label,
      helperText: widget.field.helperText,
      errorText: widget.errorText,
      child: CatalogFutureBuilder(
        future: _future,
        onRetry: () => setState(() => _future = _load()),
        builder: (groups) {
          final items = groups.expand((g) => g.items).toList();
          final selectedIndex = items.indexWhere((i) => i.code == widget.value);
          // Un type choisi hors des premiers reste visible.
          final showAll = _expanded || selectedIndex >= _collapsedCount;
          final visible =
              showAll ? items : items.take(_collapsedCount).toList();

          return Column(
            children: [
              GridView.count(
                crossAxisCount: _columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.xs,
                crossAxisSpacing: AppSpacing.xs,
                childAspectRatio: 1.2,
                children: [
                  for (final item in visible)
                    CatalogIconTile(
                      item: item,
                      mutedWhenUnselected: true,
                      selected: widget.value == item.code,
                      onTap: () => widget.onChanged(item.code),
                    ),
                ],
              ),
              if (items.length > _collapsedCount) ...[
                AppSpacing.gap12,
                OutlinedActionButton(
                  label: showAll
                      ? 'Voir moins de types de logement'
                      : 'Voir tous les types de logement',
                  trailingIcon: showAll
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  onPressed: () => setState(() => _expanded = !showAll),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
