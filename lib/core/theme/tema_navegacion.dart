import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'esquema_color.dart';

class TemaNavegacion {
  static BottomNavigationBarThemeData get bottomNavigationTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: EsquemaColor.blancoHueso,
      selectedItemColor: EsquemaColor.maderaTallada,
      unselectedItemColor: EsquemaColor.textoSuave,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      selectedLabelStyle: GoogleFonts.lato(
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
      unselectedLabelStyle: GoogleFonts.lato(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static NavigationBarThemeData get navigationBarTheme {
    return NavigationBarThemeData(
      backgroundColor: EsquemaColor.blancoHueso,
      indicatorColor: EsquemaColor.doradoSuave.withValues(alpha: 0.45),
      elevation: 8,
      height: 72,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return GoogleFonts.lato(
          color:
              selected ? EsquemaColor.maderaProfunda : EsquemaColor.textoSuave,
          fontSize: 11,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          color: states.contains(WidgetState.selected)
              ? EsquemaColor.maderaTallada
              : EsquemaColor.textoSuave,
        );
      }),
    );
  }
}
