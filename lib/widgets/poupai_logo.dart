import 'package:flutter/material.dart';
import '../main.dart';

// Placeholder vetorial do logo — trocar por Image.asset quando o arquivo real chegar
class PoupAiLogo extends StatelessWidget {
  final double tamanho;

  const PoupAiLogo({super.key, this.tamanho = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: const BoxDecoration(
        color: PoupAiColors.azulMarinho,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        'P',
        style: TextStyle(
          color: PoupAiColors.dourado,
          fontSize: tamanho * 0.55,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
