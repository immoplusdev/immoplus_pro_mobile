import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/models/configs/commune_collection.dart';
import 'package:immoplus_pro/data/models/configs/ville_collection.dart';
import 'package:immoplus_pro/data/providers/configs_provider.dart';

class ConfigRepository {
  static Future<CommuneCollection> getCommunes(
      {required int page, required int perPage}) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response =
          await ConfigsProvider(DioClient().dio).getCommunes(page, perPage);

      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<VilleCollection> getVilles(
      {required int page, required int perPage}) async {
    //DioClient().dio.options.queryParameters['meta'] = '*';
    try {
      final response =
          await ConfigsProvider(DioClient().dio).getVilles(page, perPage);

      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }
}
