import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'esquema_color.dart';

class TemaAppBar {
  static AppBarTheme get lightAppBar {
    return AppBarTheme(
      backgroundColor: EsquemaColor.cremaColonial,
      foregroundColor: EsquemaColor.maderaProfunda,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.cormorantGaramond(
        color: EsquemaColor.maderaProfunda,
        fontSize: 23,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: EsquemaColor.maderaTallada),
    );
  }

  static AppBarTheme get darkAppBar {
    return AppBarTheme(
      backgroundColor: EsquemaColor.maderaProfunda,
      foregroundColor: EsquemaColor.blancoHueso,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.cormorantGaramond(
        color: EsquemaColor.blancoHueso,
        fontSize: 23,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: EsquemaColor.blancoHueso),
    );
  }

  static AppBarTheme get clearAppBar {
    return lightAppBar;
  }
}
