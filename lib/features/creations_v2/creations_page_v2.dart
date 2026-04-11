import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/constantes/immo_icons.dart';

import '../create_estate_v2/create_estate_page_v2.dart';
import '../create_furniture_v2/create_furniture_page_v2.dart';
import '../create_residence_v2/create_lodgment_page_v2.dart';

class CreationsPageV2 extends StatelessWidget {
  const CreationsPageV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(40),
              const Text(
                "Ajouter un bien",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const Gap(15),
              const Text(
                "Nous sommes ravis de vous accueillir au sein de la communauté ImmoPlus, la plateforme où chaque espace trouve son voyageur. En rejoignant ImmoPlus, vous faites bien plus que simplement lister votre propriété ; vous ouvrez la porte à des expériences inoubliables et à des opportunités enrichissantes.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const Gap(40),
              _CreationButton(
                title: "Meubles",
                iconValue: FontAwesomeIcons.couch,
                onTap: () => context.pushNamed(CreateFurniturePageV2.name),
              ),
              const Gap(15),
              _CreationButton(
                title: "Résidence",
                iconValue: ImmoIcons.resi,
                onTap: () => context.pushNamed(CreateLodgmentPageV2.name),
              ),
              const Gap(15),
              _CreationButton(
                title: "Bien immobilier",
                iconValue: FontAwesomeIcons.building,
                onTap: () => context.pushNamed(CreateEstatePageV2.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreationButton extends StatefulWidget {
  final String title;
  final Object iconValue;
  final VoidCallback onTap;

  const _CreationButton({
    required this.title,
    required this.iconValue,
    required this.onTap,
  });

  @override
  State<_CreationButton> createState() => _CreationButtonState();
}

class _CreationButtonState extends State<_CreationButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = _isPressed ? AppColors.primary : Colors.white;
    final contentColor = _isPressed ? Colors.white : Colors.black87;
    final iconBgColor =
        _isPressed ? Colors.transparent : const Color(0xFFE8F0FE);
    final borderColor =
        _isPressed ? AppColors.primary : AppColors.primary.withOpacity(0.3);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: .5),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: widget.iconValue is ImmoIcons
                    ? ImmoIcon(
                        widget.iconValue as ImmoIcons,
                        color: _isPressed ? Colors.white : AppColors.primary,
                      )
                    : Icon(
                        widget.iconValue as IconData,
                        color: _isPressed ? Colors.white : AppColors.primary,
                        size: 20,
                      ),
              ),
            ),
            const Gap(15),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: _isPressed ? Colors.white : AppColors.primary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
