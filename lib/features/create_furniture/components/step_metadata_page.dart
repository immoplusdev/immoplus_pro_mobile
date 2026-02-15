import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_furniture/constants/furniture_taxonomy.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/furnitures/theme/furniture_theme.dart';

/// Step 7 du stepper de création de meuble : Détails.

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

  // ──────────────────────────────────────────────
  // DATA
  // ──────────────────────────────────────────────

  static const List<Map<String, String>> _etats = [
    {'value': 'neuf', 'label': 'Neuf'},
    {'value': 'reconditionne', 'label': 'Reconditionné'},
    {'value': 'occasion', 'label': 'Occasion'},
  ];

  /// Types disponibles selon la catégorie sélectionnée.
  List<String> get _availableCategories {
    final categories = FurnitureTaxonomy.typesByCategory.keys.toList();
    if (_selectedCategory != null && !categories.contains(_selectedCategory)) {
      categories.add(_selectedCategory!);
    }
    return categories;
  }

  /// Types disponibles selon la catégorie sélectionnée.
  List<String> get _availableTypes {
    final types = _selectedCategory != null
        ? List<String>.from(
            FurnitureTaxonomy.typesByCategory[_selectedCategory] ?? const [],
          )
        : <String>[];
    if (_selectedType != null && !types.contains(_selectedType)) {
      types.add(_selectedType!);
    }
    return types;
  }

  // ──────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    final meta = _manager.metadata;
    _selectedCategory = _manager.category ??
        meta['category'] as String? ??
        meta['categorie'] as String?;
    _selectedType = _manager.type ?? meta['type'] as String?;
    _selectedEtat = _manager.etat ?? meta['etat'] as String? ?? 'neuf';

    final colors = _parseColors(meta);
    if (colors.isNotEmpty) {
      _selectedColors = colors;
    }

    // Sync dès l'ouverture pour que les valeurs par défaut soient dans le manager
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncMetadata());
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Synchronise les métadonnées vers le manager.

  void _syncMetadata() {
    final colorsHex = _selectedColors
        .map((c) =>
            '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}')
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

    // Compatibilité ancien format "couleur": "FF0000,00FF00"
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

  /// Ouvre un dialog color picker pour ajouter une nouvelle couleur.
  Future<void> _openColorPicker() async {
    Color pickerColor = AppColors.furnitureViolet;

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
        'Sélectionnez une nuance',
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

  /// Supprime une couleur à l'index donné.
  void _removeColor(int index) {
    setState(() {
      _selectedColors.removeAt(index);
    });
    _syncMetadata();
  }

  // ──────────────────────────────────────────────
  // BUILD
  // ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          const SliverGap(16),

          // ── Titre ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child:
                  Text('Détails du meuble', style: FurnitureTheme.sectionTitle),
            ),
          ),

          const SliverGap(20),

          // ── Card unique avec les 4 champs ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: FurnitureTheme.sectionCardDecoration,
                padding: FurnitureTheme.sectionCardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Catégorie ──
                    Text('Catégorie', style: FurnitureTheme.fieldLabel),
                    const Gap(8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: FurnitureTheme.inputDecoration(
                        hintText: 'Sélectionnez une catégorie',
                      ),
                      items: _availableCategories
                          .map((c) => DropdownMenuItem(
                              value: c, child: Text(_displayCategory(c))))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                          // Reset le type quand la catégorie change
                          _selectedType = null;
                        });
                        _syncMetadata();
                      },
                    ),

                    const Gap(16),

                    // ── Type (dynamique) ──
                    Text('Type', style: FurnitureTheme.fieldLabel),
                    const Gap(8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: FurnitureTheme.inputDecoration(
                        hintText: _selectedCategory == null
                            ? 'Choisissez d\'abord une catégorie'
                            : 'Sélectionnez un type',
                      ),
                      items: _availableTypes
                          .map((t) => DropdownMenuItem(
                              value: t, child: Text(_displayType(t))))
                          .toList(),
                      onChanged: _selectedCategory == null
                          ? null
                          : (value) {
                              setState(() {
                                _selectedType = value;
                              });
                              _syncMetadata();
                            },
                    ),

                    const Gap(16),

                    // ── Couleurs (multi-sélection) ──
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
                        // Couleurs sélectionnées
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

                        // Bouton "+"
                        GestureDetector(
                          onTap: _openColorPicker,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.furnitureViolet
                                    .withValues(alpha: 0.5),
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                              color: AppColors.furnitureViolet
                                  .withValues(alpha: 0.08),
                            ),
                            child: Icon(
                              Icons.add,
                              color: AppColors.furnitureViolet,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Gap(20),

                    // ── État (Segmented Control) ──
                    Text('État', style: FurnitureTheme.fieldLabel),
                    const Gap(10),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.furnitureViolet;
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
                              color: AppColors.furnitureViolet
                                  .withValues(alpha: 0.3),
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
                            .map((e) => ButtonSegment<String>(
                                  value: e['value']!,
                                  label: Text(e['label']!),
                                ))
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

          // Espace en bas pour le scroll
          const SliverGap(100),
        ],
      ),
    );
  }
}
