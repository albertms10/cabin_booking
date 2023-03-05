import 'package:flutter/material.dart';

final _baseThemeData = ThemeData(
  inputDecorationTheme: const InputDecorationTheme(
    errorMaxLines: 2,
    filled: true,
    border: OutlineInputBorder(),
  ),
  tooltipTheme: const TooltipThemeData(
    waitDuration: Duration(milliseconds: 200),
  ),
);

const borderRadiusLarge = BorderRadius.all(Radius.circular(12));
const borderRadiusTiny = BorderRadius.all(Radius.circular(2));

ThemeData lightTheme() {
  const primaryColor = Colors.blue;
  final primaryColorLight = primaryColor[300]!;
  final primaryColorDark = primaryColor[700]!;

  return ThemeData.light(useMaterial3: true).copyWith(
    primaryColor: primaryColor,
    primaryColorLight: primaryColorLight,
    primaryColorDark: primaryColorDark,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    inputDecorationTheme: _baseThemeData.inputDecorationTheme,
    tooltipTheme: _baseThemeData.tooltipTheme,
  );
}

ThemeData darkTheme() {
  const primaryColor = Colors.lightBlueAccent;
  final primaryColorLight = primaryColor[100]!;
  final primaryColorDark = primaryColor[700]!;

  return ThemeData.dark(useMaterial3: true).copyWith(
    primaryColor: primaryColor,
    primaryColorLight: primaryColorLight,
    primaryColorDark: primaryColorDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: _baseThemeData.inputDecorationTheme,
    tooltipTheme: _baseThemeData.tooltipTheme,
  );
}
