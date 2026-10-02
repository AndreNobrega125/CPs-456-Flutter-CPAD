import '../models/grupo.dart';

abstract interface class SplitService {
  List<Grupo> listar();
  Future<void> adicionarGrupo(Grupo grupo);
  Future<void> adicionarDespesa(String grupoId, DespesaGrupo despesa);
}

class MockSplitService implements SplitService {
  final List<Grupo> _grupos = [
    Grupo(
      id: '1',
      nome: 'Apê 302',
      membros: const ['Você', 'Marina', 'Lucas', 'Bia'],
      despesas: [
        const DespesaGrupo(id: '1', descricao: 'Mercado do mês', valor: 320, pagoPor: 'Marina'),
        const DespesaGrupo(id: '2', descricao: 'Internet', valor: 120, pagoPor: 'Você'),
      ],
    ),
    Grupo(
      id: '2',
      nome: 'Viagem fim de ano',
      membros: const ['Você', 'Pedro', 'Ana', 'Rafa', 'Carol', 'Léo'],
      despesas: [
        const DespesaGrupo(id: '1', descricao: 'Hospedagem', valor: 900, pagoPor: 'Você'),
      ],
    ),
  ];

  @override
  List<Grupo> listar() => List.unmodifiable(_grupos);

  @override
  Future<void> adicionarGrupo(Grupo grupo) async {
    _grupos.add(grupo);
  }

  @override
  Future<void> adicionarDespesa(String grupoId, DespesaGrupo despesa) async {
    final grupo = _grupos.firstWhere((g) => g.id == grupoId);
    grupo.despesas.add(despesa);
  }
}
