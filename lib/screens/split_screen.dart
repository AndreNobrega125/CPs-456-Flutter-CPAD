import 'package:flutter/material.dart';
import '../core/theme/app_palette.dart';
import '../models/grupo.dart';
import '../services/supabase_split_service.dart';
import '../widgets/estados.dart';
import '../widgets/poup_card.dart';
import 'grupo_detalhe_screen.dart';
import 'novo_grupo_screen.dart';

class SplitScreen extends StatefulWidget {
  const SplitScreen({super.key});

  @override
  State<SplitScreen> createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  final SupabaseSplitService _service = SupabaseSplitService();
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
      debugPrint('Erro ao carregar grupos: $e');
      _erro = 'Não foi possível carregar os grupos. Verifique sua conexão.';
    }
    if (!mounted) return;
    setState(() => _carregando = false);
  }

  Future<void> _abrirNovoGrupo() async {
    final grupo = await Navigator.push<Grupo>(
      context,
      MaterialPageRoute(builder: (_) => const NovoGrupoScreen()),
    );

    if (grupo == null) return;
    if (!mounted) return;

    try {
      await _service.adicionarGrupo(grupo);
    } catch (e) {
      debugPrint('Erro ao criar grupo: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível criar o grupo. Verifique sua conexão.')),
      );
      return;
    }
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grupo criado')),
    );
  }

  Future<void> _abrirGrupo(Grupo grupo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GrupoDetalheScreen(grupo: grupo, service: _service),
      ),
    );
    if (!mounted) return;
    setState(() {}); // refresca o resumo de saldo ao voltar
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: const Text('Dividir contas'));

    if (_carregando) {
      return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
    }

    if (_erro != null) {
      return Scaffold(
        appBar: appBar,
        body: EstadoErro(mensagem: _erro!, onTentarDeNovo: _carregar),
      );
    }

    final grupos = _service.listar();

    return Scaffold(
      appBar: appBar,
      body: grupos.isEmpty
          ? const EstadoVazio(
              icone: Icons.group_outlined,
              titulo: 'Nenhum grupo ainda',
              mensagem: 'Crie um grupo com seus colegas (ex.: "Apê 302") para dividir contas e ver quem deve quanto.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                const TituloSecao('Seus grupos'),
                ...grupos.map((g) => _GrupoCard(grupo: g, onTap: () => _abrirGrupo(g))),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirNovoGrupo,
        icon: const Icon(Icons.add),
        label: const Text('Novo grupo'),
      ),
    );
  }
}

Color corDoSaldo(Grupo grupo) {
  if (grupo.despesas.isEmpty || grupo.saldoVoce.abs() < 0.01) return PoupAiColors.textoCardSecundario;
  return grupo.saldoVoce > 0 ? PoupAiColors.positivo : PoupAiColors.negativo;
}

class _GrupoCard extends StatelessWidget {
  final Grupo grupo;
  final VoidCallback onTap;

  const _GrupoCard({required this.grupo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PoupCard(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: const CircleAvatar(
          backgroundColor: PoupAiColors.azulEscuro,
          child: Icon(Icons.group, color: PoupAiColors.dourado),
        ),
        title: Text(grupo.nome, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        subtitle: Text(
          '${grupo.membros.length} integrantes',
          style: const TextStyle(color: PoupAiColors.textoCardSecundario),
        ),
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 170),
          child: Text(
            grupo.resumoSaldo,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: corDoSaldo(grupo)),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
