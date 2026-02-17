import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_furniture/constants/furniture_taxonomy.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/furnitures/theme/furniture_theme.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Step 7 du stepper de creation de meuble : Details.
class StepMetadataPage extends StatefulWidget {
  const StepMetadataPage({super.key});

  static String name = 'step_metadata_page';

  @override
  State<StepMetadataPage> createState() => _StepMetadataPageState();
}

class _StepMetadataPageState extends State<StepMetadataPage> {
  final _manager = FurnitureCreationManager();

  List<Color> _selectedColors = [];
  String? _selectedCategory;
  String? _selectedType;
  String _selectedEtat = 'neuf';

  static const List<Map<String, String>> _etats = [
    {'value': 'neuf', 'label': 'Neuf'},
    {'value': 'reconditionne', 'label': 'Reconditionne'},
    {'value': 'occasion', 'label': 'Occasion'},
  ];

  @override
  void initState() {
    super.initState();

    final meta = _manager.metadata;
    final rawCategory = _manager.category ??
        meta['category'] as String? ??
        meta['categorie'] as String?;
    final rawType = _manager.type ?? meta['type'] as String?;

    _selectedCategory = _validateCategory(rawCategory);
    _selectedType = _validateType(rawType);

    _selectedEtat = _manager.etat ?? meta['etat'] as String? ?? 'neuf';

    final colors = _parseColors(meta);
    if (colors.isNotEmpty) {
      _selectedColors = colors;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _syncMetadata());
  }

  void _syncMetadata() {
    final colorsHex = _selectedColors
        .map(
          (c) =>
              '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
        )
        .join(',');

    _manager.category = _selectedCategory;
    _manager.type = _selectedType;
    _manager.etat = _selectedEtat;
    _manager.metadata = {
      'colors': colorsHex.isEmpty
          ? <String>[]
          : colorsHex.split(',').where((e) => e.isNotEmpty).toList(),
    };
  }

  List<Color> _parseColors(Map<String, dynamic> metadata) {
    final dynamic colorsRaw = metadata['colors'];
    if (colorsRaw is List) {
      return colorsRaw
          .whereType<String>()
          .map((hex) => _hexToColor(hex))
          .whereType<Color>()
          .toList();
    }

    final legacy = metadata['couleur'] as String? ?? '';
    if (legacy.isEmpty) return <Color>[];

    return legacy
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((hex) => _hexToColor(hex))
        .whereType<Color>()
        .toList();
  }

  Color? _hexToColor(String rawHex) {
    final hex = rawHex.trim().replaceAll('#', '');
    if (hex.length != 6) return null;

    try {
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }

  String _displayCategory(String category) =>
      FurnitureTaxonomy.categoryLabels[category] ?? category;

  String _displayType(String type) => type
      .split('-')
      .where((s) => s.isNotEmpty)
      .map((s) => s[0].toUpperCase() + s.substring(1))
      .join(' ');

  String? _validateCategory(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final value = raw.trim();
    return FurnitureTaxonomy.categories.contains(value) ? value : null;
  }

  String? _validateType(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final value = raw.trim();
    return FurnitureTaxonomy.allTypes.contains(value) ? value : null;
  }

  List<DropdownItem<String>> get _categoryItems => FurnitureTaxonomy.categories
      .map(
        (category) => DropdownItem<String>(
          label: _displayCategory(category),
          value: category,
          selected: category == _selectedCategory,
        ),
      )
      .toList();

  List<DropdownItem<String>> get _typeItems => FurnitureTaxonomy.allTypes
      .map(
        (type) => DropdownItem<String>(
          label: _displayType(type),
          value: type,
          selected: type == _selectedType,
        ),
      )
      .toList();

  FieldDecoration _fieldDecoration(String hintText) => FieldDecoration(
        hintText: hintText,
        backgroundColor: Colors.white,
        showClearIcon: false,
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.grey.shade600,
        ),
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14,
        ),
        selectedItemTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.18),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
      );

  DropdownDecoration get _dropdownDecoration => DropdownDecoration(
        backgroundColor: Colors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(12),
        maxHeight: 260,
      );

  DropdownItemDecoration get _dropdownItemDecoration => DropdownItemDecoration(
        selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.08),
        selectedTextColor: AppColors.primary,
        textColor: Colors.black87,
      );

  SearchFieldDecoration get _searchFieldDecoration => SearchFieldDecoration(
        hintText: 'Rechercher...',
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14,
        ),
        textStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
        searchIcon: Icon(
          Icons.search,
          color: Colors.grey.shade600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.4),
          ),
        ),
      );

  String? _extractSelectedValue(dynamic selectedItems) {
    if (selectedItems is! List || selectedItems.isEmpty) return null;

    final first = selectedItems.first;
    if (first is DropdownItem<String>) return first.value;
    if (first is String) return first;

    return null;
  }

  Future<void> _openColorPicker() async {
    Color pickerColor = AppColors.primary;

    final bool picked = await ColorPicker(
      color: pickerColor,
      onColorChanged: (Color color) {
        pickerColor = color;
      },
      width: 40,
      height: 40,
      borderRadius: 20,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Choisir une couleur',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        'Selectionnez une nuance',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      showColorCode: false,
      showColorName: false,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.wheel: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
      },
    ).showPickerDialog(
      context,
      constraints: const BoxConstraints(
        minHeight: 260,
        minWidth: 100,
        maxWidth: 220,
      ),
    );

    if (picked) {
      setState(() {
        _selectedColors.add(pickerColor);
      });
      _syncMetadata();
    }
  }

  void _removeColor(int index) {
    setState(() {
      _selectedColors.removeAt(index);
    });
    _syncMetadata();
  }

  @override
  Widget build(BuildContext context) {
    final categoryItems = _categoryItems;
    final typeItems = _typeItems;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          const SliverGap(16),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child:
                  Text('Details du meuble', style: FurnitureTheme.sectionTitle),
            ),
          ),
          const SliverGap(20),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: FurnitureTheme.sectionCardDecoration,
                padding: FurnitureTheme.sectionCardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categorie', style: FurnitureTheme.fieldLabel),
                    const Gap(8),
                    MultiDropdown<String>(
                      items: categoryItems,
                      singleSelect: true,
                      searchEnabled: true,
                      searchDecoration: _searchFieldDecoration,
                      fieldDecoration:
                          _fieldDecoration('Selectionnez une categorie'),
                      dropdownDecoration: _dropdownDecoration,
                      dropdownItemDecoration: _dropdownItemDecoration,
                      onSelectionChange: (selectedItems) {
                        final value = _extractSelectedValue(selectedItems);
                        setState(() {
                          _selectedCategory = _validateCategory(value);
                        });
                        _syncMetadata();
                      },
                    ),
                    const Gap(16),
                    Text('Type', style: FurnitureTheme.fieldLabel),
                    const Gap(8),
                    MultiDropdown<String>(
                      items: typeItems,
                      singleSelect: true,
                      enabled: true,
                      searchEnabled: true,
                      searchDecoration: _searchFieldDecoration,
                      fieldDecoration: _fieldDecoration('Selectionnez un type'),
                      dropdownDecoration: _dropdownDecoration,
                      dropdownItemDecoration: _dropdownItemDecoration,
                      onSelectionChange: (selectedItems) {
                        final value = _extractSelectedValue(selectedItems);
                        setState(() {
                          _selectedType = _validateType(value);
                        });
                        _syncMetadata();
                      },
                    ),
                    const Gap(16),
                    Text('Couleur', style: FurnitureTheme.fieldLabel),
                    const Gap(4),
                    Text(
                      'Appuyez sur + pour ajouter, appuyez sur une couleur pour la retirer.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const Gap(10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (int i = 0; i < _selectedColors.length; i++)
                          GestureDetector(
                            onTap: () => _removeColor(i),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ColorIndicator(
                                  width: 42,
                                  height: 42,
                                  borderRadius: 21,
                                  color: _selectedColors[i],
                                  hasBorder: true,
                                  borderColor: Colors.grey.shade300,
                                ),
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade400,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        GestureDetector(
                          onTap: _openColorPicker,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.5),
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                              color: AppColors.primary.withValues(alpha: 0.08),
                            ),
                            child: Icon(
                              Icons.add,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Text('Etat', style: FurnitureTheme.fieldLabel),
                    const Gap(10),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.primary;
                            }
                            return Colors.white;
                          }),
                          foregroundColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.white;
                            }
                            return Colors.black87;
                          }),
                          side: WidgetStateProperty.all(
                            BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          textStyle: WidgetStateProperty.all(
                            const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        segments: _etats
                            .map(
                              (e) => ButtonSegment<String>(
                                value: e['value']!,
                                label: Text(e['label']!),
                              ),
                            )
                            .toList(),
                        selected: {_selectedEtat},
                        onSelectionChanged: (selection) {
                          setState(() {
                            _selectedEtat = selection.first;
                          });
                          _syncMetadata();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverGap(100),
        ],
      ),
    );
  }
}
