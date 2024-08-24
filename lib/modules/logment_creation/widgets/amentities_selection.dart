import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/svgs_icons.dart';

class AmentitiesSelection extends StatefulWidget {
  const AmentitiesSelection({super.key, required this.onSlect});
  final void Function(List<Map>)? onSlect;
  @override
  State<AmentitiesSelection> createState() => _AmentitiesSelectionState();
}

class _AmentitiesSelectionState extends State<AmentitiesSelection> {
  List<Map<String, dynamic>> listEmentities = [
    {
      "icon": "wifi",
      "text": "Wifi",
      'selected': false,
    },
    {
      "icon": "tv",
      "text": "Télé",
      'selected': false,
    },
    {
      "icon": "kitchen",
      "text": "Ventilateur",
      'selected': false,
    },
    {
      "icon": "kitchen-set-solid",
      "text": "Ustensiles",
      'selected': false,
    },
    {
      "icon": "fan-solid",
      "text": "Ventilateur",
      'selected': false,
    },
    {
      "icon": "dry_cleaning",
      "text": "Serviette",
      'selected': false,
    },
    {
      "icon": "directions_car",
      "text": "Parking",
      'selected': false,
    },
    {
      "icon": "microwave",
      "text": "Micro-ondes",
      'selected': false,
    },
    {
      "icon": "local_laundry",
      "text": "Lave linge",
      'selected': false,
    },
    {
      "icon": "wind",
      "text": "Climatiseur",
      'selected': false,
    },
    {
      "icon": "oven",
      "text": "Cuisinière",
      'selected': false,
    },
  ];
  bool isSelected(int index) {
    return listEmentities[index]['selected'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisExtent: 125,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 4.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Card(
            color: isSelected(index) ? Colors.white : AppColors.noSelected,
            elevation: isSelected(index) ? 2 : 0,
            shape: RoundedRectangleBorder(
                side: isSelected(index)
                    ? BorderSide(color: AppColors.primary, width: 3)
                    : BorderSide.none,
                borderRadius: BorderRadius.circular(20)),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                setState(() {
                  listEmentities[index]['selected'] = !isSelected(index);
                });
                widget.onSlect!(listEmentities);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      height: 50,
                      SVGMap.map[listEmentities[index]['icon']] ??
                          SVGMap.map['wifi']!,
                      color:
                          isSelected(index) ? AppColors.primary : Colors.black,
                    ),
                    Text(
                      listEmentities[index]['text'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontWeight:
                              isSelected(index) ? FontWeight.w600 : null,
                          color: isSelected(index)
                              ? AppColors.primary
                              : Colors.grey.shade800),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        childCount: listEmentities.length,
      ),
    );
  }
}
