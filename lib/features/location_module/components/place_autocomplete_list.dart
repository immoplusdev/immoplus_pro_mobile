import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:immoplus_pro/features/location_module/components/place_autocomplete_item.dart';
import 'package:immoplus_pro/features/location_module/location_controller.dart';

class PlaceAutocompleteList extends GetView<LocationController> {
  const PlaceAutocompleteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => PlaceAutocompleteItem(
              item: controller.placeAutocompleteList[index]),
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Colors.blueGrey.withOpacity(0.1),
          ),
          itemCount: controller.placeAutocompleteList.length,
        ));
  }
}
