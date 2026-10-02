import 'package:flutter/material.dart';
import '../models/grupo.dart';

class NovaDespesaGrupoScreen extends StatefulWidget {
  final List<String> membros;

  const NovaDespesaGrupoScreen({super.key, required this.membros});

  @override
  State<NovaDespesaGrupoScreen> createState() => _NovaDespesaGrupoScreenState();
}

class _NovaDespesaGrupoScreenState extends State<NovaDespesaGrupoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  String? _pagoPor;

  @override
  void initState() {
    super.initState();
    _pagoPor = widget.membros.isNotEmpty ? widget.membros.first : null;
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final despesa = DespesaGrupo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      descricao: _descricaoController.text.trim(),
      valor: double.parse(_valorController.text.replaceAll(',', '.')),
      pagoPor: _pagoPor!,
    );

    Navigator.pop(context, despesa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova despesa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _descricaoController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Descrição', hintText: 'Ex.: Mercado, aluguel, Uber'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe uma descrição' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor total', prefixText: 'R\$ ', hintText: '0,00'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Informe um valor';
                final numero = double.tryParse(v.replaceAll(',', '.'));
                if (numero == null || numero <= 0) return 'Valor inválido';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _pagoPor,
              decoration: const InputDecoration(labelText: 'Quem pagou'),
              items: widget.membros
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) => setState(() => _pagoPor = v),
              validator: (v) => v == null ? 'Selecione quem pagou' : null,
            ),
            const SizedBox(height: 8),
            Text(
              'O valor é dividido igualmente entre os ${widget.membros.length} integrantes.',
              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _salvar,
              child: const Text('Salvar despesa'),
            ),
          ],
        ),
      ),
    );
  }
}
