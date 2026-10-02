import 'package:flutter/material.dart';
import '../models/movimento.dart';

class NovaMovimentacaoScreen extends StatefulWidget {
  final bool isDespesa;

  const NovaMovimentacaoScreen({super.key, required this.isDespesa});

  @override
  State<NovaMovimentacaoScreen> createState() => _NovaMovimentacaoScreenState();
}

class _NovaMovimentacaoScreenState extends State<NovaMovimentacaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  String? _categoria;

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final valorNumerico = double.parse(_valorController.text.replaceAll(',', '.'));
    final valorComSinal = widget.isDespesa ? -valorNumerico.abs() : valorNumerico.abs();

    final movimento = Movimento(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      descricao: _descricaoController.text.trim(),
      valor: valorComSinal,
      categoria: widget.isDespesa ? _categoria : null,
      icon: widget.isDespesa
          ? (categoriasDespesa[_categoria] ?? Icons.more_horiz)
          : Icons.attach_money,
    );

    Navigator.pop(context, movimento);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isDespesa ? 'Nova despesa' : 'Nova receita')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _descricaoController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Descrição',
                hintText: widget.isDespesa ? 'Ex.: Almoço no bandejão' : 'Ex.: Mesada, estágio',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe uma descrição' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor', prefixText: 'R\$ ', hintText: '0,00'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Informe um valor';
                final numero = double.tryParse(v.replaceAll(',', '.'));
                if (numero == null || numero <= 0) return 'Valor inválido';
                return null;
              },
            ),
            if (widget.isDespesa) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: categoriasDespesa.keys
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _categoria = v),
                validator: (v) => v == null ? 'Selecione uma categoria' : null,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _salvar,
              child: Text(widget.isDespesa ? 'Salvar despesa' : 'Salvar receita'),
            ),
          ],
        ),
      ),
    );
  }
}
