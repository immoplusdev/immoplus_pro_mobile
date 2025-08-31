import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_amenities_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_wellcome_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_navigation.dart';
import 'package:immoplus_pro/features/create_estate/widgets/list_piece_section.dart';
import 'package:immoplus_pro/features/create_estate/widgets/logment_type_selection.dart';
import 'package:immoplus_pro/features/create_estate/widgets/saving_estate_button.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';

class EstateTypePage extends StatefulWidget {
  const EstateTypePage({super.key});
  static String name = "type_logment_page";
  @override
  State<EstateTypePage> createState() => _EstateTypePageState();
}

class _EstateTypePageState extends State<EstateTypePage> {
  @override
  void initState() {
    super.initState();
    //PregressStepperEstateCreating.setStepe(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Text('Décrivez nous votre bien',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
          ),
          const SliverGap(20),
          EstateTypeSelection(
            onSlect: (p0) {
              setState(() {
                EstateCreationModelBuilder().typeBienImmobilier =
                    p0['text'].toString().toLowerCase();
              });
            },
          ),
          const SliverGap(20),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: Text('Nombre de pièces du logement',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          const SliverGap(10),
          const EstateListPieceSection(),
          const SliverToBoxAdapter(),
        ],
      ),
      bottomNavigationBar: EstateCreationModelBuilder().editing
          ? SavingEstateButton()
          : StepBottomButton(
              onPrevious: () {
                CreationEstateNavigation.goToPage(
                    pageName: EstateWellcommePage.name);
              },
              onNext:
                  (EstateCreationModelBuilder().typeBienImmobilier.isNotEmpty)
                      ? () {
                          CreationEstateNavigation.goToPage(
                              pageName: EstateAmentitiesPage.name);
                        }
                      : null,
            ),
    );
  }
}
