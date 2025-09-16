import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/home_page/utils/custom_popup.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class SavingButton extends StatefulWidget {
  final VoidCallback onrefresh;
  const SavingButton({
    super.key,
    required this.onrefresh,
  });

  @override
  State<SavingButton> createState() => _SavingButtonState();
}

class _SavingButtonState extends State<SavingButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomButtom(
        text: "Enregistrer les modifications",
        onClick: () async {
          try {
            CustomPopup.showLoagingToast(text: "Modification en cours");

            await SessionManager().getCurrentUser();

            await LogmentRepository.updateResidence(
                    id: ResidenceCreationModelBuilder().id,
                    fields: ResidenceCreationModelBuilder().build().toJson())
                .then(
              (value) {
                EasyLoading.dismiss();
                widget.onrefresh();
                // AppRouter.router.push(
                //     '/logment_page/${ResidenceCreationModelBuilder().id}');
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
