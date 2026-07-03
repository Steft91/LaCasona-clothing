import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'esquema_color.dart';

class TipografiaApp {
  static TextTheme get temaTexto {
    return TextTheme(
      displayLarge: GoogleFonts.cormorantGaramond(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: EsquemaColor.maderaProfunda,
        height: 1.05,
      ),
      headlineMedium: GoogleFonts.cormorantGaramond(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: EsquemaColor.maderaProfunda,
      ),
      titleLarge: GoogleFonts.cormorantGaramond(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: EsquemaColor.maderaProfunda,
      ),
      titleMedium: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: EsquemaColor.negroTinta,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: EsquemaColor.negroTinta,
        height: 1.45,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: EsquemaColor.grisTexto,
        height: 1.45,
      ),
      labelLarge: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: EsquemaColor.negroTinta,
      ),
    );
  }
}
