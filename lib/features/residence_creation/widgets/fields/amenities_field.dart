import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/catalog_icon_tile.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/category_tabs.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/catalog_loader.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/field_shell.dart';

/// Champ `multi_select_catalog` (équipements). La valeur est la liste des
/// `code` sélectionnés. Les catégories du catalogue deviennent des onglets ;
/// pendant une recherche, tous les résultats sont affichés.
class AmenitiesField extends StatefulWidget {
  const AmenitiesField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.loadCatalog,
    required this.onChanged,
  });

  final CreationField field;
  final List<String> value;
  final String? errorText;
  final CatalogLoader loadCatalog;
  final ValueChanged<List<String>> onChanged;

  @override
  State<AmenitiesField> createState() => _AmenitiesFieldState();
}

class _AmenitiesFieldState extends State<AmenitiesField> {
  static const int _columns = 3;

  String _search = '';
  String? _selectedGroupKey;
  late Future<List<CatalogGroup>> _future = _load();

  Future<List<CatalogGroup>> _load() => widget.loadCatalog(
        widget.field.catalogEndpoint!,
        search: _search,
      );

  bool get _isSearching => _search.trim().isNotEmpty;

  void _toggle(String code) {
    final selected = [...widget.value];
    selected.contains(code) ? selected.remove(code) : selected.add(code);
    widget.onChanged(selected);
  }

  List<CatalogItem> _visibleItems(List<CatalogGroup> groups) {
    if (groups.isEmpty) return const [];
    final hasTabs = groups.length > 1 && !_isSearching;

    if (hasTabs) {
      final group = groups.firstWhere(
        (g) => g.key == _selectedGroupKey,
        orElse: () => groups.first,
      );
      return group.items;
    }

    // Recherche ou catalogue sans catégories : tout, sans doublons.
    final byCode = <String, CatalogItem>{};
    for (final item in groups.expand((g) => g.items)) {
      byCode.putIfAbsent(item.code, () => item);
    }
    return byCode.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: widget.field.label,
      helperText: widget.field.helperText,
      errorText: widget.errorText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CatalogSearchField(
            hint: widget.field.searchPlaceholder,
            onSearch: (text) => setState(() {
              _search = text;
              _future = _load();
            }),
          ),
          AppSpacing.gap12,
          CatalogFutureBuilder(
            future: _future,
            onRetry: () => setState(() => _future = _load()),
            builder: (groups) {
              final items = _visibleItems(groups);
              final showTabs = groups.length > 1 && !_isSearching;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showTabs) ...[
                    CategoryTabs(
                      labels: {for (final g in groups) g.key: g.label},
                      selectedKey: _selectedGroupKey ?? groups.first.key,
                      onSelected: (key) =>
                          setState(() => _selectedGroupKey = key),
                    ),
                    AppSpacing.gap12,
                  ],
                  if (items.isEmpty)
                    Text('Aucun équipement trouvé',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.gray400))
                  else
                    GridView.count(
                      crossAxisCount: _columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppSpacing.xs,
                      crossAxisSpacing: AppSpacing.xs,
                      childAspectRatio: 1.05,
                      children: [
                        for (final item in items)
                          CatalogIconTile(
                            item: item,
                            selected: widget.value.contains(item.code),
                            onTap: () => _toggle(item.code),
                          ),
                      ],
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
