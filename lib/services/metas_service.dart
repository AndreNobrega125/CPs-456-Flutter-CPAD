import '../models/meta.dart';

// Contrato — CP6 troca MockMetasService por um service de banco real (Supabase/Postgres)
// sem nenhuma tela precisar mudar.
abstract interface class MetasService {
  List<Meta> listar();
  Future<void> adicionar(Meta meta);
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
}
