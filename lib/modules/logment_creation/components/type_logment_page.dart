import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/modules/logment_creation/components/amenities_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/wellcome_page.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/list_piece_section.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/logment_type_selection.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';

class TypeLogmentPage extends StatefulWidget {
  const TypeLogmentPage({super.key});
  static String name = "type_logment_page";
  @override
  State<TypeLogmentPage> createState() => _TypeLogmentPageState();
}

class _TypeLogmentPageState extends State<TypeLogmentPage> {
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
              child: Text('Décrivez nous votre logement',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
          ),
          const SliverGap(20),
          LogmentTypeSelection(
            onSlect: (p0) {
              setState(() {
                ResidenceCreationModelBuilder().typeResidence =
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
          const ListPieceSection(),
          const SliverToBoxAdapter(),
        ],
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   final data = List.generate(
      //     ResidenceCreationModelBuilder().pieces.length,
      //     (index) => ResidenceCreationModelBuilder().pieces[index].toJson(),
      //   );
      //   print(data);
      // }),
      bottomNavigationBar: StepBottomButton(
        onPreview: () {
          CreateLogmentRouter.router.goNamed(WellcommePage.name);
        },
        onNext: (ResidenceCreationModelBuilder().typeResidence.isNotEmpty)
            ? () {
                CreateLogmentRouter.router.goNamed(AmentitiesPage.name);
              }
            : null,
      ),
    );
  }
}
