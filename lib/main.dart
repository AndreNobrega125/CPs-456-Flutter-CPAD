import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/split_screen.dart';
import 'screens/metas_screen.dart';
import 'screens/perfil_screen.dart';

// Paleta oficial do PoupAI
class PoupAiColors {
  static const azulEscuro = Color(0xFF0B1428); // topo/rodapé (AppBar, navegação) — bem mais escuro pra destacar do meio
  static const azulMarinho = Color.fromARGB(255, 17, 27, 49); // acento geral (texto, ícones, FAB)
  static const azulClaro = Color.fromARGB(255, 22, 35, 60); // fundo do meio (conteúdo) — navy forte, mesma família do azulEscuro mas nitidamente mais claro
  static const dourado = Color(0xFFD4A657);
  static const cardClaro = Color.fromARGB(255, 131, 157, 193); // fundo dos cards/botões — azul claro nítido, mesma família do fundo mas com contraste real
  static const branco = Color(0xFFFFFFFF); // textos em cima do azul escuro (títulos de seção, nav)
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoupAI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: PoupAiColors.azulMarinho,
          primary: PoupAiColors.azulMarinho,
          secondary: PoupAiColors.dourado,
          surface: PoupAiColors.cardClaro,
        ),
        scaffoldBackgroundColor: PoupAiColors.azulClaro,
        cardTheme: const CardThemeData(
          color: PoupAiColors.cardClaro,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: PoupAiColors.azulEscuro,
          foregroundColor: PoupAiColors.dourado,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: PoupAiColors.azulEscuro,
          indicatorColor: PoupAiColors.dourado.withValues(alpha: 0.25),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: PoupAiColors.branco, fontSize: 12),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selecionado = states.contains(WidgetState.selected);
            return IconThemeData(color: selecionado ? PoupAiColors.dourado : PoupAiColors.branco.withValues(alpha: 0.6));
          }),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: PoupAiColors.dourado,
          foregroundColor: PoupAiColors.azulMarinho,
        ),
      ),
      home: const RootNav(),
    );
  }
}

class RootNav extends StatefulWidget {
  const RootNav({super.key});

  @override
  State<RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    SplitScreen(),
    MetasScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: 'Carteira'),
          NavigationDestination(icon: Icon(Icons.group), label: 'Split'),
          NavigationDestination(icon: Icon(Icons.flag), label: 'Metas'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
