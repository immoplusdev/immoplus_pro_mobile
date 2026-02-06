import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

class MainRegistrationButton extends StatelessWidget {
  const MainRegistrationButton(
      {super.key, required this.assetPath, required this.title, this.onTap});
  final String assetPath;
  final String title;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.primaryLite,
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.blue0F41D9,
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(8),
        width: 190,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: 72,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.blueE6F2F2,
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: AppColors.blue8ED3FF),
              ),
              child: Icon(
                FontAwesomeIcons.arrowRightLong,
                color: AppColors.blue0F41D9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
