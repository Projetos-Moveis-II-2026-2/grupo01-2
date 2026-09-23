import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Cabeçalho visual com ilustração e título, reutilizado nas áreas principais.
class AppHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showIllustration;

  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showIllustration = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showIllustration)
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              'assets/images/mercadinho_ilustracao.png',
              height: 132,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _IllustrationPlaceholder(),
            ),
          ),
        if (showIllustration) const SizedBox(height: 22),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                height: 1.05,
              ),
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _IllustrationPlaceholder extends StatelessWidget {
  const _IllustrationPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      color: AppColors.honeyLight,
      alignment: Alignment.center,
      child: const Icon(Icons.storefront, size: 56, color: AppColors.honeyDark),
    );
  }
}
