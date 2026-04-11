import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/features/create_residence_v2/logic/residence_creation_cubit_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/creation_navigation_buttons_v2.dart';
import 'package:immoplus_pro/svgs_icons.dart';

class Step2AmenitiesPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step2AmenitiesPage({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  static const List<Map<String, dynamic>> listEmentities = [
    {"icon": "wifi", "text": "Wifi"},
    {"icon": "tv", "text": "Télé"},
    {"icon": "kitchen", "text": "Refrigerateur"},
    {"icon": "kitchen-set-solid", "text": "Ustensiles"},
    {"icon": "fan-solid", "text": "Ventilateur"},
    {"icon": "dry_cleaning", "text": "Serviette"},
    {"icon": "directions_car", "text": "Parking"},
    {"icon": "microwave", "text": "Micro-ondes"},
    {"icon": "local_laundry", "text": "Lave linge"},
    {"icon": "wind", "text": "Climatiseur"},
    {"icon": "oven", "text": "Cuisinière"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Que proposez vous dans votre bien ?",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const Gap(15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 12.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: listEmentities.length,
                  itemBuilder: (context, index) {
                    final commoditeMap = listEmentities[index];
                    final commodite = CommoditeModel(
                      icon: commoditeMap['icon'],
                      text: commoditeMap['text'],
                    );

                    return BlocBuilder<ResidenceCreationCubitV2,
                        ResidenceCreationStateV2>(
                      buildWhen: (p, c) => p.commodites != c.commodites,
                      builder: (context, state) {
                        final isSelected = context
                            .read<ResidenceCreationCubitV2>()
                            .hasCommodite(commodite);

                        return InkWell(
                          onTap: () => context
                              .read<ResidenceCreationCubitV2>()
                              .toggleCommodite(commodite),
                          borderRadius: BorderRadius.circular(15),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFF0F4FA)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  height: 35,
                                  SVGMap.map[commodite.icon] ??
                                      SVGMap.map['wifi']!,
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.black87,
                                ),
                                const Gap(8),
                                Text(
                                  commodite.text,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    fontSize: 11,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
          builder: (context, state) {
            final isValid = state.commodites.isNotEmpty;
            return CreationNavigationButtonsV2(
              onPrevious: onPrevious,
              onNext: isValid ? onNext : null,
            );
          },
        ),
      ],
    );
  }
}
