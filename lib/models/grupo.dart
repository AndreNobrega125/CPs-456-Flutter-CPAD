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

/// Uma transferência sugerida para quitar o grupo: [de] paga [valor] a [para].
class Acerto {
  final String de;
  final String para;
  final double valor;

  const Acerto({required this.de, required this.para, required this.valor});
}

/// Um pagamento já feito entre dois integrantes: [de] pagou [valor] a [para].
class Pagamento {
  final String id;
  final String de;
  final String para;
  final double valor;

  const Pagamento({required this.id, required this.de, required this.para, required this.valor});
}

class Grupo {
  final String id;
  final String nome;
  final List<String> membros; // sempre inclui 'Você' como primeiro membro
  final List<DespesaGrupo> despesas;
  final List<Pagamento> pagamentos;

  Grupo({
    required this.id,
    required this.nome,
    required this.membros,
    List<DespesaGrupo>? despesas,
    List<Pagamento>? pagamentos,
  })  : despesas = despesas ?? [],
        pagamentos = pagamentos ?? [];

  double get totalGasto => despesas.fold(0, (soma, d) => soma + d.valor);

  double get cotaPorPessoa => membros.isEmpty ? 0 : totalGasto / membros.length;

  double get saldoVoce => saldos['Você'] ?? 0;

  /// Saldo de cada integrante: o que pagou menos a sua cota (positivo = tem a receber).
  /// Pagamentos já registrados entram no cálculo: quem pagou sobe, quem recebeu desce.
  Map<String, double> get saldos {
    final cota = cotaPorPessoa;
    return {
      for (final m in membros)
        m: despesas.where((d) => d.pagoPor == m).fold(0.0, (soma, d) => soma + d.valor) -
            cota +
            pagamentos.where((p) => p.de == m).fold(0.0, (soma, p) => soma + p.valor) -
            pagamentos.where((p) => p.para == m).fold(0.0, (soma, p) => soma + p.valor),
    };
  }

  /// Quem deve pagar quanto a quem para zerar o grupo, no menor número de
  /// transferências (cada devedor paga ao credor com mais a receber).
  List<Acerto> get acertos {
    const folga = 0.005; // ignora diferenças menores que meio centavo
    final credores = saldos.entries.where((e) => e.value > folga).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final devedores = saldos.entries.where((e) => e.value < -folga).toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final restoCredor = [for (final c in credores) c.value];
    final resultado = <Acerto>[];

    for (final devedor in devedores) {
      var aPagar = -devedor.value;
      for (var i = 0; i < credores.length && aPagar > folga; i++) {
        if (restoCredor[i] <= folga) continue;
        final pagamento = aPagar < restoCredor[i] ? aPagar : restoCredor[i];
        resultado.add(Acerto(de: devedor.key, para: credores[i].key, valor: pagamento));
        restoCredor[i] -= pagamento;
        aPagar -= pagamento;
      }
    }
    return resultado;
  }

  String get resumoSaldo {
    if (despesas.isEmpty) return 'Sem despesas ainda';
    if (saldoVoce.abs() < 0.01) return 'Sem pendências';
    if (saldoVoce > 0) return 'Te devem ${formatarMoeda(saldoVoce)}';
    return 'Você deve ${formatarMoeda(saldoVoce.abs())}';
  }
}
