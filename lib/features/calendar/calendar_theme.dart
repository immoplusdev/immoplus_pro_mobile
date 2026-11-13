import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Palette ──────────────────────────────────────────────────────────────────

const calBackgroundColor  = AppColors.white;
const calPrimaryColor     = AppColors.blue500;
const calPrimarySoftColor = Color(0xFFEEF1FD);
const calInkColor         = AppColors.slate900;
const calMutedColor       = Color(0xFF94A3B8);
const calLineColor        = Color(0xFFE2E8F0);
const calDangerColor      = Color(0xFFEF4444);
const calDangerSoftColor  = Color(0xFFFEF2F2);
const calWarningSoftColor = Color(0xFFFFFBEB);
const calWarningColor     = Color(0xFFF59E0B);

// ── Labels ───────────────────────────────────────────────────────────────────

const calMonthNames = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'decembre',
];

const calDayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

// ── Typography ───────────────────────────────────────────────────────────────

TextStyle calDmSans({
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
}) {
  return GoogleFonts.dmSans(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: 0,
  );
}
