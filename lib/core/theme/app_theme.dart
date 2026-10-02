import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Modo de tema escolhido: por padrão segue o do sistema (como na aula 17).
/// A tela de Perfil permite forçar claro ou escuro.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);

abstract final class AppTheme {
  static ThemeData get dark => _build(PoupAiPalette.escuro, Brightness.dark);
  static ThemeData get light => _build(PoupAiPalette.claro, Brightness.light);

  static ThemeData _build(PoupAiPalette p, Brightness brilho) {
    final erro = brilho == Brightness.dark ? const Color(0xFFFF8A80) : const Color(0xFFB3261E);

    final esquema = ColorScheme.fromSeed(
      seedColor: PoupAiColors.dourado,
      brightness: brilho,
    ).copyWith(
      primary: PoupAiColors.dourado,
      onPrimary: PoupAiColors.azulEscuro,
      secondary: PoupAiColors.dourado,
      surface: p.fundo,
      onSurface: p.texto,
      error: erro,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      extensions: [p],
      scaffoldBackgroundColor: p.fundo,
      cardTheme: CardThemeData(
        color: p.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: p.cardBorda),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: PoupAiColors.azulEscuro,
        foregroundColor: PoupAiColors.dourado,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: PoupAiColors.azulEscuro,
        indicatorColor: PoupAiColors.dourado.withValues(alpha: 0.25),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color: PoupAiColors.branco, fontSize: 12),
        ),
        iconTheme: WidgetStateProperty.resolveWith((estados) {
          final selecionado = estados.contains(WidgetState.selected);
          return IconThemeData(
            color: selecionado ? PoupAiColors.dourado : PoupAiColors.branco.withValues(alpha: 0.6),
          );
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: PoupAiColors.dourado,
        foregroundColor: PoupAiColors.azulEscuro,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: PoupAiColors.dourado,
          foregroundColor: PoupAiColors.azulEscuro,
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.campo,
        labelStyle: TextStyle(color: p.textoSuave),
        floatingLabelStyle: TextStyle(color: p.acento),
        hintStyle: TextStyle(color: p.texto.withValues(alpha: 0.5)),
        prefixStyle: TextStyle(color: p.texto),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.campoBorda),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.campoBorda),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.acento, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: erro),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: erro, width: 2),
        ),
        errorStyle: TextStyle(color: erro),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.campo,
        labelStyle: TextStyle(color: p.texto),
        deleteIconColor: p.texto,
        side: BorderSide(color: p.campoBorda),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.acento),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: PoupAiColors.dourado,
        contentTextStyle: TextStyle(color: PoupAiColors.azulEscuro, fontWeight: FontWeight.w600),
        behavior: SnackBarBehavior.floating,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (estados) => estados.contains(WidgetState.selected) ? PoupAiColors.dourado : Colors.transparent,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (estados) => estados.contains(WidgetState.selected) ? PoupAiColors.azulEscuro : p.texto,
          ),
          side: WidgetStatePropertyAll(BorderSide(color: p.campoBorda)),
        ),
      ),
    );
  }
}
