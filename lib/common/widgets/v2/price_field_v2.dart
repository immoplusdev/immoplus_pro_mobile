import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

class PriceFieldV2 extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String suffix;
  final String? hintText;
  final TextAlign textAlign;

  const PriceFieldV2({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    this.suffix = "fcfa",
    this.hintText,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.primary, fontSize: 13),
        ),
        const Gap(10),
        SizedBox(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            textAlign: textAlign,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              hintText: hintText,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      suffix,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              suffixIconConstraints: const BoxConstraints(
                minHeight: 0,
                minWidth: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
