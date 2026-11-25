import 'package:flutter/material.dart';

import '../models/app_avatar.dart';
import '../theme/app_theme.dart';

/// Feedback de aprendizagem do Mercadinho.
/// Erros objetivos recebem uma dica; decisões abertas recebem uma reflexão.
/// O avatar é opcional: sem escolha, aparece a lâmpada do aplicativo.
class ChoiceLearningDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? pointsLabel;
  final bool isHint;
  final String avatarId;
  final bool avatarChosen;

  const ChoiceLearningDialog({
    super.key,
    required this.title,
    required this.message,
    required this.isHint,
    required this.avatarId,
    required this.avatarChosen,
    this.pointsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = AppAvatar.byId(avatarId);
    final highlightColor =
        isHint ? AppColors.secondaryLight : AppColors.primaryLight;
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        );

    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: avatarChosen ? avatar.backgroundColor : highlightColor,
              shape: BoxShape.circle,
            ),
            child: avatarChosen
                ? Text(avatar.emoji, style: const TextStyle(fontSize: 38))
                : const Icon(Icons.lightbulb_rounded,
                    size: 42, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: titleStyle),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: highlightColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
            ),
          ),
          if (pointsLabel != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded,
                    color: AppColors.textPrimary, size: 20),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    pointsLabel!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(isHint ? 'Vou tentar de novo!' : 'Entendi!'),
          ),
        ),
      ],
    );
  }
}
