import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/features/payment_module/components/mtn/mtn_validator_page.dart';
import 'package:immoplus_pro/features/payment_module/services/payment_services.dart';
import 'package:immoplus_pro/features/payment_module/utils/payment_data.dart';
import 'package:immoplus_pro/features/payment_module/utils/payment_utils.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/utils/formuar_controller.dart';
import 'package:immoplus_pro/utils/operator_payment.dart';
import 'package:immoplus_pro/utils/utils.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../utils/mtn_payment_router.dart';

class MtnNumberPage extends StatefulWidget {
  const MtnNumberPage({super.key});
  static String name = 'number';
  @override
  State<MtnNumberPage> createState() => _MtnNumberPageState();
}

class _MtnNumberPageState extends State<MtnNumberPage> {
  final FormController _formController = FormController(
      productId: 0, phoneNumber: TextEditingController(text: ''));
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loadingButton = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      MtnPaymentRouter.pageStateNotifier.value = MtnNumberPage.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                foregroundImage: NetworkImage(
                    OrderPaymentController.selectedOperator.logo ?? ''),
              ),
              title: Text(
                'Paiement par ${OrderPaymentController.selectedOperator.name}',
              ),
              titleTextStyle: Theme.of(context).textTheme.titleLarge,
              trailing: IconButton(
                icon: const Icon(
                  CupertinoIcons.clear_circled_solid,
                  color: Colors.black,
                ),
                onPressed: () {
                  AppDialog.confirm(
                      context: context,
                      content: "Voulez vous annuler l'opération ?",
                      rollback: () {
                        AppRouter.router.pop();
                        AppRouter.router.pop();
                      });
                },
              ),
            ),
            ListTile(
              tileColor: Colors.white,
              leading: const FaIcon(FontAwesomeIcons.moneyBill,
                color: Colors.green,
              ),
              title:
                  Text(Utils.formatCurrency(PaymentData.of(context)!.amount)),
              titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            CustomTextField(
              fillColor: Colors.white,
              autofocus: true,
              controller: _formController.phoneNumber,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              labelText: 'Numéro de telephone valide',
              prefixIcon: const Icon(CupertinoIcons.phone),
              validator: (String? value) => PaymentUtils.numberValidator(
                  number: value!.replaceAll(' ', ''),
                  operatorName:
                      OrderPaymentController.selectedOperator.value ?? ''),
              inputFormatters: [
                MaskTextInputFormatter(
                    mask: '## ## ## ## ##', filter: {'#': RegExp(r'[0-9]')})
              ],
            ),
            CustomButtom(
              isLoading: loadingButton,
              text: 'Confirmer',
              onClick: () {
                // MtnPaymentRouter.pageStateNotifier.value =
                //     MtnValidatorPage.name;
                // MtnPaymentRouter.router.goNamed(MtnValidatorPage.name,
                //     extra: PaymentIntentModel(paymentMethod: 'mtn'));

                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loadingButton = true;
                  });
                  PaymentServices.initPaymentRequest(
                    context: context,
                    number:
                        _formController.phoneNumber!.text.replaceAll(' ', ''),
                    collection: PaymentData.of(context)!.productType,
                    itemID: PaymentData.of(context)!.orderID,
                    onSuccess: () {
                      AppRouter.router.pop();
                      AppRouter.router.pop();
                      AppDialog.info(
                        context: NavigationService.navigatorKey.currentContext!,
                        content:
                            "Votre demande de retrait a été enregistrée avec succès. Votre versement sera effectué dans les plus brefs délais sur votre moyen de paiement",
                        icon: const FaIcon(FontAwesomeIcons.moneyBills,
                          color: Colors.green,
                        ),
                        rollback: () {
                          NavigationService.navigatorKey.currentContext!.pop();
                        },
                      );
                      // setState(() {
                      //   loadingButton = false;
                      // });
                      // MtnPaymentRouter.pageStateNotifier.value =
                      //     MtnValidatorPage.name;
                      // MtnPaymentRouter.router
                      //     .goNamed(MtnValidatorPage.name, extra: p);
                    },
                    onFailed: () {
                      setState(() {
                        loadingButton = false;
                      });
                    },
                  );
                }
              },
            ),
            //Gap(MediaQuery.viewInsetsOf(context).bottom)
          ],
        ),
      ),
    );
  }
}
