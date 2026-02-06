import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/utils/hex_color.dart';

class AppColors {
  // static Color primary = HexColor.fromHex('#2172cb');
  static Color primary = customBlue;

  static Color noSelected = CupertinoColors.systemGrey5;
  static Color primaryLite = const Color.fromARGB(32, 33, 149, 243);
  static Color scafold = HexColor.fromHex("#E6F3FF");
  static Color whiteBackground = const Color.fromARGB(255, 248, 253, 254);
  static Color scaffoldBackgroundColor = Color(0xff121224);
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color lightBlue = Color(0xff2072ca);
  static Color customBlue = Color(0xff2744de);
  static Color blue65BAF0 = Color(0xff65BAF0);
  static Color blue0F41D9 = Color(0xff0F41D9);
  static Color blue8ED3FF = Color(0xff8ED3FF);
  static Color blueE6F2F2 = Color(0xffE6F2F2);
  static Color E6F5FF = Color(0xffE6F5FF);
  static Color ECECEC = Color(0xffECECEC);
}
