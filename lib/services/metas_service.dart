import '../models/meta.dart';

// Contrato — CP6 troca MockMetasService por um service de banco real (Supabase/Postgres)
// sem nenhuma tela precisar mudar.
abstract interface class MetasService {
  List<Meta> listar();
  Future<void> adicionar(Meta meta);
  Future<void> depositar(String id, double valor);
}

class MockMetasService implements MetasService {
  final List<Meta> _metas = [
    const Meta(id: '1', nome: 'Viagem de formatura', valorAtual: 450, valorAlvo: 1500),
    const Meta(id: '2', nome: 'Notebook novo', valorAtual: 900, valorAlvo: 3200),
  ];

  @override
  List<Meta> listar() => List.unmodifiable(_metas);

  @override
  Future<void> adicionar(Meta meta) async {
    _metas.add(meta);
  }

  @override
  Future<void> depositar(String id, double valor) async {
    final i = _metas.indexWhere((m) => m.id == id);
    if (i < 0) return;
    final m = _metas[i];
    _metas[i] = Meta(id: m.id, nome: m.nome, valorAtual: m.valorAtual + valor, valorAlvo: m.valorAlvo);
  }
}
