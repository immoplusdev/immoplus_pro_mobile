import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_residence/utils/enum_utils.dart';

class SelectableCard<T> extends StatefulWidget {
  SelectableCard(
      {super.key,
      required this.onSelected,
      required this.onUnSelected,
      required this.selectionData,
      this.isSelected = false,
      this.state,
      this.multi = false});
  final void Function() onSelected;
  final void Function() onUnSelected;
  final state;
  final SelectionCardData selectionData;
  final bool multi;
  bool isSelected;
  @override
  State<SelectableCard> createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        iconTheme: IconThemeData(
            size: 40,
            color: (widget.selectionData.state == widget.state)
                ? AppColors.primary
                : Colors.grey),
      ),
      child: Card(
        color: (widget.selectionData.state == widget.state)
            ? Colors.white
            : AppColors.noSelected,
        elevation: (widget.selectionData.state == widget.state) ? 2 : 0,
        shape: RoundedRectangleBorder(
            side: (widget.selectionData.state == widget.state)
                ? BorderSide(color: AppColors.primary, width: 3)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            setState(() {
              widget.isSelected = !widget.isSelected;
              if ((widget.selectionData.state == widget.state)) {
                widget.onSelected();
              } else {
                widget.onUnSelected();
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.selectionData.icon,
                Text(
                  widget.selectionData.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontWeight: (widget.selectionData.state == widget.state)
                          ? FontWeight.w600
                          : null,
                      color: (widget.selectionData.state == widget.state)
                          ? AppColors.primary
                          : Colors.grey.shade600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
