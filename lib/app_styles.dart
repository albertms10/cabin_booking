import 'package:flutter/material.dart';

final ThemeData _baseThemeData = ThemeData(
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    errorMaxLines: 2,
    border: OutlineInputBorder(),
  ),
  tooltipTheme: const TooltipThemeData(
    waitDuration: Duration(milliseconds: 200),
  ),
);

ThemeData lightTheme() {
  const primaryColor = Colors.blue;
  final primaryColorLight = primaryColor[300]!;
  final primaryColorDark = primaryColor[700]!;

  return ThemeData.light(useMaterial3: true).copyWith(
    primaryColor: primaryColor,
    primaryColorLight: primaryColorLight,
    primaryColorDark: primaryColorDark,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryColorLight,
      secondary: primaryColor,
      secondaryContainer: primaryColorDark,
      onSecondary: Colors.white,
    ),
    radioTheme: RadioThemeData(
      fillColor: _resolveSelectedMaterialState(primaryColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: primaryColorDark),
      selectedItemColor: primaryColorDark,
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      unselectedItemColor: Colors.grey,
    ),
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
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      primaryContainer: primaryColorLight,
      secondary: primaryColor,
      secondaryContainer: primaryColorDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    radioTheme: RadioThemeData(
      fillColor: _resolveSelectedMaterialState(primaryColor),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColorDark,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: primaryColorDark),
      selectedItemColor: primaryColorDark,
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      unselectedItemColor: Colors.grey,
    ),
    inputDecorationTheme: _baseThemeData.inputDecorationTheme,
    tooltipTheme: _baseThemeData.tooltipTheme,
  );
}

MaterialStateProperty<Color?> _resolveSelectedMaterialState(
  Color color,
) {
  return MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.selected)) return color;

    return null;
  });
}
