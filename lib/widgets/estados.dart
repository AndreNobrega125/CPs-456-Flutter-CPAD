import 'package:flutter/material.dart';

import '../core/theme/app_palette.dart';

class EstadoVazio extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String mensagem;

  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    required this.mensagem,
  });

  @override
  Widget build(BuildContext context) {
    final p = PoupAiPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 56, color: p.acento),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: p.texto),
            ),
            const SizedBox(height: 8),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.4, color: p.textoSuave),
            ),
          ],
        ),
      ),
    );
  }
}

class EstadoErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback onTentarDeNovo;

  const EstadoErro({super.key, required this.mensagem, required this.onTentarDeNovo});

  @override
  Widget build(BuildContext context) {
    final p = PoupAiPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 56, color: p.acento),
            const SizedBox(height: 16),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.4, color: p.texto),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onTentarDeNovo,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar de novo'),
            ),
          ],
        ),
      ),
    );
  }
}

class TituloSecao extends StatelessWidget {
  final String texto;

  const TituloSecao(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    final p = PoupAiPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        texto,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: p.texto),
      ),
    );
  }
}
