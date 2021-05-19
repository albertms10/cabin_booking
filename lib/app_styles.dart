import 'package:flutter/material.dart';

class AppStyles {
  static ThemeData _baseThemeData() {
    return ThemeData(
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        errorMaxLines: 2,
        border: OutlineInputBorder(),
      ),
    );
  }

  static ThemeData lightTheme() {
    final primaryColor = Colors.blue;
    final primaryColorLight = primaryColor[300]!;
    final primaryColorDark = primaryColor[700]!;

    return ThemeData.light().copyWith(
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      primaryColorDark: primaryColorDark,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        primaryVariant: primaryColorLight,
        secondary: primaryColor,
        secondaryVariant: primaryColorDark,
      ),
      inputDecorationTheme: _baseThemeData().inputDecorationTheme,
      radioTheme: RadioThemeData(
        fillColor: _resolveSelectedMaterialState(primaryColor),
      ),
    );
  }

  static ThemeData darkTheme() {
    final primaryColor = Colors.lightBlueAccent;
    final primaryColorLight = primaryColor[100]!;
    final primaryColorDark = primaryColor[700]!;

    return ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      primaryColorDark: primaryColorDark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        primaryVariant: primaryColorLight,
        secondary: primaryColor,
        secondaryVariant: primaryColorDark,
      ),
      inputDecorationTheme: _baseThemeData().inputDecorationTheme,
      radioTheme: RadioThemeData(
        fillColor: _resolveSelectedMaterialState(primaryColor),
      ),
    );
  }

  static MaterialStateProperty<Color?> _resolveSelectedMaterialState(
    Color color,
  ) {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return color;
      }

      return null;
    });
  }
}
