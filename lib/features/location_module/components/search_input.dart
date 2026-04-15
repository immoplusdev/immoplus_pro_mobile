import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/location_module/location_controller.dart';

class SearchInput extends GetView<LocationController> {
  const SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
            14), // Changé à 15 pour être plus proche des autres éléments
        // border: Border.all(color: AppColors.primaryLite),
      ),
      child: TextField(
        autofocus: true,
        onChanged: (value) => controller.subject.add(value),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: "Rechercher une adresse...",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              Iconsax.search_normal_1,
              color:Colors.grey.shade400,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
