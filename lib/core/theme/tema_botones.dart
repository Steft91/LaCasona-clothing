import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_theme.dart';
import 'esquema_color.dart';

class TemaBotones {
  static ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(
          AppTheme.lightText,
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppTheme.walnut.withValues(alpha: 0.55);
          }
          if (states.contains(WidgetState.pressed)) {
            return EsquemaColor.maderaProfunda;
          }
          return EsquemaColor.maderaTallada;
        }),
        elevation: const WidgetStatePropertyAll(10),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        ),
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w900),
        ),
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppTheme.lineGold, width: 1.4),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        shadowColor: const WidgetStatePropertyAll(AppTheme.heavyShadow),
      ),
    );
  }

  static OutlinedButtonThemeData get outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.softGold,
        backgroundColor: AppTheme.walnut,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        side: const BorderSide(color: AppTheme.lineGold, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.lato(fontWeight: FontWeight.w900),
      ),
    );
  }

  static TextButtonThemeData get textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.softGold,
        textStyle: GoogleFonts.lato(fontWeight: FontWeight.w900),
      ),
    );
  }
}
