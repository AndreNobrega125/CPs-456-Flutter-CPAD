import 'package:flutter/material.dart';

/// Cores da marca: iguais nos temas claro e escuro.
abstract final class PoupAiColors {
  static const azulEscuro = Color(0xFF0B1428); // topo/rodapé (AppBar e navegação)
  static const azulMarinho = Color.fromARGB(255, 17, 27, 49);
  static const dourado = Color(0xFFD4A657); // acento da marca
  static const branco = Color(0xFFFFFFFF);

  // Texto dentro dos cards (os cards são claros nos dois temas)
  static const textoCard = Color(0xFF0B1428);
  static const textoCardSecundario = Color(0xFF1F2E4D);
  // Verde/vermelho escuros: os tons padrão ficam ilegíveis sobre o card
  static const positivo = Color(0xFF0B4F1C);
  static const negativo = Color(0xFF7A0F0F);
}

/// Cores que mudam entre o tema escuro e o claro, distribuídas pelo próprio
/// tema (ThemeExtension). As telas pedem `PoupAiPalette.of(context)`.
@immutable
class PoupAiPalette extends ThemeExtension<PoupAiPalette> {
  const PoupAiPalette({
    required this.fundo,
    required this.card,
    required this.cardBorda,
    required this.texto,
    required this.textoSuave,
    required this.acento,
    required this.trilha,
    required this.campo,
    required this.campoBorda,
  });

  final Color fundo; // fundo das telas
  final Color card; // fundo dos cards
  final Color cardBorda; // contorno do card (só aparece no tema claro)
  final Color texto; // texto direto sobre o fundo
  final Color textoSuave; // texto secundário sobre o fundo
  final Color acento; // dourado para ícones/foco sobre o fundo
  final Color trilha; // fundo das barras de progresso sobre o fundo
  final Color campo; // preenchimento dos campos de formulário
  final Color campoBorda; // borda dos campos

  static PoupAiPalette of(BuildContext context) {
    return Theme.of(context).extension<PoupAiPalette>() ?? escuro;
  }

  /// Tema escuro: a identidade do CP4 (fundo azul-marinho, cards azul claro).
  static const escuro = PoupAiPalette(
    fundo: Color.fromARGB(255, 22, 35, 60),
    card: Color.fromARGB(255, 131, 157, 193),
    cardBorda: Colors.transparent,
    texto: Color(0xFFFFFFFF),
    textoSuave: Color(0xCCFFFFFF),
    acento: Color(0xFFD4A657),
    trilha: Color(0x2EFFFFFF),
    campo: Color(0x14FFFFFF),
    campoBorda: Color(0x59FFFFFF),
  );

  /// Tema claro: fundo azul-acinzentado bem claro, cards brancos, dourado mais
  /// escuro para manter contraste sobre o claro.
  static const claro = PoupAiPalette(
    fundo: Color(0xFFEEF2F8),
    card: Color(0xFFFFFFFF),
    cardBorda: Color(0xFFD3DDEC),
    texto: Color(0xFF0B1428),
    textoSuave: Color(0xFF2F4468),
    acento: Color(0xFF8A5F0A),
    trilha: Color(0x240B1428),
    campo: Color(0xFFFFFFFF),
    campoBorda: Color(0x590B1428),
  );

  @override
  PoupAiPalette copyWith() => this;

  @override
  PoupAiPalette lerp(ThemeExtension<PoupAiPalette>? other, double t) {
    if (other is! PoupAiPalette) return this;
    return PoupAiPalette(
      fundo: Color.lerp(fundo, other.fundo, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardBorda: Color.lerp(cardBorda, other.cardBorda, t)!,
      texto: Color.lerp(texto, other.texto, t)!,
      textoSuave: Color.lerp(textoSuave, other.textoSuave, t)!,
      acento: Color.lerp(acento, other.acento, t)!,
      trilha: Color.lerp(trilha, other.trilha, t)!,
      campo: Color.lerp(campo, other.campo, t)!,
      campoBorda: Color.lerp(campoBorda, other.campoBorda, t)!,
    );
  }
}
