import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background & Surfaces
  static const Color background = Color(0xFF090D16);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceVariant = Color(0xFF1E293B);
  static const Color card = Color(0xFF161F36);
  static const Color cardElevated = Color(0xFF1C2744);
  static const Color cardBorder = Color(0xFF223052);
  static const Color divider = Color(0xFF1E293B);

  // Brand Accents
  static const Color primary = Color(0xFF10B981);       // Neon Fitness Emerald
  static const Color primaryGlow = Color(0x3310B981);
  static const Color accent = Color(0xFF06B6D4);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color blue = Color(0xFF3B82F6);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color orange = Color(0xFFF97316);

  // Fitness Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color correct = Color(0xFF10B981);       // Good rep / Form OK
  static const Color correctBg = Color(0x1A10B981);
  static const Color warning = Color(0xFFF59E0B);       // Warning / Caution
  static const Color warningBg = Color(0x1AF59E0B);
  static const Color error = Color(0xFFEF4444);         // Bad rep / Form Error
  static const Color errorBg = Color(0x1AEF4444);

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Inputs
  static const Color inputBg = Color(0xFF0F172A);
  static const Color inputBorder = Color(0xFF1E293B);

  static Color getAccuracyColor(dynamic accuracy) {
    final double val = accuracy is num ? accuracy.toDouble() : 0.0;
    final percentage = val <= 1.0 ? val * 100 : val;
    if (percentage >= 80) return correct;
    if (percentage >= 60) return warning;
    return error;
  }
}
