import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/svgs_icons.dart';

class LogmentTypeSelection extends StatefulWidget {
  const LogmentTypeSelection({super.key, required this.onSlect});
  final void Function(Map)? onSlect;
  @override
  State<LogmentTypeSelection> createState() => _LogmentTypeSelectionState();
}

class _LogmentTypeSelectionState extends State<LogmentTypeSelection> {
  List<Map> selectabeChoice = [
    {
      'icon': 'building-user-solid',
      'text': 'Appartement',
    },
    {
      'icon': 'cottage',
      'text': 'Maison',
    },
    {
      'icon': 'villa',
      'text': 'Villa',
    },
  ];
  Map selectedChoice = {
    'icon': '',
    'text': '',
  };
  isSelected(int index) {
    return selectedChoice['icon'] == selectabeChoice[index]['icon'];
  }

  @override
  void initState() {
    if (ResidenceCreationModelBuilder().typeResidence.isNotEmpty) {
      selectedChoice = selectabeChoice.firstWhere(
        (element) =>
            (element['text'] as String).toLowerCase() ==
            ResidenceCreationModelBuilder().typeResidence.toLowerCase(),
      );
    }

    super.initState();
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
                  selectedChoice = selectabeChoice[index];
                });
                widget.onSlect!(selectedChoice);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      height: 50,
                      SVGMap.map[selectabeChoice[index]['icon']] ?? '',
                      color:
                          isSelected(index) ? AppColors.primary : Colors.black,
                    ),
                    Text(
                      selectabeChoice[index]['text'],
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
        childCount: selectabeChoice.length,
      ),
    );
  }
}
