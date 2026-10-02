import 'package:flutter/material.dart';

import '../core/theme/app_palette.dart';
import '../core/theme/app_theme.dart';
import '../widgets/estados.dart';
import '../widgets/poup_card.dart';
import '../widgets/poupai_logo.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  void _emBreve(BuildContext context, String recurso) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$recurso: em breve')),
    );
  }

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
          _PerfilItem(
            icon: Icons.edit_outlined,
            label: 'Editar dados',
            onTap: () => _emBreve(context, 'Editar dados'),
          ),
          _PerfilItem(
            icon: Icons.notifications_none,
            label: 'Notificações',
            onTap: () => _emBreve(context, 'Notificações'),
          ),
          _PerfilItem(
            icon: Icons.security_outlined,
            label: 'Privacidade',
            onTap: () => _emBreve(context, 'Privacidade'),
          ),
          _PerfilItem(
            icon: Icons.help_outline,
            label: 'Ajuda',
            onTap: () => _emBreve(context, 'Ajuda'),
          ),
          _PerfilItem(
            icon: Icons.logout,
            label: 'Sair',
            destructivo: true,
            onTap: () => _emBreve(context, 'Sair'),
          ),
        ],
      ),
    );
  }
}

class _PerfilItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool destructivo;
  final VoidCallback onTap;

  const _PerfilItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructivo = false,
  });

  @override
  Widget build(BuildContext context) {
    final cor = destructivo ? PoupAiColors.negativo : PoupAiColors.textoCard;
    return PoupCard(
      child: ListTile(
        leading: Icon(icon, color: cor),
        title: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: cor)),
        trailing: Icon(Icons.chevron_right, color: cor),
        onTap: onTap,
      ),
    );
  }
}
