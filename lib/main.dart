import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/local_user_storage.dart';
import 'providers/user_progress_provider.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final progressProvider = UserProgressProvider(
    storage: LocalUserStorage(),
  );
  await progressProvider.load();

  runApp(
    ChangeNotifierProvider.value(
      value: progressProvider,
      child: const MercaMaticaApp(),
    ),
  );
}

/// App raiz do Mercadinho Matemático, com perfil local único e sem login.
class MercaMaticaApp extends StatelessWidget {
  const MercaMaticaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MercaMática',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginScreen(),
    );
  }
}
