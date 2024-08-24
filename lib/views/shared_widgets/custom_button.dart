import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/hex_color.dart';

class CustomButtom extends StatelessWidget {
  CustomButtom({
    Key? key,
    required this.text,
    this.onClick,
    this.clickable = true,
    this.color,
    this.textColor,
    this.fontSize,
    this.elevation,
    this.isLoading = false,
  }) : super(key: key);
  final String text;
  final void Function()? onClick;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final double? elevation;
  bool clickable;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        //padding: EdgeInsets.only(left: 30, right: 30),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: elevation ?? 0,
            backgroundColor: (clickable)
                ? (color == null)
                    ? HexColor.fromHex('#2172cb')
                    : color
                : Colors.grey[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: isLoading
              ? null
              : (clickable)
                  ? onClick
                  : null,
          child: isLoading
              ? CupertinoActivityIndicator()
              : Text(
                  text,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: textColor ?? Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
        ),
      ),
    );
  }
}
