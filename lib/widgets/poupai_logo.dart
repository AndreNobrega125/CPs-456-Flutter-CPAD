import 'package:flutter/material.dart';

// Símbolo oficial do PoupAI (assets/logo_poupai.png) dentro de um círculo claro,
// já que a imagem tem fundo claro e o app é escuro.
class PoupAiLogo extends StatelessWidget {
  final double tamanho;

  const PoupAiLogo({super.key, this.tamanho = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamanho,
      height: tamanho,
      padding: EdgeInsets.all(tamanho * 0.12),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F7),
        shape: BoxShape.circle,
      ),
      child: Image.asset('assets/logo_poupai.png', fit: BoxFit.contain),
    );
  }
}
