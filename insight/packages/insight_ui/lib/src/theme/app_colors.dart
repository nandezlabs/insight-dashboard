import 'package:flutter/material.dart';

/// Modern flat design color palette
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Accent colors
  static const Color accent = Color(0xFFFBBF24); // Yellow/Gold
  static const Color accentLight = Color(0xFFFCD34D);

  // Status colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Orange
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // Form status colors
  static const Color statusNotStarted = Color(0xFF9CA3AF); // Gray
  static const Color statusInProgress = Color(0xFF3B82F6); // Blue
  static const Color statusCompleted = Color(0xFF10B981); // Green
  static const Color statusAutoSubmitted = Color(0xFFF59E0B); // Orange

  // Neutral colors (flat design)
  static const Color background = Color(0xFFF9FAFB); // Very light gray
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFF3F4F6); // Light gray

  // Text colors
  static const Color textPrimary = Color(0xFF111827); // Dark gray
  static const Color textSecondary = Color(0xFF6B7280); // Medium gray
  static const Color textTertiary = Color(0xFF9CA3AF); // Light gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White

  // Border colors
  static const Color border = Color(0xFFE5E7EB); // Light gray
  static const Color borderFocus = primary;

  // Chart colors (for dashboard)
  static const List<Color> chartColors = [
    primary,
    accent,
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
    Color(0xFFF97316), // Orange
  ];
}
