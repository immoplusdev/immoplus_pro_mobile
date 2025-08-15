import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:intl/intl.dart';

Future<String?> uploadFile({required File file}) async {
  EasyLoadingHandler.showLoagingToast(text: "Envoie des images");

  FileDataModel response = await AuthRepository.uplaodFile(file: file);
  EasyLoading.dismiss();
  return response.data!.id;
}

String formatCfa(int amount) {
  final formatter = NumberFormat("#,##0", "fr_FR");
  return "${formatter.format(amount)} F";
}
