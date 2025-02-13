import 'dart:io';

import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/models/files/files_response_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';

class FileUploaderController {
  String? filePath;
  File? file;
  Future<FileDataModel> upladFile() async {
    return await AuthRepository.uplaodFile(file: file!);
  }
}
