import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:immoplus_pro/features/contract/logic/contract_mode.dart';
// import 'package:immoplus_pro/features/contract/screens/contract_page.dart';

class CguCheckbox extends StatelessWidget {
  final ValueNotifier<bool> cguNotifier;

  const CguCheckbox({
    super.key,
    required this.cguNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: cguNotifier,
      builder: (BuildContext context, bool value, child) {
        return Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              value: value,
              fillColor: value
                  ? WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primary)
                  : WidgetStateProperty.all(Colors.white),
              onChanged: (val) {
                cguNotifier.value = val ?? false;
              },
            ),
            const Text("j'approuve les"),
            TextButton(
              onPressed: () {
                cguNotifier.value = !value;
              },
              child: Text(
                'Termes & conditions',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // void _openContractPage(BuildContext context) {
  //   context.pushNamed(
  //     ContractPage.routeName,
  //     extra: {
  //       'isSigned': false,
  //       'mode': ContractMode.sign,
  //       'onSigned': () {
  //         cguNotifier.value = true;
  //         context.pop();
  //       },
  //     },
  //   );
  // }
}
