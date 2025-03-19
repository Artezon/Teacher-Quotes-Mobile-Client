import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppStyles {
  static final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.light,
  );

  static ThemeData theme = ThemeData(
    fontFamily: 'Inter',
    colorScheme: colorScheme,
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.inversePrimary,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: colorScheme.surface,
      )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
  );

  static const sectionTitle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Colors.black87,
  );

  static const linkText = TextStyle(
    color: Colors.blue,
    fontSize: 14,
  );

  static const regularText = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  static const cardPadding = EdgeInsets.symmetric(vertical: 12);
  static const horizontalPadding = EdgeInsets.symmetric(horizontal: 16);
}