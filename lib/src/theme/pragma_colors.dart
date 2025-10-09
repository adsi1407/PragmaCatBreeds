import 'package:flutter/material.dart';

/// Pragma corporate color scheme
/// Colors based on Pragma's brand identity from https://www.pragma.co/
class PragmaColors {
  static const Color _primaryPragma = Color(0xFF6B46C1); // Pragma purple - corporate primary
  static const Color _secondaryPragma = Color(0xFF0066CC); // Blue accent from website
  static const Color _backgroundLight = Color(0xFFFAFAFA); // Light background
  static const Color _backgroundDark = Color(0xFF121212); // Dark background
  static const Color _surfaceLight = Color(0xFFFFFFFF); // Light surface
  static const Color _surfaceDark = Color(0xFF1E1E1E); // Dark surface
  
  // Additional colors found on the website
  static const Color accentBlue = Color(0xFF0066CC);
  static const Color accentGreen = Color(0xFF00A86B);
  static const Color warningOrange = Color(0xFFFF6B35);
  static const Color errorRed = Color(0xFFE53E3E);
  static const Color successGreen = Color(0xFF38A169);
  
  // Gray scale palette
  static const Color gray50 = Color(0xFFF7FAFC);
  static const Color gray100 = Color(0xFFEDF2F7);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E0);
  static const Color gray400 = Color(0xFFA0AEC0);
  static const Color gray500 = Color(0xFF718096);
  static const Color gray600 = Color(0xFF4A5568);
  static const Color gray700 = Color(0xFF2D3748);
  static const Color gray800 = Color(0xFF1A202C);
  static const Color gray900 = Color(0xFF171923);

  /// Light theme color scheme for Pragma
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _primaryPragma,
    onPrimary: Color(0xFFFFFFFF),
    secondary: _secondaryPragma,
    onSecondary: Color(0xFFFFFFFF),
    tertiary: accentGreen,
    onTertiary: Color(0xFFFFFFFF),
    error: errorRed,
    onError: Color(0xFFFFFFFF),
    surface: _surfaceLight,
    onSurface: _primaryPragma,
    background: _backgroundLight,
    onBackground: _primaryPragma,
    surfaceVariant: gray100,
    onSurfaceVariant: gray700,
    outline: gray300,
    outlineVariant: gray200,
    shadow: Color(0x1A000000),
    scrim: Color(0x80000000),
    inverseSurface: _surfaceDark,
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: accentBlue,
    surfaceTint: _primaryPragma,
  );

  /// Dark theme color scheme for Pragma
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: accentBlue,
    onPrimary: Color(0xFFFFFFFF),
    secondary: accentGreen,
    onSecondary: Color(0xFF000000),
    tertiary: warningOrange,
    onTertiary: Color(0xFF000000),
    error: errorRed,
    onError: Color(0xFFFFFFFF),
    surface: _surfaceDark,
    onSurface: Color(0xFFFFFFFF),
    background: _backgroundDark,
    onBackground: Color(0xFFFFFFFF),
    surfaceVariant: gray800,
    onSurfaceVariant: gray200,
    outline: gray600,
    outlineVariant: gray700,
    shadow: Color(0x1A000000),
    scrim: Color(0x80000000),
    inverseSurface: _surfaceLight,
    onInverseSurface: _primaryPragma,
    inversePrimary: _primaryPragma,
    surfaceTint: accentBlue,
  );
}
