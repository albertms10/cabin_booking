import 'package:flutter/material.dart';

final ThemeData _baseThemeData = ThemeData(
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
      onSecondary: Colors.white,
      secondaryContainer: primaryColorDark,
    ),
    radioTheme: RadioThemeData(
      fillColor: _resolveSelectedMaterialState(primaryColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: primaryColorDark),
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      selectedItemColor: primaryColorDark,
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
      onPrimary: Colors.white,
      primaryContainer: primaryColorLight,
      secondary: primaryColor,
      onSecondary: Colors.white,
      secondaryContainer: primaryColorDark,
    ),
    radioTheme: RadioThemeData(
      fillColor: _resolveSelectedMaterialState(primaryColor),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColorDark,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: primaryColorDark),
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      selectedItemColor: primaryColorDark,
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
