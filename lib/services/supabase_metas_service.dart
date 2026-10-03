import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/meta.dart';
import 'metas_service.dart';

// Troca de MockMetasService() por SupabaseMetasService() no MetasScreen
// quando a tabela `metas` (ver supabase/schema.sql) existir.
class SupabaseMetasService implements MetasService {
  final _client = Supabase.instance.client;
  List<Meta> _cache = [];

  @override
  List<Meta> listar() => List.unmodifiable(_cache);

  Future<void> carregar() async {
    final linhas = await _client.from('metas').select().order('criado_em');

    _cache = linhas
        .map<Meta>((l) => Meta(
              id: l['id'] as String,
              nome: l['nome'] as String,
              valorAtual: (l['valor_atual'] as num).toDouble(),
              valorAlvo: (l['valor_alvo'] as num).toDouble(),
            ))
        .toList();
  }

  @override
  Future<void> adicionar(Meta meta) async {
    // O id (uuid) é gerado pelo banco; guardamos o id real devolvido no cache.
    final linha = await _client
        .from('metas')
        .insert({
          'nome': meta.nome,
          'valor_atual': meta.valorAtual,
          'valor_alvo': meta.valorAlvo,
        })
        .select()
        .single();
    _cache = [
      Meta(
        id: linha['id'] as String,
        nome: meta.nome,
        valorAtual: meta.valorAtual,
        valorAlvo: meta.valorAlvo,
      ),
      ..._cache,
    ];
  }

  @override
  Future<void> depositar(String id, double valor) async {
    final i = _cache.indexWhere((m) => m.id == id);
    if (i < 0) return;
    final m = _cache[i];
    final novoValor = m.valorAtual + valor;

    await _client.from('metas').update({'valor_atual': novoValor}).eq('id', id);

    _cache = [..._cache]
      ..[i] = Meta(id: m.id, nome: m.nome, valorAtual: novoValor, valorAlvo: m.valorAlvo);
  }
}
