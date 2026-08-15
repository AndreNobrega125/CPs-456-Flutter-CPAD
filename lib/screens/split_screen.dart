import 'package:flutter/material.dart';

class SplitScreen extends StatelessWidget {
  const SplitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Split de contas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Grupos ativos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _GrupoCard(nome: 'Apê 302', membros: 4, saldo: 'Você deve R\$ 32,00'),
          _GrupoCard(nome: 'Viagem fim de ano', membros: 6, saldo: 'Te devem R\$ 120,00'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Novo grupo'),
      ),
    );
  }
}

class _GrupoCard extends StatelessWidget {
  final String nome;
  final int membros;
  final String saldo;

  const _GrupoCard({required this.nome, required this.membros, required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.group)),
        title: Text(nome),
        subtitle: Text('$membros integrantes'),
        trailing: Text(saldo, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
