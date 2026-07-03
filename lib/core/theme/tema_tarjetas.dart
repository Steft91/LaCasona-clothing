import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'esquema_color.dart';

class TemaTarjetas {
  static CardThemeData get cardTheme {
    return CardThemeData(
      color: EsquemaColor.blancoHueso,
      elevation: 10,
      margin: EdgeInsets.zero,
      shadowColor: AppTheme.heavyShadow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppTheme.lineGold, width: 1.3),
      ),
    );
  }

  static BoxDecoration get tarjetaPrincipal {
    return _decoracionMarco();
  }

  static BoxDecoration get tarjetaOscura {
    return _decoracionMarco(
      gradient: AppTheme.woodGradient,
      borde: EsquemaColor.doradoAntiguo,
    );
  }

  static BoxDecoration get tarjetaDestacada {
    return _decoracionMarco(
      gradient: AppTheme.goldGradient,
      borde: EsquemaColor.doradoSuave,
    );
  }

  static BoxDecoration tarjetaColor({
    required Color color,
    Color sombra = AppTheme.heavyShadow,
  }) {
    return _decoracionMarco(color: color, sombra: sombra);
  }

  static BoxDecoration _decoracionMarco({
    Color color = EsquemaColor.blancoHueso,
    Gradient? gradient = AppTheme.parchmentGradient,
    Color borde = AppTheme.lineGold,
    Color sombra = AppTheme.heavyShadow,
  }) {
    return BoxDecoration(
      color: gradient == null ? color : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: borde, width: 1.3),
      boxShadow: [
        BoxShadow(
          color: sombra,
          offset: const Offset(0, 14),
          blurRadius: 24,
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.08),
          offset: const Offset(0, -2),
          blurRadius: 8,
        ),
      ],
    );
  }
}
