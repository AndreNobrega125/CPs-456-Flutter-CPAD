import 'package:flutter/material.dart';
import '../models/grupo.dart';

class NovoGrupoScreen extends StatefulWidget {
  const NovoGrupoScreen({super.key});

  @override
  State<NovoGrupoScreen> createState() => _NovoGrupoScreenState();
}

class _NovoGrupoScreenState extends State<NovoGrupoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _membroController = TextEditingController();
  final List<String> _membros = ['Você'];

  @override
  void dispose() {
    _nomeController.dispose();
    _membroController.dispose();
    super.dispose();
  }

  void _adicionarMembro() {
    final nome = _membroController.text.trim();
    if (nome.isEmpty || _membros.contains(nome)) return;
    setState(() {
      _membros.add(nome);
      _membroController.clear();
    });
  }

  void _removerMembro(String nome) {
    if (nome == 'Você') return;
    setState(() => _membros.remove(nome));
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    if (_membros.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos mais um integrante')),
      );
      return;
    }

    final grupo = Grupo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _nomeController.text.trim(),
      membros: List.of(_membros),
    );

    Navigator.pop(context, grupo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo grupo')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Nome do grupo', hintText: 'Ex.: Apê 302'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe um nome' : null,
            ),
            const SizedBox(height: 20),
            const Text('Integrantes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              'Você já está no grupo. Digite o nome de cada colega e toque em +.',
              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _membros
                  .map((m) => Chip(
                        label: Text(m),
                        onDeleted: m == 'Você' ? null : () => _removerMembro(m),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _membroController,
                    decoration: const InputDecoration(labelText: 'Nome do integrante'),
                    onSubmitted: (_) => _adicionarMembro(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _adicionarMembro,
                  icon: const Icon(Icons.add),
                  tooltip: 'Adicionar integrante',
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _salvar,
              child: const Text('Criar grupo'),
            ),
          ],
        ),
      ),
    );
  }
}
