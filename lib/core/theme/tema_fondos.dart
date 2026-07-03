import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'esquema_color.dart';

class TemaFondos {
  static BoxDecoration get fondoPrincipal {
    return const BoxDecoration(gradient: AppTheme.wallGradient);
  }

  static BoxDecoration get fondoOscuro {
    return const BoxDecoration(color: EsquemaColor.maderaProfunda);
  }

  static BoxDecoration get fondoAmarillo {
    return const BoxDecoration(color: EsquemaColor.doradoSuave);
  }

  static BoxDecoration get fondoDestacado {
    return const BoxDecoration(gradient: AppTheme.goldGradient);
  }

  static BoxDecoration get fondoComic {
    return const BoxDecoration(gradient: AppTheme.wallGradient);
  }

  static BoxDecoration fondoSeccion({
    Color color = EsquemaColor.blancoHueso,
  }) {
    return BoxDecoration(
      gradient: color == EsquemaColor.blancoHueso
          ? AppTheme.parchmentGradient
          : null,
      color: color == EsquemaColor.blancoHueso ? null : color,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppTheme.lineGold, width: 1.3),
      boxShadow: const [
        BoxShadow(
          color: AppTheme.heavyShadow,
          offset: Offset(0, 14),
          blurRadius: 24,
        ),
      ],
    );
  }

  static BoxDecoration get fondoRestaurante {
    return const BoxDecoration(gradient: AppTheme.woodGradient);
  }
}
