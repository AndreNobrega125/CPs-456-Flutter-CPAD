// Formata em reais no padrão brasileiro: R$ 1.234,50
String formatarMoeda(double valor) {
  final negativo = valor < 0;
  final partes = valor.abs().toStringAsFixed(2).split('.');
  final inteiro = partes[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => '.',
  );
  return '${negativo ? '-' : ''}R\$ $inteiro,${partes[1]}';
}
