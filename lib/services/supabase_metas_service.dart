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
    await _client.from('metas').insert({
      'nome': meta.nome,
      'valor_atual': meta.valorAtual,
      'valor_alvo': meta.valorAlvo,
    });
    _cache = [..._cache, meta];
  }
}
