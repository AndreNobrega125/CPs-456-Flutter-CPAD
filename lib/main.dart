import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/metas_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/split_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // Sem credenciais reais no .env (ou ainda com o texto de exemplo), o Supabase
  // não é inicializado e as telas mostram o erro de conexão com "Tentar de novo".
  final url = dotenv.env['SUPABASE_URL'] ?? '';
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  if (url.isNotEmpty && anonKey.isNotEmpty && !url.contains('SEU-PROJETO')) {
    await Supabase.initialize(url: url, publishableKey: anonKey);
    debugPrint('Supabase inicializado com URL: $url');
  } else {
    debugPrint('Supabase NÃO inicializado — .env vazio ou com placeholder. url="$url"');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema claro e escuro (aula 17): por padrão segue o sistema; o Perfil permite forçar um.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, modo, _) => MaterialApp(
        title: 'PoupAI',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: modo,
        home: const RootNav(),
      ),
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
