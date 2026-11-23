import 'package:flutter/material.dart';

import '../models/app_avatar.dart';
import '../theme/app_theme.dart';

/// Feedback acolhedor para a primeira resposta errada de uma pergunta.
/// Se não houve escolha de avatar, utiliza uma lâmpada como padrão.
class MathErrorDialog extends StatelessWidget {
  final AppAvatar? avatar;
  final String hint;

  const MathErrorDialog({
    super.key,
    required this.avatar,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    // Os dados atuais trazem 'Dica: ...'; o próprio cartão já tem esse título.
    final cleanHint = hint.replaceFirst(
      RegExp(r'^Dica:\s*', caseSensitive: false),
      '',
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      backgroundColor: AppColors.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: avatar?.backgroundColor ??
                    AppColors.secondaryLight,
                child: avatar == null
                    ? const Icon(
                        Icons.lightbulb_rounded,
                        color: AppColors.accent,
                        size: 46,
                      )
                    : Text(
                        avatar!.emoji,
                        style: const TextStyle(fontSize: 44),
                      ),
              ),
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Ops! Quase lá!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Vamos tentar mais uma vez? Você consegue!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.35,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tips_and_updates_rounded,
                            color: AppColors.textPrimary),
                        SizedBox(width: 8),
                        Text(
                          'DICA',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cleanHint,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Vou tentar de novo!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
