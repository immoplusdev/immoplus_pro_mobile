import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/svgs_icons.dart';

class AmenitiesGridSelectorV2 extends StatelessWidget {
  final bool Function(CommoditeModel) isSelected;
  final void Function(CommoditeModel) onToggle;

  const AmenitiesGridSelectorV2({
    super.key,
    required this.isSelected,
    required this.onToggle,
  });

  static const List<CommoditeModel> amenities = [
    CommoditeModel(icon: 'wifi', text: 'Wifi'),
    CommoditeModel(icon: 'tv', text: 'Télé'),
    CommoditeModel(icon: 'kitchen', text: 'Refrigerateur'),
    CommoditeModel(icon: 'kitchen-set-solid', text: 'Ustensiles'),
    CommoditeModel(icon: 'fan-solid', text: 'Ventilateur'),
    CommoditeModel(icon: 'dry_cleaning', text: 'Serviette'),
    CommoditeModel(icon: 'directions_car', text: 'Parking'),
    CommoditeModel(icon: 'microwave', text: 'Micro-ondes'),
    CommoditeModel(icon: 'local_laundry', text: 'Lave linge'),
    CommoditeModel(icon: 'wind', text: 'Climatiseur'),
    CommoditeModel(icon: 'oven', text: 'Cuisinière'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        childAspectRatio: 1.0,
      ),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        final commodite = amenities[index];
        final selected = isSelected(commodite);

        return InkWell(
          onTap: () => onToggle(commodite),
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFF0F4FA) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected ? AppColors.primary : Colors.grey.shade300,
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  height: 35,
                  SVGMap.map[commodite.icon] ?? SVGMap.map['wifi']!,
                  color: selected ? AppColors.primary : Colors.black87,
                ),
                const Gap(8),
                Text(
                  commodite.text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 11,
                    color: selected ? AppColors.primary : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
