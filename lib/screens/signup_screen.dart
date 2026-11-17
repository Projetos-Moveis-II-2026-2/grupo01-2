import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_avatar.dart';
import '../providers/user_progress_provider.dart';
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
  String _selectedAvatarId = 'student';

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
    final provider = context.read<UserProgressProvider>();
    if (_nameController.text.trim().isNotEmpty) {
      provider.updateUserName(_nameController.text);
    }
    provider.updateAvatar(_selectedAvatarId);
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
                    color: AppColors.primary,
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
            const SizedBox(height: 24),
            Text(
              'Escolha seu personagem',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: AppAvatar.all.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final avatar = AppAvatar.all[index];
                  final isSelected = avatar.id == _selectedAvatarId;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedAvatarId = avatar.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: avatar.backgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        avatar.emoji,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 26),
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
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              borderRadius: 11,
            ),
          ],
        ),
      ),
    );
  }
}
