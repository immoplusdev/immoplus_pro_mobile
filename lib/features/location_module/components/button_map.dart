import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/location_module/location_map_page.dart';

class ButtonMap extends StatelessWidget {
  const ButtonMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: IconButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          AppRouter.router.pushNamed(LocationMapPage.name);
        },
        icon: Icon(
          Iconsax.map_1,
          color: AppColors.white,
          size: 22,
        ),
      ),
    );
  }
}
