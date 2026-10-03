import 'package:flutter/material.dart';

import '../core/theme/app_palette.dart';
import '../core/theme/app_theme.dart';
import '../widgets/estados.dart';
import '../widgets/poup_card.dart';
import '../widgets/poupai_logo.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = PoupAiPalette.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          const Center(child: PoupAiLogo(tamanho: 80)),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'Estudante FIAP',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: p.texto),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Turma 2CCPG',
              style: TextStyle(fontSize: 15, color: p.textoSuave),
            ),
          ),
          const SizedBox(height: 24),
          const TituloSecao('Aparência'),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, modo, _) => SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto), label: Text('Sistema')),
                ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode), label: Text('Claro')),
                ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode), label: Text('Escuro')),
              ],
              selected: {modo},
              showSelectedIcon: false,
              onSelectionChanged: (escolha) => themeModeNotifier.value = escolha.first,
            ),
          ),
          const SizedBox(height: 24),
          const TituloSecao('Sobre o PoupAI'),
          const PoupCard(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LinhaSobre(rotulo: 'Versão', valor: '1.0.0 (CP6 · app final)'),
                  _LinhaSobre(rotulo: 'Projeto', valor: 'CPAD · FIAP · Turma 2CCPG'),
                  _LinhaSobre(rotulo: 'Dados', valor: 'Salvos na nuvem (Supabase)'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinhaSobre extends StatelessWidget {
  final String rotulo;
  final String valor;

  const _LinhaSobre({required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              rotulo,
              style: const TextStyle(fontSize: 14, color: PoupAiColors.textoCardSecundario),
            ),
          ),
          Expanded(
            child: Text(valor, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}