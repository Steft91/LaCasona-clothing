import 'package:flutter/material.dart';

import 'app_theme.dart';

class EsquemaColor {
  static const Color maderaProfunda = AppTheme.deepWood;
  static const Color maderaTallada = AppTheme.carvedWood;
  static const Color cremaColonial = AppTheme.colonialCream;
  static const Color blancoHueso = AppTheme.ivoryWall;
  static const Color beigeCalido = AppTheme.warmStone;
  static const Color terracota = AppTheme.terracotta;
  static const Color terracotaSuave = AppTheme.mutedTerracotta;
  static const Color doradoAntiguo = AppTheme.antiqueGold;
  static const Color doradoSuave = AppTheme.softGold;
  static const Color verdeJardin = AppTheme.gardenGreen;
  static const Color verdeFloral = AppTheme.floralGreen;
  static const Color textoSuave = AppTheme.mutedText;

  static const Color negroTinta = AppTheme.inkBrown;
  static const Color blancoPapel = AppTheme.ivoryWall;

  static const Color amarilloPrincipal = AppTheme.antiqueGold;
  static const Color amarilloClaro = AppTheme.softGold;
  static const Color amarilloSuave = Color(0xFFF4E7BF);

  static const Color azulComic = AppTheme.gardenGreen;
  static const Color azulClaro = AppTheme.floralGreen;

  static const Color naranjaComic = AppTheme.terracotta;
  static const Color naranjaClaro = AppTheme.mutedTerracotta;

  static const Color rojoComic = AppTheme.errorColor;
  static const Color verdeComic = AppTheme.successColor;

  static const Color fondoClaro = AppTheme.smokedCedar;
  static const Color grisClaro = AppTheme.dividerColor;
  static const Color grisTexto = AppTheme.mutedText;

  static const Color negroPrincipal = negroTinta;
  static const Color negroSecundario = AppTheme.carvedWood;
  static const Color negroSuave = AppTheme.mutedText;
  static const Color blanco = blancoPapel;
  static const Color verdeExito = verdeComic;
  static const Color rojoError = rojoComic;

  static const ColorScheme esquemaClaro = ColorScheme(
    brightness: Brightness.light,
    primary: maderaTallada,
    onPrimary: blancoHueso,
    secondary: doradoAntiguo,
    onSecondary: maderaProfunda,
    tertiary: verdeJardin,
    onTertiary: blancoHueso,
    error: rojoComic,
    onError: blancoHueso,
    surface: blancoHueso,
    onSurface: negroTinta,
  );
}
