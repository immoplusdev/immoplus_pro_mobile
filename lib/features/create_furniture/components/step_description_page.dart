import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/furnitures/theme/furniture_theme.dart';

/// Step 2 du stepper de création de meuble : Description.
class StepDescriptionPage extends StatefulWidget {
  const StepDescriptionPage({super.key});

  static String name = 'step_description_page';

  @override
  State<StepDescriptionPage> createState() => _StepDescriptionPageState();
}

class _StepDescriptionPageState extends State<StepDescriptionPage> {
  final _manager = FurnitureCreationManager();
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: _manager.description ?? '');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          const SliverGap(16),

          // ── Titre de la section ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Décrivez votre meuble',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          const SliverGap(8),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Une bonne description aide les acheteurs à mieux comprendre '
                'votre meuble. Précisez les matériaux, dimensions, état, etc.',
                style: FurnitureTheme.fieldLabel,
              ),
            ),
          ),

          const SliverGap(20),

          // ── Champ description ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: FurnitureTheme.sectionCardDecoration,
                padding: FurnitureTheme.sectionCardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description *', style: FurnitureTheme.fieldLabel),
                    const Gap(8),
                    TextFormField(
                      controller: _descriptionController,
                      minLines: 8,
                      maxLines: 15,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      decoration: FurnitureTheme.inputDecoration(
                        hintText:
                            'Décrivez votre meuble (matériaux, dimensions, état, couleur…)',
                      ),
                      onChanged: (value) {
                        _manager.description = value.trim();
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La description est obligatoire';
                        }
                        return null;
                      },
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
