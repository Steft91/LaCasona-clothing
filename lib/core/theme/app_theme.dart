import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color espressoBlack = Color(0xFF101010);
  static const Color charcoal = Color(0xFF151515);
  static const Color softBlack = Color(0xFF1D1D1D);
  static const Color elevatedBlack = Color(0xFF25221F);
  static const Color cocoa = Color(0xFF3A2A22);
  static const Color caramel = Color(0xFFC9784A);
  static const Color caramelLight = Color(0xFFE49A65);
  static const Color cream = Color(0xFFF4E8D8);
  static const Color oat = Color(0xFFCDBEAF);
  static const Color taupe = Color(0xFF8F8178);
  static const Color hairline = Color(0xFF2F2A27);
  static const Color successColor = Color(0xFF78A66A);
  static const Color errorColor = Color(0xFFD8675A);
  static const Color warmShadow = Color(0x99000000);
  static const Color heavyShadow = Color(0xCC000000);

  // Backwards-compatible aliases used across the existing UI.
  static const Color colonialCream = cream;
  static const Color ivoryWall = softBlack;
  static const Color limewash = elevatedBlack;
  static const Color warmStone = caramel;
  static const Color carvedWood = caramel;
  static const Color deepWood = espressoBlack;
  static const Color smokedCedar = charcoal;
  static const Color walnut = softBlack;
  static const Color mahogany = caramel;
  static const Color terracotta = caramel;
  static const Color mutedTerracotta = caramelLight;
  static const Color antiqueGold = caramel;
  static const Color softGold = caramelLight;
  static const Color burnishedGold = cocoa;
  static const Color gardenGreen = successColor;
  static const Color floralGreen = successColor;
  static const Color roseClay = errorColor;
  static const Color inkBrown = cream;
  static const Color mutedText = taupe;
  static const Color lightText = cream;
  static const Color lineGold = hairline;

  static const Color primaryWhite = espressoBlack;
  static const Color accentBeige = caramel;
  static const Color darkText = cream;
  static const Color surfaceWhite = softBlack;
  static const Color cardColor = softBlack;
  static const Color dividerColor = hairline;
  static const Color accentGold = caramel;
  static const Color shadowColor = warmShadow;

  static const LinearGradient wallGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [espressoBlack, charcoal, espressoBlack],
  );

  static const LinearGradient woodGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [softBlack, elevatedBlack],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [caramel, caramelLight],
  );

  static const LinearGradient parchmentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [softBlack, elevatedBlack],
  );

  static TextTheme get _textTheme {
    final heading = GoogleFonts.playfairDisplayTextTheme();
    final body = GoogleFonts.latoTextTheme();

    return TextTheme(
      displayLarge: heading.displayLarge?.copyWith(
        fontSize: 52,
        fontWeight: FontWeight.w800,
        color: cream,
        height: 1.02,
      ),
      displayMedium: heading.displayMedium?.copyWith(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        color: cream,
        height: 1.05,
      ),
      displaySmall: heading.displaySmall?.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: cream,
      ),
      headlineLarge: heading.headlineLarge?.copyWith(
        fontSize: 31,
        fontWeight: FontWeight.w800,
        color: cream,
      ),
      headlineMedium: heading.headlineMedium?.copyWith(
        fontSize: 27,
        fontWeight: FontWeight.w800,
        color: cream,
      ),
      headlineSmall: heading.headlineSmall?.copyWith(
        fontSize: 23,
        fontWeight: FontWeight.w800,
        color: cream,
      ),
      titleLarge: heading.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: cream,
      ),
      titleMedium: body.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: cream,
      ),
      titleSmall: body.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: cream,
      ),
      bodyLarge: body.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: cream,
        height: 1.42,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: oat,
        height: 1.42,
      ),
      bodySmall: body.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: taupe,
        height: 1.35,
      ),
      labelLarge: body.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: cream,
      ),
      labelMedium: body.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: cream,
      ),
      labelSmall: body.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: taupe,
      ),
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: caramel,
      onPrimary: espressoBlack,
      primaryContainer: cocoa,
      onPrimaryContainer: cream,
      secondary: caramelLight,
      onSecondary: espressoBlack,
      secondaryContainer: elevatedBlack,
      onSecondaryContainer: cream,
      tertiary: successColor,
      onTertiary: espressoBlack,
      tertiaryContainer: elevatedBlack,
      onTertiaryContainer: cream,
      error: errorColor,
      onError: cream,
      surface: softBlack,
      onSurface: cream,
      outline: hairline,
      shadow: heavyShadow,
    );

    final textTheme = _textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textTheme,
      fontFamily: GoogleFonts.lato().fontFamily,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashColor: caramel.withValues(alpha: 0.12),
      highlightColor: caramel.withValues(alpha: 0.08),

      appBarTheme: AppBarTheme(
        backgroundColor: espressoBlack,
        foregroundColor: cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          color: cream,
        ),
        iconTheme: const IconThemeData(color: cream),
      ),

      cardTheme: CardThemeData(
        color: softBlack,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: hairline),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: caramel,
          foregroundColor: espressoBlack,
          disabledBackgroundColor: elevatedBlack,
          disabledForegroundColor: taupe,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cream,
          backgroundColor: softBlack,
          side: const BorderSide(color: hairline),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: caramelLight,
          textStyle: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: softBlack,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: _inputBorder(hairline, 1),
        enabledBorder: _inputBorder(hairline, 1),
        focusedBorder: _inputBorder(caramel, 1.5),
        errorBorder: _inputBorder(errorColor, 1.2),
        focusedErrorBorder: _inputBorder(errorColor, 1.5),
        labelStyle: GoogleFonts.lato(
          color: oat,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        hintStyle: GoogleFonts.lato(
          color: taupe,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        prefixIconColor: caramelLight,
        suffixIconColor: caramelLight,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: softBlack,
        selectedColor: caramel,
        disabledColor: elevatedBlack,
        side: const BorderSide(color: hairline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        labelStyle: textTheme.labelMedium?.copyWith(color: oat),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: espressoBlack,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      ),

      listTileTheme: ListTileThemeData(
        textColor: cream,
        iconColor: caramelLight,
        titleTextStyle: GoogleFonts.lato(
          color: cream,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        subtitleTextStyle: GoogleFonts.lato(
          color: taupe,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return caramel;
          return softBlack;
        }),
        checkColor: const WidgetStatePropertyAll(espressoBlack),
        side: const BorderSide(color: hairline, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return caramel;
          return oat;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return caramel.withValues(alpha: 0.34);
          }
          return elevatedBlack;
        }),
        trackOutlineColor: const WidgetStatePropertyAll(hairline),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: espressoBlack,
        indicatorColor: caramel.withValues(alpha: 0.18),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        height: 74,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.lato(
            color: selected ? caramelLight : taupe,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected) ? caramelLight : taupe,
          );
        }),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: espressoBlack,
        selectedItemColor: caramelLight,
        unselectedItemColor: taupe,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelStyle: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: caramel,
        foregroundColor: espressoBlack,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      dividerTheme: const DividerThemeData(
        color: hairline,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: caramelLight, size: 24),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: caramel,
        linearTrackColor: elevatedBlack,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: softBlack,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: cream,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: GoogleFonts.lato(
          color: oat,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: hairline),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: elevatedBlack,
        contentTextStyle: GoogleFonts.lato(
          color: cream,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
