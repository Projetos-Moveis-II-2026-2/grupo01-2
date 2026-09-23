import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/auth_page_layout.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import 'home_shell.dart';
import 'login_screen.dart';

/// Cadastro mockado. Os campos e a validação continuam locais, sem backend.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() != true) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  Future<void> _pickBirthDate() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      initialDate: DateTime(2015),
      helpText: 'Escolha a data de aniversário',
    );
    if (selected == null || !mounted) return;
    _birthDateController.text =
        '${selected.day.toString().padLeft(2, '0')}/'
        '${selected.month.toString().padLeft(2, '0')}/'
        '${selected.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      signupPanel: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Criar uma Nova Conta',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.honeyDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 50,
                    height: 1.05,
                  ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              child: const Text('Já tem uma conta? Entre aqui'),
            ),
            const SizedBox(height: 38),
            AuthTextField(
              controller: _nameController,
              label: 'Nome',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe seu nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            AuthTextField(
              controller: _emailController,
              label: 'E-mail',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Informe um e-mail válido';
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
                if (value == null || value.length < 4) {
                  return 'A senha deve ter ao menos 4 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            AuthTextField(
              controller: _birthDateController,
              label: 'Data de aniversário',
              readOnly: true,
              onTap: _pickBirthDate,
              hintText: 'selecione',
              suffixIcon: const Icon(Icons.expand_more_rounded),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe sua data de aniversário';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              label: 'Inscrever-se',
              onPressed: _handleSignUp,
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              borderRadius: 11,
            ),
          ],
        ),
      ),
    );
  }
}
