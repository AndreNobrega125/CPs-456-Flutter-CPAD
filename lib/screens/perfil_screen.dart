import 'package:flutter/material.dart';
import '../widgets/poupai_logo.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                const PoupAiLogo(tamanho: 80),
                const SizedBox(height: 12),
                const Text('Estudante FIAP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Turma 2CCPG', style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Economizado', valor: 'R\$ 1.450')),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(label: 'Grupos ativos', valor: '2')),
            ],
          ),
          const SizedBox(height: 24),
          const _PerfilItem(icon: Icons.edit_outlined, label: 'Editar dados'),
          const _PerfilItem(icon: Icons.notifications_none, label: 'Notificações'),
          const _PerfilItem(icon: Icons.security_outlined, label: 'Privacidade'),
          const _PerfilItem(icon: Icons.help_outline, label: 'Ajuda'),
          const _PerfilItem(icon: Icons.logout, label: 'Sair', destructivo: true),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String valor;

  const _StatCard({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            const SizedBox(height: 6),
            Text(valor, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _PerfilItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool destructivo;

  const _PerfilItem({required this.icon, required this.label, this.destructivo = false});

  @override
  Widget build(BuildContext context) {
    final cor = destructivo ? Colors.red[700] : null;
    return Card(
      child: ListTile(
        leading: Icon(icon, color: cor),
        title: Text(label, style: TextStyle(color: cor)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
