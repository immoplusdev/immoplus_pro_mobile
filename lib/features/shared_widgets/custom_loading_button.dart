import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';

class CustomLoadingButtom extends StatelessWidget {
  const CustomLoadingButtom({
    super.key,
    required this.text,
    this.onClick,
    this.clickable = true,
    this.color,
    this.textColor,
    required this.isLoading,
  });
  final String text;
  final void Function()? onClick;
  final Color? color;
  final Color? textColor;
  final bool isLoading;

  final bool clickable;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        //padding: EdgeInsets.only(left: 30, right: 30),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            disabledBackgroundColor: Colors.blue.shade100,
            backgroundColor: (clickable)
                ? (color == null)
                    ? AppColors.primary
                    : color
                : Colors.grey[400],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radiusButton)),
          ),
          onPressed: (isLoading || !clickable) ? null : onClick,
          child: (isLoading)
              ? CupertinoActivityIndicator(
                  radius: 16,
                )
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
