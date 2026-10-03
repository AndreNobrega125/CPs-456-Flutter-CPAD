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
      expect(grupo.acertos, isEmpty);
    });
  });

  group('Grupo: quem deve pra quem (acertos)', () {
    test('dois integrantes: quem não pagou paga a sua parte a quem pagou', () {
      final grupo = Grupo(
        id: 'g',
        nome: 'Dupla',
        membros: const ['Você', 'Marina'],
        despesas: [
          const DespesaGrupo(id: '1', descricao: 'Internet', valor: 120, pagoPor: 'Você'),
        ],
      );
      expect(grupo.acertos.length, 1);
      expect(grupo.acertos.first.de, 'Marina');
      expect(grupo.acertos.first.para, 'Você');
      expect(grupo.acertos.first.valor, closeTo(60, 0.001));
    });

    test('caso do seed (Apê 302): 3 devedores pagam à Marina', () {
      final grupo = Grupo(
        id: 'g',
        nome: 'Apê 302',
        membros: const ['Você', 'Marina', 'Lucas', 'Bia'],
        despesas: [
          const DespesaGrupo(id: '1', descricao: 'Aluguel', valor: 2400, pagoPor: 'Marina'),
          const DespesaGrupo(id: '2', descricao: 'Internet', valor: 120, pagoPor: 'Você'),
          const DespesaGrupo(id: '3', descricao: 'Mercado', valor: 320, pagoPor: 'Lucas'),
        ],
      );
      final porDevedor = {for (final a in grupo.acertos) a.de: a};
      expect(grupo.acertos.length, 3);
      expect(porDevedor['Bia']!.para, 'Marina');
      expect(porDevedor['Bia']!.valor, closeTo(710, 0.001));
      expect(porDevedor['Você']!.valor, closeTo(590, 0.001));
      expect(porDevedor['Lucas']!.valor, closeTo(390, 0.001));
    });

    test('dois credores: o devedor paga ao maior primeiro e o resto ao outro', () {
      final grupo = Grupo(
        id: 'g',
        nome: 'Trio',
        membros: const ['Você', 'Ana', 'Léo'],
        despesas: [
          const DespesaGrupo(id: '1', descricao: 'A', valor: 150, pagoPor: 'Ana'),
          const DespesaGrupo(id: '2', descricao: 'B', valor: 60, pagoPor: 'Léo'),
        ],
      );
      // total 210, cota 70: Ana +80, Léo -10, Você -70 → Léo e Você pagam à Ana
      final total = grupo.acertos.fold(0.0, (soma, a) => soma + a.valor);
      expect(total, closeTo(80, 0.001));
      expect(grupo.acertos.every((a) => a.para == 'Ana'), isTrue);
    });

    test('pagamento registrado quita o acerto e zera o saldo', () {
      final grupo = Grupo(
        id: 'g',
        nome: 'Dupla',
        membros: const ['Você', 'Marina'],
        despesas: [
          const DespesaGrupo(id: '1', descricao: 'Mercado', valor: 100, pagoPor: 'Marina'),
        ],
      );
      expect(grupo.resumoSaldo, 'Você deve R\$ 50,00');

      grupo.pagamentos.add(const Pagamento(id: 'p1', de: 'Você', para: 'Marina', valor: 50));

      expect(grupo.acertos, isEmpty);
      expect(grupo.saldoVoce, closeTo(0, 0.001));
      expect(grupo.resumoSaldo, 'Sem pendências');
    });

    test('pagamento parcial reduz o que ainda falta pagar', () {
      final grupo = Grupo(
        id: 'g',
        nome: 'Apê',
        membros: const ['Você', 'Marina', 'Lucas', 'Bia'],
        despesas: [
          const DespesaGrupo(id: '1', descricao: 'Aluguel', valor: 2400, pagoPor: 'Marina'),
          const DespesaGrupo(id: '2', descricao: 'Internet', valor: 120, pagoPor: 'Você'),
          const DespesaGrupo(id: '3', descricao: 'Mercado', valor: 320, pagoPor: 'Lucas'),
        ],
        pagamentos: [
          const Pagamento(id: 'p1', de: 'Você', para: 'Marina', valor: 190),
        ],
      );
      // antes: Você devia 590 a Marina; depois de pagar 190 faltam 400
      final seu = grupo.acertos.where((a) => a.de == 'Você').fold(0.0, (s, a) => s + a.valor);
      expect(seu, closeTo(400, 0.001));
      expect(grupo.saldoVoce, closeTo(-400, 0.001));
    });

    test('a soma dos acertos zera o grupo', () {
      final grupo = Grupo(
        id: 'g',
        nome: 'Cinco',
        membros: const ['Você', 'Pedro', 'Ana', 'Rafa', 'Carol'],
        despesas: [
          const DespesaGrupo(id: '1', descricao: 'Hospedagem', valor: 900, pagoPor: 'Você'),
          const DespesaGrupo(id: '2', descricao: 'Ônibus', valor: 650, pagoPor: 'Pedro'),
        ],
      );
      final pago = grupo.acertos.fold(0.0, (soma, a) => soma + a.valor);
      final aReceber = grupo.saldos.values.where((v) => v > 0).fold(0.0, (soma, v) => soma + v);
      expect(pago, closeTo(aReceber, 0.01));
    });
  });
}
