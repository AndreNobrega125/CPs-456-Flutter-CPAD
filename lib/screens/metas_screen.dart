import 'package:flutter/material.dart';

class MetasScreen extends StatelessWidget {
  const MetasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metas de economia')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MetaCard(nome: 'Viagem de formatura', atual: 450, meta: 1500),
          _MetaCard(nome: 'Notebook novo', atual: 900, meta: 3200),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Nova meta'),
      ),
    );
  }
}

class _MetaCard extends StatelessWidget {
  final String nome;
  final double atual;
  final double meta;

  const _MetaCard({required this.nome, required this.atual, required this.meta});

  @override
  Widget build(BuildContext context) {
    final progresso = atual / meta;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nome, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progresso, minHeight: 8),
            const SizedBox(height: 8),
            Text('R\$ ${atual.toStringAsFixed(2)} de R\$ ${meta.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
