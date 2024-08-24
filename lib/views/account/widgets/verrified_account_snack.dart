import 'dart:developer';

import 'package:flutter/material.dart';

Future<void> showVerrifiedAccountSnack(BuildContext context) async {
  // Future.delayed(
  //     Duration(seconds: 0),
  //     () => ((!UserModel().emailVerified! || !UserModel().phoneVerified!) &&
  //             UserModel().id != '')
  //         ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             duration: const Duration(seconds: 10),
  //             //padding: EdgeInsets.only(left: 10, right: 10),
  //             behavior: SnackBarBehavior.floating,
  //             margin: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
  //             elevation: 2,
  //             content: SizedBox(
  //               height: 80,
  //               //color: Colors.red,
  //               child: Column(
  //                 children: [
  //                   const Text(
  //                     'Votr adresse email ou votre numéro de téléphone n’ont pas encore été confirmées.',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   TextButton(
  //                     child: const Text(
  //                       'VOIRE LA PAGE DE VÉRIFICATION DE COMPTE',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 16,
  //                         color: Colors.orange,
  //                       ),
  //                     ),
  //                     onPressed: () {
  //                       ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //                       Navigator.of(context, rootNavigator: true)
  //                           .push(MaterialPageRoute(
  //                         builder: (context) => const CheckMyAccount(),
  //                       ));
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ))
  //         : log('COUNT VERRIFIED'));
}
