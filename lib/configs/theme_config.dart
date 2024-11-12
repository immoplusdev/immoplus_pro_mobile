import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/utils/hex_color.dart';

class ThemeConfig {
  static ThemeData lightTheme({required BuildContext context}) => ThemeData(
        textTheme: GoogleFonts.interTextTheme().apply(
            // decorationColor: Colors.red,
            // bodyColor: CupertinoColors.black,
            // displayColor: Colors.blue,
            ),
        useMaterial3: false,
        primaryColor: CupertinoColors.white,
        scaffoldBackgroundColor: CupertinoColors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: CupertinoColors.secondarySystemFill,
          labelStyle: TextStyle(color: CupertinoColors.black),

          prefixStyle: TextStyle(color: CupertinoColors.systemGrey),
          hintStyle: TextStyle(color: const Color.fromARGB(179, 92, 90, 90)),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white),
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),

          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.blue),
          // ),
        ),
        timePickerTheme: Theme.of(context).timePickerTheme.copyWith(
              backgroundColor: Colors.white,
            ),
        appBarTheme: const AppBarTheme(
            centerTitle: false,
            backgroundColor: CupertinoColors.white,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: CupertinoColors.black,
            ),
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            )),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor.fromHex('#2172cb'),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(HexColor.fromHex('#2172cb')),
        ),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: HexColor.fromHex('#2172cb'),
              secondaryContainer: CupertinoColors.white,
              onPrimary: CupertinoColors.white,
              background: HexColor.fromHex('#2172cb'),
              surface: CupertinoColors.systemGrey,
              secondary: Color.fromARGB(255, 229, 228, 228),
              onSecondary: CupertinoColors.white,
            ),
      );
//DARK THEME
  static ThemeData darkTheme({required BuildContext context}) =>
      ThemeData.dark().copyWith(
        primaryColor: CupertinoColors.systemFill,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: CupertinoColors.white,
          ),
        ).apply(
          decorationColor: Colors.red,
          bodyColor: CupertinoColors.white,
          displayColor: Colors.blue,
        ),
        scaffoldBackgroundColor: CupertinoColors.black,
        appBarTheme: const AppBarTheme(
            centerTitle: false,
            backgroundColor: CupertinoColors.black,
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: CupertinoColors.white),
            elevation: 0,
            iconTheme: IconThemeData(
              color: CupertinoColors.white,
            )),
        //scaffoldBackgroundColor: CupertinoColors.black,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: CupertinoColors.systemFill.darkColor,
          labelStyle: TextStyle(color: CupertinoColors.white),

          prefixStyle: TextStyle(color: CupertinoColors.systemGrey3),
          hintStyle: TextStyle(color: Colors.white70),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white),
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: CupertinoColors.darkBackgroundGray,
            //textStyle: Tex
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor:
              MaterialStateProperty.all(CupertinoColors.darkBackgroundGray),
        ),
        //primarySwatch: Colors.green,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: CupertinoColors.darkBackgroundGray,
              secondaryContainer: CupertinoColors.darkBackgroundGray,
              background: HexColor.fromHex('#2172cb'),
              surface: CupertinoColors.white,
              onPrimary: CupertinoColors.systemGrey5.darkColor,
              secondary: Colors.transparent,
              onSecondary: CupertinoColors.black,
              //: Colors.blue,
            ),
      );
}
