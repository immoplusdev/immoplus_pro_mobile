import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/home_page/utils/custom_popup.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class SavingEstateButton extends StatefulWidget {
  const SavingEstateButton({
    required this.onrefresh,
    super.key,
  });

  final VoidCallback onrefresh;

  @override
  State<SavingEstateButton> createState() => _SavingEstateButtonState();
}

class _SavingEstateButtonState extends State<SavingEstateButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: CustomButtom(
        text: "Enregistrer les modifications",
        onClick: () async {
          try {
            CustomPopup.showLoagingToast(text: "Modification en cours");

            await SessionManager().getCurrentUser();

            await BienImmobilierRepository.update(
                    id: EstateCreationModelBuilder().id,
                    fields: EstateCreationModelBuilder().build().toJson())
                .then(
              (value) {
                EasyLoading.dismiss();
                widget.onrefresh();
                // AppRouter.router
                //     .push('/logment_page/${EstateCreationModelBuilder().id}');
              },
            );
          } catch (e) {
            CustomPopup.showErrorToast(text: 'Modification échoué');
          }
        },
      ),
    );
  }
}
