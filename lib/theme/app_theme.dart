import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary      = Color(0xFF059669);
  static const primaryDark  = Color(0xFF065F46);
  static const primaryLight = Color(0xFFD1FAE5);
  static const primaryMid   = Color(0xFF34D399);
  static const accent       = Color(0xFFF59E0B);
  static const accentLight  = Color(0xFFFEF3C7);
  static const accentDark   = Color(0xFFB45309);
  static const coral        = Color(0xFFF43F5E);
  static const coralLight   = Color(0xFFFEE2E2);
  static const coralDark    = Color(0xFFBE123C);
  static const blue         = Color(0xFF0284C7);
  static const blueLight    = Color(0xFFE0F2FE);
  static const purple       = Color(0xFF8B5CF6);
  static const purpleLight  = Color(0xFFEDE9FE);
  static const green        = Color(0xFF059669);
  static const greenLight   = Color(0xFFD1FAE5);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFFBFA),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: Colors.white,
      onSurface: Color(0xFF1C1917),
    ),
    cardColor: Colors.white,
    dividerColor: const Color(0xFFE7E5E4),
    fontFamily: 'Inter',
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1C1917),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: Color(0xFF292524),
      onSurface: Color(0xFFF5F5F4),
    ),
    cardColor: const Color(0xFF292524),
    dividerColor: const Color(0xFF44403C),
    fontFamily: 'Inter',
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

class ThemeTokens {
  final bool isDark;
  const ThemeTokens({required this.isDark});

  Color get bg        => isDark ? const Color(0xFF1C1917) : const Color(0xFFFFFBFA);
  Color get card      => isDark ? const Color(0xFF292524) : Colors.white;
  Color get text      => isDark ? const Color(0xFFF5F5F4) : const Color(0xFF1C1917);
  Color get heading   => isDark ? const Color(0xFFE7E5E4) : const Color(0xFF292524);
  Color get body      => isDark ? const Color(0xFFD6D3D1) : const Color(0xFF57534E);
  Color get secondary => isDark ? const Color(0xFFA8A29E) : const Color(0xFF78716C);
  Color get muted     => isDark ? const Color(0xFF78716C) : const Color(0xFFA8A29E);
  Color get border    => isDark ? const Color(0xFF44403C) : const Color(0xFFE7E5E4);
  Color get inputBg   => isDark ? const Color(0xFF292524) : const Color(0xFFFAFAF9);
  Color get gaugeBg     => isDark ? const Color(0xFF44403C) : const Color(0xFFE7E5E4);
  Color get searchBg    => isDark ? const Color(0xFF292524) : const Color(0xFFF5F5F4);
  Color get inputBorder => isDark ? const Color(0xFF57534E) : const Color(0xFFD6D3D1);
  Color get lightBg     => isDark ? const Color(0xFF292524) : const Color(0xFFF5F5F4);
}

Map<String, dynamic> scoreColor(int score) {
  if (score >= 750) return {'color': const Color(0xFF059669), 'labelColor': const Color(0xFF059669), 'bg': const Color(0xFFD1FAE5), 'label': 'Excellent'};
  if (score >= 650) return {'color': const Color(0xFF65A30D), 'labelColor': const Color(0xFF65A30D), 'bg': const Color(0xFFECFCCB), 'label': 'Good'};
  if (score >= 550) return {'color': const Color(0xFFF59E0B), 'labelColor': const Color(0xFFF59E0B), 'bg': const Color(0xFFFEF3C7), 'label': 'Fair'};
  if (score >= 400) return {'color': const Color(0xFFF97316), 'labelColor': const Color(0xFFF97316), 'bg': const Color(0xFFFFEDD5), 'label': 'Needs Work'};
  return {'color': const Color(0xFFDC2626), 'labelColor': const Color(0xFFDC2626), 'bg': const Color(0xFFFEE2E2), 'label': 'Building'};
}
