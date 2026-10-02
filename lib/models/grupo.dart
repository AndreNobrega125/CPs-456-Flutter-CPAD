import '../utils/formatters.dart';

class DespesaGrupo {
  final String id;
  final String descricao;
  final double valor;
  final String pagoPor;

  const DespesaGrupo({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.pagoPor,
  });
}

class Grupo {
  final String id;
  final String nome;
  final List<String> membros; // sempre inclui 'Você' como primeiro membro
  final List<DespesaGrupo> despesas;

  Grupo({
    required this.id,
    required this.nome,
    required this.membros,
    List<DespesaGrupo>? despesas,
  }) : despesas = despesas ?? [];

  double get totalGasto => despesas.fold(0, (soma, d) => soma + d.valor);

  double get cotaPorPessoa => membros.isEmpty ? 0 : totalGasto / membros.length;

  double get saldoVoce {
    final pagoPorVoce = despesas
        .where((d) => d.pagoPor == 'Você')
        .fold(0.0, (soma, d) => soma + d.valor);
    return pagoPorVoce - cotaPorPessoa;
  }

  String get resumoSaldo {
    if (despesas.isEmpty) return 'Sem despesas ainda';
    if (saldoVoce.abs() < 0.01) return 'Sem pendências';
    if (saldoVoce > 0) return 'Te devem ${formatarMoeda(saldoVoce)}';
    return 'Você deve ${formatarMoeda(saldoVoce.abs())}';
  }
}
