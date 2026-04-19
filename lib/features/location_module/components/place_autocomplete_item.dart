import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/configs/autocomplete_response.dart';
import 'package:immoplus_pro/features/location_module/location_controller.dart';

class PlaceAutocompleteItem extends GetView<LocationController> {
  const PlaceAutocompleteItem({Key? key, required this.item}) : super(key: key);

  final CustomPrediction item;

  @override
  Widget build(BuildContext context) {
    final mainText = (item.structuredFormatting != null)
        ? item.structuredFormatting!.mainText ?? item.description ?? ""
        : item.description ?? "";

    final secondaryText = (item.structuredFormatting != null)
        ? item.structuredFormatting!.secondaryText ?? ""
        : "";

    return InkWell(
      onTap: () => controller.onAutocompleteItemClick(item),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Iconsax.location,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mainText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (secondaryText.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      secondaryText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Iconsax.arrow_right_3,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
