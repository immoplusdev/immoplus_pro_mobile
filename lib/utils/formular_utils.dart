import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:immoplus_pro/request_path.dart';

class FormUtils {
  static void showAlertConfirmDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('Proceed with destructive action?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  static String? emailValidator({String? email}) {
    if (email == null || email.isEmpty) {
      return 'Aucune adresse mail';
    } else if (!GetUtils.isEmail(email)) {
      return 'Adresse non valide';
    }
    return null;
  }

  static bool isValidEmail(String? email) {
    if (email == null || email.trim().isEmpty) return false;
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  static String? passwordValidator({String? password}) {
    if (password == null || password.isEmpty) {
      return 'Aucun mot de passe';
    } else if (!RegExp(r'^.{4,}$').hasMatch(password)) {
      return 'Mot de passe trop court';
    }
    return null;
  }

  static String? fieldValidator({String? value}) {
    if (value == null || value.isEmpty) {
      return 'Veuillez remplir ce champ';
    }
    return null;
  }

  static String? internationalNumberValidator({String? number}) {
    if (number == null ||
        number.isEmpty ||
        number.replaceAll(" ", "").toString().isEmpty) {
      return 'veillez entrer votre numéro';
    }

    return null;
  }

  static String? numberValidator({String? number}) {
    if (number == null || number.isEmpty || number.toString().isEmpty) {
      return 'veillez entrer votre numéro';
    }
    final RegExp regex = RegExp(r'^(07|01|05)[0-9]{8}$');
    if (!regex.hasMatch(number.replaceAll(" ", ""))) {
      print(number.replaceAll(" ", ""));
      return 'Numéro de téléphone ivoirien invalide';
    }

    return null;
  }

  String getPeriod({required String value}) => switch (value.toLowerCase()) {
        'monthly' => ' par mois',
        'day' => ' par nuit',
        'daily' => ' par nuit',
        'year' => ' par année',
        _ => '',
      };
  static Dio _dio = Dio();
  static Future<List<DateTime>> getDateBooked({required String id}) async {
    Response rp = await _dio.get(
        "${RequestPath.baseUrl}/reservations/data/residence/occupied-dates/$id");
    List<DateTime> markedDates = [];

    List _data = rp.data['data']['dates'];
    inspect(_data);
    _data.forEach(
      (e) {
        markedDates.add(DateTime.parse(e['date']));
      },
    );

    return markedDates;
  }
}
