import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_theme.dart';
import 'esquema_color.dart';

class TemaFormulario {
  static InputDecorationTheme get inputDecoration {
    return InputDecorationTheme(
      filled: true,
      fillColor: EsquemaColor.blancoHueso,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: _border(AppTheme.lineGold, 1.4),
      enabledBorder: _border(AppTheme.lineGold, 1.4),
      focusedBorder: _border(AppTheme.softGold, 2),
      errorBorder: _border(AppTheme.errorColor, 1.5),
      focusedErrorBorder: _border(AppTheme.errorColor, 2),
      labelStyle: GoogleFonts.lato(
        color: AppTheme.carvedWood,
        fontWeight: FontWeight.w800,
      ),
      hintStyle: GoogleFonts.lato(
        color: AppTheme.mutedText,
        fontWeight: FontWeight.w600,
      ),
      prefixIconColor: AppTheme.mahogany,
      suffixIconColor: AppTheme.mahogany,
    );
  }

  static OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
