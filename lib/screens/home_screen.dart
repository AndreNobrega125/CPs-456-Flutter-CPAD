import 'package:flutter/material.dart';
import '../core/theme/app_palette.dart';
import '../models/movimento.dart';
import '../services/supabase_carteira_service.dart';
import '../services/supabase_split_service.dart';
import '../utils/formatters.dart';
import '../widgets/estados.dart';
import '../widgets/poup_card.dart';
import '../widgets/poupai_logo.dart';
import 'nova_movimentacao_screen.dart';
import 'split_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseCarteiraService _service = SupabaseCarteiraService();
  final SupabaseSplitService _splitService = SupabaseSplitService();
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      await Future.wait([_service.carregar(), _splitService.carregar()]);
    } catch (e) {
      debugPrint('Erro ao carregar carteira: $e');
      _erro = 'Não foi possível carregar a carteira. Verifique sua conexão.';
    }
    if (!mounted) return;
    setState(() => _carregando = false);
  }

  Future<void> _abrirNovaMovimentacao(bool isDespesa) async {
    final movimento = await Navigator.push<Movimento>(
      context,
      MaterialPageRoute(builder: (_) => NovaMovimentacaoScreen(isDespesa: isDespesa)),
    );

    if (movimento == null) return;
    if (!mounted) return;

    try {
      await _service.adicionar(movimento);
    } catch (e) {
      debugPrint('Erro ao registrar movimentação: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar. Verifique sua conexão.')),
      );
      return;
    }
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isDespesa ? 'Despesa registrada' : 'Receita registrada')),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PoupAiLogo(tamanho: 28),
          SizedBox(width: 10),
          Text('PoupAI'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Scaffold(appBar: _appBar(), body: const Center(child: CircularProgressIndicator()));
    }

    if (_erro != null) {
      return Scaffold(
        appBar: _appBar(),
        body: EstadoErro(mensagem: _erro!, onTentarDeNovo: _carregar),
      );
    }

    final movimentos = _service.listar();
    final gastos = _service.gastosPorCategoria();
    final categoriasOrdenadas = gastos.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maiorGasto = gastos.values.isEmpty ? 1.0 : gastos.values.reduce((a, b) => a > b ? a : b);
    final saldo = _service.saldo;

    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PoupCard(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo atual',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: PoupAiColors.textoCardSecundario),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatarMoeda(saldo),
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: saldo < 0 ? PoupAiColors.negativo : PoupAiColors.textoCard,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _AcaoRapida(
                  icon: Icons.arrow_downward,
                  label: 'Receita',
                  onTap: () => _abrirNovaMovimentacao(false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AcaoRapida(
                  icon: Icons.arrow_upward,
                  label: 'Despesa',
                  onTap: () => _abrirNovaMovimentacao(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AcaoRapida(
                  icon: Icons.call_split,
                  label: 'Dividir conta',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SplitScreen()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PendenciasSplit(
            voceDeve: _splitService
                .listar()
                .where((g) => g.saldoVoce < -0.01)
                .fold(0.0, (soma, g) => soma + g.saldoVoce.abs()),
            teDevem: _splitService
                .listar()
                .where((g) => g.saldoVoce > 0.01)
                .fold(0.0, (soma, g) => soma + g.saldoVoce),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SplitScreen()),
            ),
          ),
          const SizedBox(height: 24),
          const TituloSecao('Gastos por categoria'),
          if (gastos.isEmpty)
            const _TextoVazio('Nenhuma despesa registrada ainda. Toque em "Despesa" para começar.')
          else
            ...categoriasOrdenadas.map(
              (e) => _CategoriaBar(
                nome: e.key,
                valor: e.value,
                total: maiorGasto,
                cor: categoriaCores[e.key] ?? Colors.grey,
              ),
            ),
          const SizedBox(height: 16),
          const TituloSecao('Movimentações recentes'),
          if (movimentos.isEmpty)
            const _TextoVazio('Nenhuma movimentação ainda.')
          else
            ...movimentos.map((m) => _MovimentoTile(movimento: m)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PendenciasSplit extends StatelessWidget {
  final double voceDeve;
  final double teDevem;
  final VoidCallback onTap;

  const _PendenciasSplit({required this.voceDeve, required this.teDevem, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final semPendencias = voceDeve == 0 && teDevem == 0;
    return PoupCard(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.call_split, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Pendências de split',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 10),
              if (semPendencias)
                const Text(
                  'Nenhuma pendência nos seus grupos.',
                  style: TextStyle(fontSize: 14, color: PoupAiColors.textoCardSecundario),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _PendenciaValor(
                        rotulo: 'Você deve',
                        valor: voceDeve,
                        cor: PoupAiColors.negativo,
                      ),
                    ),
                    Expanded(
                      child: _PendenciaValor(
                        rotulo: 'Te devem',
                        valor: teDevem,
                        cor: PoupAiColors.positivo,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendenciaValor extends StatelessWidget {
  final String rotulo;
  final double valor;
  final Color cor;

  const _PendenciaValor({required this.rotulo, required this.valor, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(rotulo, style: const TextStyle(fontSize: 13, color: PoupAiColors.textoCardSecundario)),
        const SizedBox(height: 2),
        Text(
          formatarMoeda(valor),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: cor),
        ),
      ],
    );
  }
}

class _TextoVazio extends StatelessWidget {
  final String texto;

  const _TextoVazio(this.texto);

  @override
  Widget build(BuildContext context) {
    final p = PoupAiPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: TextStyle(fontSize: 15, height: 1.4, color: p.textoSuave),
      ),
    );
  }
}

class _AcaoRapida extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AcaoRapida({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PoupCard(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Column(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: PoupAiColors.azulEscuro,
                child: Icon(icon, color: PoupAiColors.dourado),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriaBar extends StatelessWidget {
  final String nome;
  final double valor;
  final double total;
  final Color cor;

  const _CategoriaBar({required this.nome, required this.valor, required this.total, required this.cor});

  @override
  Widget build(BuildContext context) {
    final p = PoupAiPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(nome, style: TextStyle(fontSize: 15, color: p.texto)),
              Text(
                formatarMoeda(valor),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: p.texto),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: valor / total,
              minHeight: 8,
              color: cor,
              backgroundColor: p.trilha,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovimentoTile extends StatelessWidget {
  final Movimento movimento;

  const _MovimentoTile({required this.movimento});

  @override
  Widget build(BuildContext context) {
    final receita = movimento.isReceita;
    return PoupCard(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: PoupAiColors.azulEscuro,
          child: Icon(movimento.icon, size: 20, color: PoupAiColors.dourado),
        ),
        title: Text(
          movimento.descricao,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          receita ? 'Receita' : (movimento.categoria ?? 'Despesa'),
          style: const TextStyle(color: PoupAiColors.textoCardSecundario),
        ),
        trailing: Text(
          '${receita ? '+' : '-'} ${formatarMoeda(movimento.valor.abs())}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: receita ? PoupAiColors.positivo : PoupAiColors.negativo,
          ),
        ),
      ),
    );
  }
}
