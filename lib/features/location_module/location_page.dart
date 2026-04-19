import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/location_module/components/error_indicator.dart';
import 'package:immoplus_pro/features/location_module/location_controller.dart';

import 'components/button_map.dart';
import 'components/current_location.dart';
import 'components/location_indicator.dart';
import 'components/place_autocomplete_list.dart';
import 'components/search_input.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final LocationController controller = Get.put(LocationController());

  @override
  void dispose() {
    super.dispose();
    Get.delete<LocationController>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: IconButton(
              onPressed: () => context.pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Iconsax.arrow_left, color: Colors.black, size: 20),
            ),
          ),
          centerTitle: true,
          title: Text(
            "Position du bien",
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            // Barre de recherche + bouton carte
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Expanded(child: SearchInput()),
                  const Gap(10),
                  const ButtonMap(),
                ],
              ),
            ),

            // Erreur
            controller.obx(
              (state) => const SizedBox(),
              onLoading: const SizedBox(),
              onError: (error) => ErrorIndicator(description: error.toString()),
            ),

            // Ma position actuelle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: CurrentLocationSection(),
            ),

            // Séparateur discret
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Colors.grey.shade200, height: 1),
            ),

            // Résultats autocomplete
            Expanded(
              child: controller.obx(
                (state) => const PlaceAutocompleteList(),
                onLoading: const LocationIndicator(),
                onError: (error) => const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
