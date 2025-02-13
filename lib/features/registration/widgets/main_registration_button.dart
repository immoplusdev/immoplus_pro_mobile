import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

class MainRegistrationButton extends StatelessWidget {
  const MainRegistrationButton(
      {super.key, required this.icon, required this.title, this.onTap});
  final IconData icon;
  final String title;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      shadowColor: Colors.grey.shade200,
      child: InkWell(
        splashColor: AppColors.primaryLite,
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          width: 190,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 80,
                color: Colors.blueGrey,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Icon(
                FontAwesomeIcons.circleArrowRight,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
