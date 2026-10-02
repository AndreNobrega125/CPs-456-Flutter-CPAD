import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/movimento.dart';
import 'carteira_service.dart';

// Implementação real — troca de MockCarteiraService() por SupabaseCarteiraService()
// no HomeScreen quando o banco (tabela `movimentos`, ver supabase/schema.sql) existir.
// Mesma interface, nenhuma tela precisa mudar.
class SupabaseCarteiraService implements CarteiraService {
  final _client = Supabase.instance.client;
  List<Movimento> _cache = [];

  @override
  List<Movimento> listar() => List.unmodifiable(_cache);

  Future<void> carregar() async {
    final linhas = await _client
        .from('movimentos')
        .select()
        .order('criado_em', ascending: false);

    _cache = linhas.map<Movimento>((l) {
      final categoria = l['categoria'] as String?;
      return Movimento(
        id: l['id'] as String,
        descricao: l['descricao'] as String,
        valor: (l['valor'] as num).toDouble(),
        categoria: categoria,
        icon: categoria != null
            ? (categoriasDespesa[categoria] ?? Icons.more_horiz)
            : Icons.attach_money,
      );
    }).toList();
  }

  @override
  Future<void> adicionar(Movimento movimento) async {
    await _client.from('movimentos').insert({
      'descricao': movimento.descricao,
      'valor': movimento.valor,
      'categoria': movimento.categoria,
    });
    _cache = [movimento, ..._cache];
  }

  @override
  double get saldo => _cache.fold(0, (soma, m) => soma + m.valor);

  @override
  Map<String, double> gastosPorCategoria() {
    final mapa = <String, double>{};
    for (final m in _cache) {
      if (m.categoria == null) continue;
      mapa[m.categoria!] = (mapa[m.categoria!] ?? 0) + m.valor.abs();
    }
    return mapa;
  }
}
