import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:immoplus_pro/features/location_module/location_controller.dart';

class ButtonTest extends GetView<LocationController> {
  const ButtonTest({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        var addresses = [
          {"lat": 5.439118199999999, "lng": -4.0353806},
          {"lat": 5.3740084845236575, "lng": -4.008035076083904},
        ];
        addresses.forEachIndexed((index, element) {
          // controller.getCurrentPosition(
          //     latitude: element["lat"] ?? 0, longitude: element["lng"] ?? 0);
        });
      },
      child: const Text("TEST"),
    );
  }
}
