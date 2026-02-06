import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';

class CustomButtom extends StatelessWidget {
  CustomButtom(
      {Key? key,
      this.text,
      this.onClick,
      this.clickable = true,
      this.color,
      this.textColor,
      this.fontSize,
      this.elevation,
      this.isLoading = false,
      this.child,
      this.borderRadius})
      : super(key: key);
  final String? text;
  final Widget? child;

  final void Function()? onClick;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final double? elevation;
  bool clickable;
  final bool isLoading;
  BorderRadius? borderRadius;
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
                    ? AppColors.primary
                    : color
                : Colors.grey[400],
            shape: RoundedRectangleBorder(
                borderRadius:
                    borderRadius ?? BorderRadius.circular(radiusButton)),
          ),
          onPressed: isLoading
              ? null
              : (clickable)
                  ? onClick
                  : null,
          child: isLoading
              ? CupertinoActivityIndicator()
              : child ??
                  Text(
                    text ?? '',
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
