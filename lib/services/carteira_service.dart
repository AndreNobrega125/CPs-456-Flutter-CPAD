import 'package:flutter/material.dart';
import '../models/movimento.dart';

// Mesmo padrão do MetasService — CP6 troca a implementação mock por banco real
// sem mudar nenhuma tela.
abstract interface class CarteiraService {
  List<Movimento> listar();
  Future<void> adicionar(Movimento movimento);
  double get saldo;
  Map<String, double> gastosPorCategoria();
}

class MockCarteiraService implements CarteiraService {
  final List<Movimento> _movimentos = [
    const Movimento(
      id: '1',
      descricao: 'Mercado (dividido c/ 3)',
      valor: -45,
      categoria: 'Alimentação',
      icon: Icons.shopping_cart_outlined,
    ),
    const Movimento(
      id: '2',
      descricao: 'Estágio',
      valor: 600,
      icon: Icons.work_outline,
    ),
    const Movimento(
      id: '3',
      descricao: 'Uber',
      valor: -18.30,
      categoria: 'Transporte',
      icon: Icons.local_taxi_outlined,
    ),
    const Movimento(
      id: '4',
      descricao: 'Cinema',
      valor: -60,
      categoria: 'Lazer',
      icon: Icons.sports_esports_outlined,
    ),
    const Movimento(
      id: '5',
      descricao: 'Almoço fora',
      valor: -165,
      categoria: 'Alimentação',
      icon: Icons.shopping_cart_outlined,
    ),
    const Movimento(
      id: '6',
      descricao: 'Ônibus',
      valor: -76.70,
      categoria: 'Transporte',
      icon: Icons.local_taxi_outlined,
    ),
  ];

  @override
  List<Movimento> listar() => List.unmodifiable(_movimentos.reversed);

  @override
  Future<void> adicionar(Movimento movimento) async {
    _movimentos.add(movimento);
  }

  @override
  double get saldo => _movimentos.fold(0, (soma, m) => soma + m.valor);

  @override
  Map<String, double> gastosPorCategoria() {
    final mapa = <String, double>{};
    for (final m in _movimentos) {
      if (m.categoria == null) continue;
      mapa[m.categoria!] = (mapa[m.categoria!] ?? 0) + m.valor.abs();
    }
    return mapa;
  }
}
