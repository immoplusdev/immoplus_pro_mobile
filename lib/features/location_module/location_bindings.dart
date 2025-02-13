import 'package:immoplus_pro/services/location_service.dart';
import 'package:immoplus_pro/features/location_module/location_controller.dart';
import 'package:get/get.dart';

class LocationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocationController());
    //Get.lazyPut(() => LocationService());
  }
}
