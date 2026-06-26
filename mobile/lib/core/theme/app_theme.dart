import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

// Theme controller to persist selections
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'user_theme_mode';

  ThemeNotifier(this._prefs) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final stored = _prefs.getString(_themeKey);
    if (stored == 'light') {
      state = ThemeMode.light;
    } else if (stored == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_themeKey, mode.toString().split('.').last);
  }
}

// Theme Provider
final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});

class AppTheme {
  // Brand colors matching index.css (Light)
  static const Color primaryColor = Color(0xFF005E9A);
  static const Color primaryContainerColor = Color(0xFF0077C2);
  static const Color secondaryColor = Color(0xFF00658E);
  static const Color secondaryContainerColor = Color(0xFF6CC8FE);
  static const Color tertiaryColor = Color(0xFF006378);
  static const Color errorColor = Color(0xFFBA1A1A);
  static const Color backgroundColor = Color(0xFFF6F9FF);
  static const Color surfaceColor = Color(0xFFF6F9FF);
  static const Color surfaceContainerLowestColor = Color(0xFFFFFFFF);
  static const Color surfaceContainerColor = Color(0xFFE8EEF7);
  static const Color onSurfaceColor = Color(0xFF151C22);
  static const Color onSurfaceVariantColor = Color(0xFF404751);
  static const Color outlineColor = Color(0xFF707882);
  static const Color outlineVariantColor = Color(0xFFC0C7D3);

  // Dark Mode colors
  static const Color darkPrimaryColor = Color(0xFF9CCAFF);
  static const Color darkPrimaryContainerColor = Color(0xFF00497B);
  static const Color darkSecondaryColor = Color(0xFF83CFFF);
  static const Color darkSecondaryContainerColor = Color(0xFF004C6C);
  static const Color darkTertiaryColor = Color(0xFF4CD6FB);
  static const Color darkBackgroundColor = Color(0xFF121316);
  static const Color darkSurfaceColor = Color(0xFF121316);
  static const Color darkSurfaceContainerLowestColor = Color(0xFF1A1C1E);
  static const Color darkSurfaceContainerColor = Color(0xFF222428);
  static const Color darkOnSurfaceColor = Color(0xFFE2E2E6);
  static const Color darkOnSurfaceVariantColor = Color(0xFFC5C6D0);
  static const Color darkOutlineColor = Color(0xFF8F909A);
  static const Color darkOutlineVariantColor = Color(0xFF44474F);

  // 1. Material 3 Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: primaryContainerColor,
        onPrimaryContainer: Color(0xFFF9FAFF),
        secondary: secondaryColor,
        onSecondary: Colors.white,
        secondaryContainer: secondaryContainerColor,
        onSecondaryContainer: Color(0xFF005274),
        tertiary: tertiaryColor,
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFF007E98),
        onTertiaryContainer: Color(0xFFF4FCFF),
        error: errorColor,
        onError: Colors.white,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF93000A),
        background: backgroundColor,
        onBackground: onSurfaceColor,
        surface: surfaceColor, 
        onSurface: onSurfaceColor,
        surfaceVariant: Color(0xFFDCE3EC),
        onSurfaceVariant: onSurfaceVariantColor,
        outline: outlineColor,
        outlineVariant: outlineVariantColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: _buildTextTheme(onSurfaceColor, onSurfaceVariantColor),
      cardTheme: CardThemeData(
        color: surfaceContainerLowestColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(color: Color(0xFFE8EEF7), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceContainerLowestColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: onSurfaceColor),
      ),
      inputDecorationTheme: _buildInputDecorationTheme(outlineVariantColor, primaryColor, errorColor, outlineColor),
    );
  }

  // 2. Material 3 Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: darkPrimaryColor,
        onPrimary: Color(0xFF003254),
        primaryContainer: darkPrimaryContainerColor,
        onPrimaryContainer: Color(0xFFD0E4FF),
        secondary: darkSecondaryColor,
        onSecondary: Color(0xFF00344D),
        secondaryContainer: darkSecondaryContainerColor,
        onSecondaryContainer: Color(0xFFC7E7FF),
        tertiary: darkTertiaryColor,
        onTertiary: Color(0xFF003543),
        tertiaryContainer: Color(0xFF004E5F),
        onTertiaryContainer: Color(0xFFB3EBFF),
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        background: darkBackgroundColor,
        onBackground: darkOnSurfaceColor,
        surface: darkSurfaceColor,
        onSurface: darkOnSurfaceColor,
        surfaceVariant: Color(0xFF44474F),
        onSurfaceVariant: darkOnSurfaceVariantColor,
        outline: darkOutlineColor,
        outlineVariant: darkOutlineVariantColor,
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      textTheme: _buildTextTheme(darkOnSurfaceColor, darkOnSurfaceVariantColor),
      cardTheme: CardThemeData(
        color: darkSurfaceContainerLowestColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(color: Color(0xFF44474F), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurfaceContainerLowestColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: darkOnSurfaceColor),
      ),
      inputDecorationTheme: _buildInputDecorationTheme(darkOutlineVariantColor, darkPrimaryColor, Color(0xFFFFB4AB), darkOutlineColor),
    );
  }

  // Helper text builders
  static TextTheme _buildTextTheme(Color mainColor, Color variantColor) {
    return TextTheme(
      displayLarge: GoogleFonts.manrope(fontSize: 48, fontWeight: FontWeight.bold, height: 1.16, color: mainColor),
      headlineLarge: GoogleFonts.manrope(fontSize: 32, fontWeight: FontWeight.w600, height: 1.25, color: mainColor),
      headlineMedium: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w600, height: 1.33, color: mainColor),
      headlineSmall: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, color: mainColor),
      bodyLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.normal, height: 1.55, color: mainColor),
      bodyMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, height: 1.5, color: mainColor),
      bodySmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, height: 1.43, color: variantColor),
      labelLarge: GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.05, color: mainColor),
      labelMedium: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.05, color: variantColor),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
      Color borderClr, Color focusClr, Color errorClr, Color placeholderClr) {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: borderClr)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: borderClr)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: focusClr, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: errorClr)),
      hintStyle: GoogleFonts.inter(color: placeholderClr, fontSize: 16),
    );
  }

  // 3. Cupertino Light Theme Configuration
  static CupertinoThemeData get cupertinoLightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      primaryContrastingColor: Colors.white,
      scaffoldBackgroundColor: Color(0xFFF2F2F7), // iOS native light background
      barBackgroundColor: Colors.white,
      textTheme: CupertinoTextThemeData(
        primaryColor: primaryColor,
        textStyle: TextStyle(color: onSurfaceColor, fontFamily: 'Inter'),
      ),
    );
  }

  // 4. Cupertino Dark Theme Configuration
  static CupertinoThemeData get cupertinoDarkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      primaryContrastingColor: Colors.black,
      scaffoldBackgroundColor: Color(0xFF1C1C1E), // iOS native dark background
      barBackgroundColor: Color(0xFF1A1C1E),
      textTheme: CupertinoTextThemeData(
        primaryColor: darkPrimaryColor,
        textStyle: TextStyle(color: darkOnSurfaceColor, fontFamily: 'Inter'),
      ),
    );
  }
}
