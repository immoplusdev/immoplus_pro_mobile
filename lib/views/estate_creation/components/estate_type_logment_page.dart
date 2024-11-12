import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/views/estate_creation/components/estate_amenities_page.dart';
import 'package:immoplus_pro/views/estate_creation/components/estate_wellcome_page.dart';
import 'package:immoplus_pro/views/estate_creation/utils/create_estate_router.dart';
import 'package:immoplus_pro/views/estate_creation/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/views/estate_creation/widgets/list_piece_section.dart';
import 'package:immoplus_pro/views/estate_creation/widgets/logment_type_selection.dart';

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
    PregressStepperLogmentCreating.setStepe(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverPersistentHeader(
              delegate: PregressStepperLogmentCreating(),
            ),
          ),
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
      bottomNavigationBar: StepBottomButton(
        onPreview: () {
          CreateEstateRouter.router.goNamed(EstateWellcommePage.name);
        },
        onNext: (EstateCreationModelBuilder().typeBienImmobilier.isNotEmpty)
            ? () {
                CreateEstateRouter.router.goNamed(EstateAmentitiesPage.name);
              }
            : null,
      ),
    );
  }
}
