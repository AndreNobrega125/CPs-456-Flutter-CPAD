import 'package:flutter/material.dart';
import '../core/theme/app_palette.dart';
import '../models/meta.dart';
import '../services/supabase_metas_service.dart';
import '../utils/formatters.dart';
import '../widgets/estados.dart';
import '../widgets/poup_card.dart';
import 'nova_meta_screen.dart';

class MetasScreen extends StatefulWidget {
  const MetasScreen({super.key});

  @override
  State<MetasScreen> createState() => _MetasScreenState();
}

class _MetasScreenState extends State<MetasScreen> {
  final SupabaseMetasService _service = SupabaseMetasService();
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
      await _service.carregar();
    } catch (e) {
      debugPrint('Erro ao carregar metas: $e');
      _erro = 'Não foi possível carregar as metas. Verifique sua conexão.';
    }
    if (!mounted) return;
    setState(() => _carregando = false);
  }

  Future<void> _abrirNovaMeta() async {
    final novaMeta = await Navigator.push<Meta>(
      context,
      MaterialPageRoute(builder: (_) => const NovaMetaScreen()),
    );

    if (novaMeta == null) return;
    if (!mounted) return;

    try {
      await _service.adicionar(novaMeta);
    } catch (e) {
      debugPrint('Erro ao criar meta: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível criar a meta. Verifique sua conexão.')),
      );
      return;
    }
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meta criada')),
    );
  }

  Future<void> _depositar(Meta meta) async {
    final valor = await showDialog<double>(
      context: context,
      builder: (_) => _DialogDeposito(nomeMeta: meta.nome),
    );

    if (valor == null) return;
    if (!mounted) return;

    try {
      await _service.depositar(meta.id, valor);
    } catch (e) {
      debugPrint('Erro ao depositar na meta: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível registrar o depósito. Verifique sua conexão.')),
      );
      return;
    }
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${formatarMoeda(valor)} guardados em "${meta.nome}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: const Text('Metas de economia'));

    if (_carregando) {
      return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
    }

    if (_erro != null) {
      return Scaffold(
        appBar: appBar,
        body: EstadoErro(mensagem: _erro!, onTentarDeNovo: _carregar),
      );
    }

    final metas = _service.listar();

    return Scaffold(
      appBar: appBar,
      body: metas.isEmpty
          ? const EstadoVazio(
              icone: Icons.flag_outlined,
              titulo: 'Nenhuma meta ainda',
              mensagem: 'Crie uma meta, como "Viagem de formatura", e acompanhe quanto falta para chegar lá.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: metas.map((m) => _MetaCard(meta: m, onDepositar: () => _depositar(m))).toList(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirNovaMeta,
        icon: const Icon(Icons.add),
        label: const Text('Nova meta'),
      ),
    );
  }
}

class _DialogDeposito extends StatefulWidget {
  final String nomeMeta;

  const _DialogDeposito({required this.nomeMeta});

  @override
  State<_DialogDeposito> createState() => _DialogDepositoState();
}

class _DialogDepositoState extends State<_DialogDeposito> {
  final _controller = TextEditingController();
  String? _erro;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirmar() {
    final valor = double.tryParse(_controller.text.replaceAll(',', '.'));
    if (valor == null || valor <= 0) {
      setState(() => _erro = 'Informe um valor maior que zero');
      return;
    }
    Navigator.pop(context, valor);
  }

  @override
  Widget build(BuildContext context) {
    final p = PoupAiPalette.of(context);
    return AlertDialog(
      title: Text('Depositar em "${widget.nomeMeta}"'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onSubmitted: (_) => _confirmar(),
        decoration: InputDecoration(
          labelText: 'Quanto você quer guardar?',
          prefixText: 'R\$ ',
          hintText: '0,00',
          errorText: _erro,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: TextStyle(color: p.texto)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(110, 44)),
          onPressed: _confirmar,
          child: const Text('Depositar'),
        ),
      ],
    );
  }
}

class _MetaCard extends StatelessWidget {
  final Meta meta;
  final VoidCallback onDepositar;

  const _MetaCard({required this.meta, required this.onDepositar});

  @override
  Widget build(BuildContext context) {
    final progresso = meta.valorAlvo <= 0 ? 0.0 : (meta.valorAtual / meta.valorAlvo).clamp(0.0, 1.0);
    final faltam = (meta.valorAlvo - meta.valorAtual).clamp(0.0, double.infinity);

    return PoupCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    meta.nome,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '${(progresso * 100).round()}%',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progresso,
                minHeight: 10,
                color: PoupAiColors.azulEscuro,
                backgroundColor: PoupAiColors.azulEscuro.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${formatarMoeda(meta.valorAtual)} de ${formatarMoeda(meta.valorAlvo)}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              faltam == 0 ? 'Meta atingida!' : 'Faltam ${formatarMoeda(faltam)}',
              style: const TextStyle(fontSize: 14, color: PoupAiColors.textoCardSecundario),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                onPressed: onDepositar,
                icon: const Icon(Icons.savings_outlined, size: 18),
                label: const Text('Depositar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
