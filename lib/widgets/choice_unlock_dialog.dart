import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Confirmação visual do uso de uma ficha.
/// Apenas comunica a escolha: o débito continua no UserProgressProvider.
class ChoiceUnlockDialog extends StatelessWidget {
  final int balance;

  const ChoiceUnlockDialog({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.reward.withValues(alpha: 0.28),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.monetization_on_rounded,
                size: 48, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Text(
            'Vamos jogar?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.reward.withValues(alpha: 0.28),
              border: Border.all(color: AppColors.reward),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Custa 1 ficha!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Você tem $balance ${balance == 1 ? 'ficha' : 'fichas'}.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.lock_open_rounded,
                  color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Depois, jogue de novo sem gastar fichas!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Usar 1 ficha'),
              ),
            ),
            const SizedBox(height: 2),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Agora não'),
            ),
          ],
        ),
      ],
    );
  }
}
