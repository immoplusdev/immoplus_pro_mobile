import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/features/create_residence/screens/amenities_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/wellcome_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';
import 'package:immoplus_pro/features/create_residence/widgets/list_piece_section.dart';
import 'package:immoplus_pro/features/create_residence/widgets/logment_type_selection.dart';
import 'package:immoplus_pro/features/create_residence/widgets/saving_button.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';

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
    //PregressStepperResidenceCreating.setStepe(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.scafold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverSafeArea(
            //   sliver: SliverPersistentHeader(
            //     pinned: true,
            //     floating: false, // Ne le rend pas flottant
            //     delegate: PregressStepperResidenceCreating(),
            //   ),
            // ),
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
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   final data = List.generate(
      //     ResidenceCreationModelBuilder().pieces.length,
      //     (index) => ResidenceCreationModelBuilder().pieces[index].toJson(),
      //   );
      //   print(data);
      // }),
      bottomNavigationBar: (ResidenceCreationModelBuilder().editing)
          ? SizedBox()
          : StepBottomButton(
              onPrevious: () {
                CreationResidenceNavigation.goToPage(
                    pageName: WellcommePage.name);
              },
              onNext: (ResidenceCreationModelBuilder().typeResidence.isNotEmpty)
                  ? () {
                      CreationResidenceNavigation.goToPage(
                          pageName: AmentitiesPage.name);
                    }
                  : null,
            ),
    );
  }
}
