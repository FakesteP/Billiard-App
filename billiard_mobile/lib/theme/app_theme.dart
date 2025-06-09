import 'package:flutter/material.dart';

class AppTheme {
  // Main colors
  static const Color primaryColor = Color(0xFF9B5CFF);
  static const Color backgroundColor = Color(0xFF181828);
  static const Color cardColor = Color(0xFF23233A);
  static const Color accentColor = Color(0xFF6C38FF);
  
  // Additional colors for better design
  static const Color surfaceColor = Color(0xFF2A2A3E);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE57373);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color borderColor = Color(0xFF3A3A4E);
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        cardColor: cardColor,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          secondary: accentColor,
          background: backgroundColor,
          surface: cardColor,
          error: errorColor,
          onPrimary: textPrimary,
          onSecondary: textPrimary,
          onBackground: textPrimary,
          onSurface: textPrimary,
          onError: textPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: textPrimary),
          titleTextStyle: const TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
          foregroundColor: textPrimary,
        ),
        cardTheme: CardTheme(
          color: cardColor,
          elevation: 8,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        ),
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: cardColor,
          textColor: textPrimary,
          iconColor: textSecondary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: errorColor, width: 1),
          ),
          hintStyle: TextStyle(color: textSecondary, fontSize: 14),
          labelStyle: TextStyle(color: textSecondary, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: textPrimary,
            elevation: 4,
            shadowColor: primaryColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minimumSize: const Size.fromHeight(52),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: accentColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.3,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: textPrimary,
            side: BorderSide(color: borderColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minimumSize: const Size.fromHeight(52),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: surfaceColor,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(color: textPrimary),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: surfaceColor,
          contentTextStyle: const TextStyle(color: textPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 8,
        ),
        dividerTheme: DividerThemeData(
          color: borderColor,
          thickness: 1,
          space: 1,
        ),
        iconTheme: const IconThemeData(
          color: textSecondary,
          size: 24,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.5,
          ),
          displayMedium: TextStyle(
            color: textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
          headlineLarge: TextStyle(
            color: textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
          headlineMedium: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
          ),
          titleLarge: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.15,
          ),
          titleMedium: TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
          ),
          titleSmall: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          bodyLarge: TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            color: textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.25,
          ),
          bodySmall: TextStyle(
            color: textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.4,
          ),
          labelLarge: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.25,
          ),
          labelMedium: TextStyle(
            color: textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
          labelSmall: TextStyle(
            color: textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
      );
}
