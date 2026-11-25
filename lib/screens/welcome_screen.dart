import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import 'home_shell.dart';

/// Tela de boas-vindas. O aplicativo usa um perfil local único, então a
/// pessoa pode começar sem criar conta ou entrar com credenciais.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/mercadinho_ilustracao_paleta.png',
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Começar a praticar',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeShell()),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
