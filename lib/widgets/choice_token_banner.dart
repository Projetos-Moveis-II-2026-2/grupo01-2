import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_progress_provider.dart';
import '../theme/app_theme.dart';

/// Saldo compartilhado entre as telas do Mercadinho.
/// O valor vem do provider e é atualizado após cada desbloqueio.
class ChoiceTokenBanner extends StatelessWidget {
  final bool showDescription;

  const ChoiceTokenBanner({super.key, this.showDescription = true});

  @override
  Widget build(BuildContext context) {
    final balance = context.select<UserProgressProvider, int>(
      (progress) => progress.tokenBalance,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.reward.withValues(alpha: 0.26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.reward),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.monetization_on_rounded,
            color: AppColors.textPrimary,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minhas fichas: $balance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                if (showDescription) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Uma ficha libera uma situação. Depois, ela é grátis!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
