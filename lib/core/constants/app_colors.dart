import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand accents (shared across both modes)
  static const electricBlue = Color(0xFF4F8EFF);
  static const gold = Color(0xFFFFD700);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const danger = Color(0xFFEF5350);

  // Dark mode
  static const darkBackground = Color(0xFF0D0D0D);
  static const darkSurface = Color(0xFF1A1A1A);
  static const darkSurfaceVariant = Color(0xFF242424);
  static const darkBorder = Color(0xFF2C2C2C);
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFFA0A0A0);

  // Light mode
  static const lightBackground = Color(0xFFF5F5F5);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF0F0F0);
  static const lightBorder = Color(0xFFE0E0E0);
  static const lightTextPrimary = Color(0xFF1A1A1A);
  static const lightTextSecondary = Color(0xFF6B6B6B);

  // Account card gradients
  static const savingsGradient = [Color(0xFF1A237E), Color(0xFF3949AB)];
  static const creditGradient = [Color(0xFF1A1A2E), Color(0xFF16213E)];
  static const cashGradient = [Color(0xFF1B5E20), Color(0xFF388E3C)];
  static const loanGradient = [Color(0xFF4A148C), Color(0xFF7B1FA2)];

  // Category palette
  static const categoryColors = [
    Color(0xFF4F8EFF),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFFEF5350),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFF5722),
    Color(0xFF607D8B),
    Color(0xFFFFD700),
    Color(0xFF795548),
  ];
}
