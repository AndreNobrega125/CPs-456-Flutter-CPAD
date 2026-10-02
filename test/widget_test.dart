// Testes das regras de negócio do PoupAI (puro Dart, sem banco e sem internet).

import 'package:flutter_test/flutter_test.dart';

import 'package:cp_fintech_estudante/models/grupo.dart';
import 'package:cp_fintech_estudante/utils/formatters.dart';

void main() {
  group('formatarMoeda', () {
    test('usa vírgula decimal e ponto de milhar', () {
      expect(formatarMoeda(1234.5), 'R\$ 1.234,50');
      expect(formatarMoeda(1234567.891), 'R\$ 1.234.567,89');
    });

    test('zero e valores pequenos', () {
      expect(formatarMoeda(0), 'R\$ 0,00');
      expect(formatarMoeda(7), 'R\$ 7,00');
    });

    test('valor negativo mantém o sinal', () {
      expect(formatarMoeda(-45), '-R\$ 45,00');
    });
  });

  group('Grupo (divisão de contas)', () {
    Grupo grupoCom(List<DespesaGrupo> despesas) => Grupo(
          id: 'g1',
          nome: 'Apê teste',
          membros: const ['Você', 'Marina'],
          despesas: despesas,
        );

    test('sem despesas', () {
      expect(grupoCom([]).resumoSaldo, 'Sem despesas ainda');
    });

    test('você pagou tudo: os outros te devem a sua parte', () {
      final grupo = grupoCom([
        const DespesaGrupo(id: '1', descricao: 'Internet', valor: 120, pagoPor: 'Você'),
      ]);
      expect(grupo.cotaPorPessoa, 60);
      expect(grupo.saldoVoce, 60);
      expect(grupo.resumoSaldo, 'Te devem R\$ 60,00');
    });

    test('outra pessoa pagou: você deve a sua parte', () {
      final grupo = grupoCom([
        const DespesaGrupo(id: '1', descricao: 'Mercado', valor: 100, pagoPor: 'Marina'),
      ]);
      expect(grupo.saldoVoce, -50);
      expect(grupo.resumoSaldo, 'Você deve R\$ 50,00');
    });

    test('cada um pagou o mesmo valor: sem pendências', () {
      final grupo = grupoCom([
        const DespesaGrupo(id: '1', descricao: 'A', valor: 80, pagoPor: 'Você'),
        const DespesaGrupo(id: '2', descricao: 'B', valor: 80, pagoPor: 'Marina'),
      ]);
      expect(grupo.resumoSaldo, 'Sem pendências');
    });
  });
}
