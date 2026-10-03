import 'package:flutter/foundation.dart';
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
    // Se a tabela de pagamentos ainda não existir no banco, o app segue funcionando sem eles.
    List<Map<String, dynamic>> pagamentos = [];
    try {
      pagamentos = List<Map<String, dynamic>>.from(await _client.from('pagamentos_grupo').select());
    } catch (e) {
      debugPrint('Pagamentos indisponíveis (rodar supabase/migracao_pagamentos.sql): $e');
    }

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
        pagamentos: pagamentos
            .where((p) => p['grupo_id'] == g['id'])
            .map<Pagamento>((p) => Pagamento(
                  id: p['id'] as String,
                  de: p['de'] as String,
                  para: p['para'] as String,
                  valor: (p['valor'] as num).toDouble(),
                ))
            .toList(),
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

  @override
  Future<void> registrarPagamento(String grupoId, Pagamento pagamento) async {
    final linha = await _client
        .from('pagamentos_grupo')
        .insert({
          'grupo_id': grupoId,
          'de': pagamento.de,
          'para': pagamento.para,
          'valor': pagamento.valor,
        })
        .select()
        .single();
    final grupo = _cache.firstWhere((g) => g.id == grupoId);
    grupo.pagamentos.add(Pagamento(
      id: linha['id'] as String,
      de: pagamento.de,
      para: pagamento.para,
      valor: pagamento.valor,
    ));
  }
}
