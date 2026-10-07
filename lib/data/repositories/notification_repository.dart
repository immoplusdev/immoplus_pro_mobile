import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/providers/notification_provider.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NotificationModule {
  @lazySingleton
  NotificationProvider get notificationProvider =>
      NotificationProvider(DioClient().dio);
}

@lazySingleton
class NotificationRepository {
  final NotificationProvider _provider;

  NotificationRepository(this._provider);

  Future<void> registerPushInstallation({
    required String installationId,
    required Map<String, dynamic> body,
  }) async {
    await _provider.registerPushInstallation(
      installationId,
      body,
    );
  }

  Future<void> deletePushInstallation(String installationId) async {
    await _provider.deletePushInstallation(installationId);
  }
}
