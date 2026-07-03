import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color colonialCream = Color(0xFFF7E8C8);
  static const Color ivoryWall = Color(0xFFFFF4D7);
  static const Color limewash = Color(0xFFE8D1A7);
  static const Color warmStone = Color(0xFFD6A65F);
  static const Color carvedWood = Color(0xFF6F351D);
  static const Color deepWood = Color(0xFF1B0D08);
  static const Color smokedCedar = Color(0xFF2B130B);
  static const Color walnut = Color(0xFF3D1C0F);
  static const Color mahogany = Color(0xFF7F2E18);
  static const Color terracotta = Color(0xFFC85F2D);
  static const Color mutedTerracotta = Color(0xFFE18A52);
  static const Color antiqueGold = Color(0xFFD9A52D);
  static const Color softGold = Color(0xFFFFD36D);
  static const Color burnishedGold = Color(0xFF8D5E18);
  static const Color gardenGreen = Color(0xFF325B38);
  static const Color floralGreen = Color(0xFF74A05B);
  static const Color roseClay = Color(0xFFC45148);
  static const Color inkBrown = Color(0xFF24120B);
  static const Color mutedText = Color(0xFF8D7460);
  static const Color lightText = Color(0xFFFFF2D0);
  static const Color warmShadow = Color(0x80200B05);
  static const Color heavyShadow = Color(0xB8120704);
  static const Color lineGold = Color(0xFFE0B64F);
  static const Color errorColor = Color(0xFFB33F32);
  static const Color successColor = Color(0xFF4F8A4F);

  static const Color primaryWhite = colonialCream;
  static const Color accentBeige = warmStone;
  static const Color darkText = inkBrown;
  static const Color surfaceWhite = ivoryWall;
  static const Color cardColor = ivoryWall;
  static const Color dividerColor = Color(0xFFB98235);
  static const Color accentGold = antiqueGold;
  static const Color shadowColor = warmShadow;

  static const LinearGradient wallGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      deepWood,
      smokedCedar,
      walnut,
      mahogany,
    ],
    stops: [0, 0.38, 0.72, 1],
  );

  static const LinearGradient woodGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B421F),
      carvedWood,
      walnut,
      Color(0xFF9E4A23),
    ],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      softGold,
      antiqueGold,
      burnishedGold,
    ],
  );

  static const LinearGradient parchmentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      ivoryWall,
      colonialCream,
      limewash,
    ],
  );

  static TextTheme get _textTheme {
    final heading = GoogleFonts.cormorantGaramondTextTheme();
    final body = GoogleFonts.latoTextTheme();

    return TextTheme(
      displayLarge: heading.displayLarge?.copyWith(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        color: lightText,
        height: 1.02,
      ),
      displayMedium: heading.displayMedium?.copyWith(
        fontSize: 44,
        fontWeight: FontWeight.w800,
        color: lightText,
        height: 1.05,
      ),
      displaySmall: heading.displaySmall?.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: lightText,
      ),
      headlineLarge: heading.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: lightText,
      ),
      headlineMedium: heading.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: lightText,
      ),
      headlineSmall: heading.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: lightText,
      ),
      titleLarge: heading.titleLarge?.copyWith(
        fontSize: 23,
        fontWeight: FontWeight.w800,
        color: lightText,
      ),
      titleMedium: body.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: lightText,
      ),
      titleSmall: body.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: lightText,
      ),
      bodyLarge: body.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: lightText,
        height: 1.45,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colonialCream,
        height: 1.45,
      ),
      bodySmall: body.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colonialCream,
        height: 1.35,
      ),
      labelLarge: body.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: lightText,
      ),
      labelMedium: body.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: lightText,
      ),
      labelSmall: body.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: lightText,
      ),
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: antiqueGold,
      onPrimary: deepWood,
      primaryContainer: carvedWood,
      onPrimaryContainer: lightText,
      secondary: terracotta,
      onSecondary: lightText,
      secondaryContainer: softGold,
      onSecondaryContainer: deepWood,
      tertiary: floralGreen,
      onTertiary: deepWood,
      tertiaryContainer: gardenGreen,
      onTertiaryContainer: lightText,
      error: errorColor,
      onError: lightText,
      surface: ivoryWall,
      onSurface: inkBrown,
      outline: lineGold,
      shadow: heavyShadow,
    );

    final textTheme = _textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textTheme,
      fontFamily: GoogleFonts.lato().fontFamily,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      appBarTheme: AppBarTheme(
        backgroundColor: deepWood,
        foregroundColor: lightText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.cormorantGaramond(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          color: lightText,
        ),
        iconTheme: const IconThemeData(color: softGold),
      ),

      cardTheme: CardThemeData(
        color: ivoryWall,
        elevation: 8,
        shadowColor: heavyShadow,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: lineGold, width: 1.4),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return walnut.withValues(alpha: 0.55);
            }
            if (states.contains(WidgetState.pressed)) return mahogany;
            return carvedWood;
          }),
          foregroundColor: const WidgetStatePropertyAll(lightText),
          overlayColor: WidgetStatePropertyAll(softGold.withValues(alpha: 0.22)),
          elevation: const WidgetStatePropertyAll(8),
          shadowColor: const WidgetStatePropertyAll(heavyShadow),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(48, 52)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: lineGold, width: 1.4),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w900),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: softGold,
          backgroundColor: walnut,
          side: const BorderSide(color: lineGold, width: 1.4),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w900),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: softGold,
          textStyle: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w900),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ivoryWall,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: _inputBorder(lineGold, 1.4),
        enabledBorder: _inputBorder(lineGold, 1.4),
        focusedBorder: _inputBorder(softGold, 2),
        errorBorder: _inputBorder(errorColor, 1.5),
        focusedErrorBorder: _inputBorder(errorColor, 2),
        labelStyle: GoogleFonts.lato(
          color: carvedWood,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        hintStyle: GoogleFonts.lato(
          color: mutedText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: carvedWood,
        suffixIconColor: carvedWood,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: warmStone,
        selectedColor: antiqueGold,
        disabledColor: walnut.withValues(alpha: 0.55),
        side: const BorderSide(color: lineGold, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: textTheme.labelMedium?.copyWith(color: deepWood),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(color: deepWood),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      ),

      listTileTheme: ListTileThemeData(
        textColor: inkBrown,
        iconColor: mahogany,
        titleTextStyle: GoogleFonts.lato(
          color: inkBrown,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
        subtitleTextStyle: GoogleFonts.lato(
          color: carvedWood,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return antiqueGold;
          return ivoryWall;
        }),
        checkColor: const WidgetStatePropertyAll(deepWood),
        side: const BorderSide(color: lineGold, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return softGold;
          return limewash;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return carvedWood;
          return walnut;
        }),
        trackOutlineColor: const WidgetStatePropertyAll(lineGold),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: deepWood,
        selectedItemColor: softGold,
        unselectedItemColor: colonialCream.withValues(alpha: 0.72),
        type: BottomNavigationBarType.fixed,
        elevation: 14,
        selectedLabelStyle: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
        unselectedLabelStyle: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: deepWood,
        indicatorColor: antiqueGold,
        elevation: 14,
        shadowColor: heavyShadow,
        surfaceTintColor: Colors.transparent,
        height: 74,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.lato(
            color: selected ? softGold : colonialCream.withValues(alpha: 0.74),
            fontSize: 11,
            fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? deepWood
                : colonialCream.withValues(alpha: 0.78),
          );
        }),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: antiqueGold,
        foregroundColor: deepWood,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: softGold, width: 1.4),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: lineGold,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: softGold, size: 24),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: softGold,
        linearTrackColor: walnut,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ivoryWall,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.cormorantGaramond(
          color: inkBrown,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: GoogleFonts.lato(
          color: inkBrown,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: lineGold, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: deepWood,
        contentTextStyle: GoogleFonts.lato(
          color: lightText,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: lineGold),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
