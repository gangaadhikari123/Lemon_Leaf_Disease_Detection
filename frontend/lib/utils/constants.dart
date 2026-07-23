import 'package:flutter/material.dart';

class AppColors {
  // Primary greens
  static const Color primary      = Color(0xFF2E7D32);
  static const Color primaryDark  = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color accent       = Color(0xFF8BC34A);

  // Background
  static const Color background   = Color(0xFFF1F8E9);
  static const Color cardBg       = Color(0xFFFFFFFF);
  static const Color surface      = Color(0xFFE8F5E9);

  // Severity
  static const Color high         = Color(0xFFD32F2F);
  static const Color medium       = Color(0xFFF57C00);
  static const Color healthy      = Color(0xFF2E7D32);

  // Text
  static const Color textDark     = Color(0xFF1A2E1A);
  static const Color textMedium   = Color(0xFF4A6741);
  static const Color textLight    = Color(0xFF78909C);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark);
  static const TextStyle heading2 = TextStyle(
    fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark);
  static const TextStyle heading3 = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark);
  static const TextStyle body = TextStyle(
    fontSize: 14, color: AppColors.textMedium, height: 1.5);
  static const TextStyle caption = TextStyle(
    fontSize: 12, color: AppColors.textLight);
}

class AppRadius {
  static const double card   = 20.0;
  static const double button = 14.0;
  static const double badge  = 99.0;
  static const double image  = 16.0;
}

class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withOpacity(0.07),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];
  static List<BoxShadow> button = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.35),
      blurRadius: 12,
      offset: const Offset(0, 5),
    ),
  ];
}