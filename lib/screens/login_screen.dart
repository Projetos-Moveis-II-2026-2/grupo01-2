import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/auth_page_layout.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import 'home_shell.dart';
import 'signup_screen.dart';

/// Tela de login mockada. A validação e a navegação existentes foram mantidas;
/// esta tela apenas recebeu a nova identidade visual.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() != true) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      showIllustration: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Login',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.honeyDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 56,
                    height: 1,
                  ),
            ),
            const SizedBox(height: 22),
            Text(
              'Entre para continuar',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 34),
            AuthTextField(
              controller: _emailController,
              label: 'Usuário',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe seu e-mail ou usuário';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            AuthTextField(
              controller: _passwordController,
              label: 'Senha',
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe sua senha';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              label: 'Log in',
              onPressed: _handleLogin,
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              borderRadius: 11,
            ),
            const SizedBox(height: 74),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Criar uma conta'),
            ),
          ],
        ),
      ),
    );
  }
}
