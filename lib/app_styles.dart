import 'package:flutter/material.dart';

const borderRadiusLarge = BorderRadius.all(Radius.circular(12));
const borderRadiusSmall = BorderRadius.all(Radius.circular(4));

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

ThemeData lightTheme() {
  const primaryColor = Colors.blue;

  return ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    inputDecorationTheme: _baseThemeData.inputDecorationTheme,
    tooltipTheme: _baseThemeData.tooltipTheme,
  );
}

ThemeData darkTheme() {
  const primaryColor = Colors.lightBlueAccent;

  return ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: _baseThemeData.inputDecorationTheme,
    tooltipTheme: _baseThemeData.tooltipTheme,
  );
}
