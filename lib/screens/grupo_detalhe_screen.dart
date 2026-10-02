import 'package:flutter/material.dart';
import '../core/theme/app_palette.dart';
import '../models/grupo.dart';
import '../services/split_service.dart';
import '../utils/formatters.dart';
import '../widgets/estados.dart';
import '../widgets/poup_card.dart';
import 'nova_despesa_grupo_screen.dart';
import 'split_screen.dart' show corDoSaldo;

class GrupoDetalheScreen extends StatefulWidget {
  final Grupo grupo;
  final SplitService service;

  const GrupoDetalheScreen({super.key, required this.grupo, required this.service});

  @override
  State<GrupoDetalheScreen> createState() => _GrupoDetalheScreenState();
}

class _GrupoDetalheScreenState extends State<GrupoDetalheScreen> {
  Future<void> _abrirNovaDespesa() async {
    final despesa = await Navigator.push<DespesaGrupo>(
      context,
      MaterialPageRoute(
        builder: (_) => NovaDespesaGrupoScreen(membros: widget.grupo.membros),
      ),
    );

    if (despesa == null) return;
    if (!mounted) return;

    try {
      await widget.service.adicionarDespesa(widget.grupo.id, despesa);
    } catch (e) {
      debugPrint('Erro ao adicionar despesa: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar a despesa. Verifique sua conexão.')),
      );
      return;
    }
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Despesa adicionada ao grupo')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grupo = widget.grupo;

    return Scaffold(
      appBar: AppBar(title: Text(grupo.nome)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          PoupCard(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seu saldo no grupo',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: PoupAiColors.textoCardSecundario),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    grupo.resumoSaldo,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: corDoSaldo(grupo)),
                  ),
                  if (grupo.despesas.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Total gasto ${formatarMoeda(grupo.totalGasto)} · ${formatarMoeda(grupo.cotaPorPessoa)} por pessoa',
                      style: const TextStyle(fontSize: 14, color: PoupAiColors.textoCardSecundario),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Text(
                    'Integrantes: ${grupo.membros.join(', ')}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const TituloSecao('Despesas do grupo'),
          if (grupo.despesas.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Nenhuma despesa ainda. Toque em "Nova despesa" para registrar a primeira e o app divide o valor entre todos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.4, color: PoupAiPalette.of(context).textoSuave),
              ),
            )
          else
            ...grupo.despesas.reversed.map(
              (d) => PoupCard(
                child: ListTile(
                  title: Text(d.descricao, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    'Pago por ${d.pagoPor}',
                    style: const TextStyle(color: PoupAiColors.textoCardSecundario),
                  ),
                  trailing: Text(
                    formatarMoeda(d.valor),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirNovaDespesa,
        icon: const Icon(Icons.add),
        label: const Text('Nova despesa'),
      ),
    );
  }
}
