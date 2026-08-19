import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/poupai_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            PoupAiLogo(tamanho: 28),
            SizedBox(width: 10),
            Text('PoupAI'),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Saldo atual', style: TextStyle(fontSize: 14, color: Color(0xFF616161))),
                  SizedBox(height: 8),
                  Text('R\$ 842,50', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _AcaoRapida(icon: Icons.add_circle_outline, label: 'Receita')),
              const SizedBox(width: 12),
              Expanded(child: _AcaoRapida(icon: Icons.remove_circle_outline, label: 'Despesa')),
              const SizedBox(width: 12),
              Expanded(child: _AcaoRapida(icon: Icons.call_split, label: 'Split')),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Gastos por categoria',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: PoupAiColors.branco),
          ),
          const SizedBox(height: 8),
          const _CategoriaBar(nome: 'Alimentação', valor: 210, total: 400, cor: Colors.orange),
          const _CategoriaBar(nome: 'Transporte', valor: 95, total: 400, cor: Colors.blue),
          const _CategoriaBar(nome: 'Lazer', valor: 60, total: 400, cor: Colors.purple),
          const SizedBox(height: 24),
          const Text(
            'Movimentações recentes',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: PoupAiColors.branco),
          ),
          const SizedBox(height: 8),
          const _MovimentoTile(
            descricao: 'Mercado (dividido c/ 3)',
            valor: '-R\$ 45,00',
            icon: Icons.shopping_cart_outlined,
          ),
          const _MovimentoTile(
            descricao: 'Estágio',
            valor: '+R\$ 600,00',
            icon: Icons.work_outline,
          ),
          const _MovimentoTile(
            descricao: 'Uber',
            valor: '-R\$ 18,30',
            icon: Icons.local_taxi_outlined,
          ),
        ],
      ),
    );
  }
}

class _AcaoRapida extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AcaoRapida({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriaBar extends StatelessWidget {
  final String nome;
  final double valor;
  final double total;
  final Color cor;

  const _CategoriaBar({required this.nome, required this.valor, required this.total, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(nome, style: const TextStyle(color: PoupAiColors.branco)),
              Text(
                'R\$ ${valor.toStringAsFixed(2)}',
                style: TextStyle(color: PoupAiColors.branco.withValues(alpha: 0.85)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: valor / total,
              minHeight: 6,
              color: cor,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovimentoTile extends StatelessWidget {
  final String descricao;
  final String valor;
  final IconData icon;

  const _MovimentoTile({required this.descricao, required this.valor, required this.icon});

  @override
  Widget build(BuildContext context) {
    final positivo = valor.startsWith('+');
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon, size: 20)),
        title: Text(descricao),
        trailing: Text(
          valor,
          style: TextStyle(
            color: positivo ? Colors.green[700] : Colors.red[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
