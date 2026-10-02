import 'package:flutter/material.dart';
import '../models/meta.dart';

class NovaMetaScreen extends StatefulWidget {
  const NovaMetaScreen({super.key});

  @override
  State<NovaMetaScreen> createState() => _NovaMetaScreenState();
}

class _NovaMetaScreenState extends State<NovaMetaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _valorController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final meta = Meta(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _nomeController.text.trim(),
      valorAtual: 0,
      valorAlvo: double.parse(_valorController.text.replaceAll(',', '.')),
    );

    Navigator.pop(context, meta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova meta')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Nome da meta', hintText: 'Ex.: Viagem de formatura'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe um nome' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Quanto você quer juntar?', prefixText: 'R\$ ', hintText: '0,00'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Informe um valor';
                final numero = double.tryParse(v.replaceAll(',', '.'));
                if (numero == null || numero <= 0) return 'Valor inválido';
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _salvar,
              child: const Text('Salvar meta'),
            ),
          ],
        ),
      ),
    );
  }
}
