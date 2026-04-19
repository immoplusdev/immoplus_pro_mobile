import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/location_module/location_controller.dart';

class CurrentLocationSection extends GetView<LocationController> {
  const CurrentLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) => _buildButton(
        onPressed: () => controller.getCurrentPosition(),
        isEnabled: true,
      ),
      onLoading: _buildButton(
        onPressed: null,
        isEnabled: false,
        isLoading: true,
      ),
      onError: (error) => _buildButton(
        onPressed: null,
        isEnabled: false,
      ),
    );
  }

  Widget _buildButton({
    VoidCallback? onPressed,
    required bool isEnabled,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        // decoration: BoxDecoration(
        //   color: isEnabled
        //       ? AppColors.primary.withOpacity(0.08)
        //       : Colors.grey.shade100,
        //   borderRadius: BorderRadius.circular(14),
        // ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Iconsax.gps,
                color:  AppColors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Utiliser ma position actuelle',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:Colors.black,
                ),
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else
              Icon(
                Iconsax.arrow_right_3,
                color: Colors.grey.shade400,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
