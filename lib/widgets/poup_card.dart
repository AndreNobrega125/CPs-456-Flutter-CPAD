import 'package:flutter/material.dart';
import '../core/theme/app_palette.dart';

// Card claro com texto/ícones escuros garantidos (o tema global é escuro).
class PoupCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;

  const PoupCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.only(bottom: 10),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      clipBehavior: Clip.antiAlias,
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: PoupAiColors.textoCard),
        child: IconTheme.merge(
          data: const IconThemeData(color: PoupAiColors.textoCard),
          child: ListTileTheme(
            textColor: PoupAiColors.textoCard,
            iconColor: PoupAiColors.textoCard,
            child: child,
          ),
        ),
      ),
    );
  }
}
