import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/grupo.dart';
import 'split_service.dart';

// Troca de MockSplitService() por SupabaseSplitService() no SplitScreen
// quando as tabelas `grupos`/`despesas_grupo` (ver supabase/schema.sql) existirem.
class SupabaseSplitService implements SplitService {
  final _client = Supabase.instance.client;
  List<Grupo> _cache = [];

  @override
  List<Grupo> listar() => List.unmodifiable(_cache);

  Future<void> carregar() async {
    final grupos = await _client.from('grupos').select().order('criado_em');
    final despesas = await _client.from('despesas_grupo').select();

    _cache = grupos.map<Grupo>((g) {
      final despesasDoGrupo = despesas
          .where((d) => d['grupo_id'] == g['id'])
          .map<DespesaGrupo>((d) => DespesaGrupo(
                id: d['id'] as String,
                descricao: d['descricao'] as String,
                valor: (d['valor'] as num).toDouble(),
                pagoPor: d['pago_por'] as String,
              ))
          .toList();

      return Grupo(
        id: g['id'] as String,
        nome: g['nome'] as String,
        membros: List<String>.from(g['membros'] as List),
        despesas: despesasDoGrupo,
      );
    }).toList();
  }

  @override
  Future<void> adicionarGrupo(Grupo grupo) async {
    // O id (uuid) é gerado pelo banco; guardamos o id real devolvido no cache.
    final linha = await _client
        .from('grupos')
        .insert({
          'nome': grupo.nome,
          'membros': grupo.membros,
        })
        .select()
        .single();
    _cache = [
      ..._cache,
      Grupo(id: linha['id'] as String, nome: grupo.nome, membros: grupo.membros),
    ];
  }

  @override
  Future<void> adicionarDespesa(String grupoId, DespesaGrupo despesa) async {
    await _client.from('despesas_grupo').insert({
      'grupo_id': grupoId,
      'descricao': despesa.descricao,
      'valor': despesa.valor,
      'pago_por': despesa.pagoPor,
    });
    final grupo = _cache.firstWhere((g) => g.id == grupoId);
    grupo.despesas.add(despesa);
  }
}
