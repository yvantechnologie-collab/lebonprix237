import 'package:flutter/material.dart';

/// Couleurs officielles de la charte graphique Lebonprix 237
class AppColors {
  static const Color rouge = Color(0xFFE30613);
  static const Color noir = Color(0xFF111111);
  static const Color blanc = Color(0xFFFFFFFF);
  static const Color grisFond = Color(0xFFF5F5F7);
  static const Color vertSucces = Color(0xFF2E7D32);
  static const Color orangeAlerte = Color(0xFFF9A825);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.grisFond,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.rouge,
        primary: AppColors.rouge,
        onPrimary: AppColors.blanc,
        secondary: AppColors.noir,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.noir,
        foregroundColor: AppColors.blanc,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rouge,
          foregroundColor: AppColors.blanc,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.rouge,
        foregroundColor: AppColors.blanc,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.blanc,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold, color: AppColors.noir),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, color: AppColors.noir),
      ),
    );
  }
}
