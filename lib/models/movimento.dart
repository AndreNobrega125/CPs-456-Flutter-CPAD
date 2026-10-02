import 'package:flutter/material.dart';

class Movimento {
  final String id;
  final String descricao;
  final double valor; // positivo = receita, negativo = despesa
  final String? categoria; // só despesas têm categoria (usado no gráfico)
  final IconData icon;

  const Movimento({
    required this.id,
    required this.descricao,
    required this.valor,
    this.categoria,
    required this.icon,
  });

  bool get isReceita => valor > 0;
}

const categoriasDespesa = {
  'Alimentação': Icons.shopping_cart_outlined,
  'Transporte': Icons.local_taxi_outlined,
  'Lazer': Icons.sports_esports_outlined,
  'Outros': Icons.more_horiz,
};

const categoriaCores = {
  'Alimentação': Colors.orange,
  'Transporte': Colors.blue,
  'Lazer': Colors.purple,
  'Outros': Colors.grey,
};
