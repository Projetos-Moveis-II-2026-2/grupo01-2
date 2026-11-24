import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/math_question.dart';
import '../../providers/user_progress_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/stat_badge.dart';
import 'difficulty_selection_screen.dart';

/// Tela inicial do módulo Matemática Básica.
class MathHomeScreen extends StatelessWidget {
  const MathHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProgressProvider>(
        builder: (context, progress, _) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(
                    title: 'Matemática Básica',
                    subtitle: 'Vamos treinar um pouquinho?',
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      StatBadge(
                        icon: Icons.star_rounded,
                        label: 'pontos',
                        value: '${progress.profile.score}',
                        color: AppColors.reward,
                      ),
                      const SizedBox(width: 12),
                      StatBadge(
                        icon: Icons.task_alt_rounded,
                        label: 'atividades',
                        value: '${progress.activitiesCompleted}',
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _TokenInfoCard(balance: progress.tokenBalance),
                  const SizedBox(height: 22),
                  Text(
                    'Escolha uma atividade',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ActivityCard(
                    operation: MathOperation.addition,
                    description: 'Junte valores e descubra o total da compra.',
                    onPressed: () => _openDifficultySelection(
                      context,
                      MathOperation.addition,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ActivityCard(
                    operation: MathOperation.subtraction,
                    description: 'Calcule trocos e veja quanto ainda sobra.',
                    onPressed: () => _openDifficultySelection(
                      context,
                      MathOperation.subtraction,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _ProgressHint(progress: progress),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openDifficultySelection(
      BuildContext context, MathOperation operation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DifficultySelectionScreen(operation: operation),
      ),
    );
  }
}

/// Lembra como ganhar fichas e mostra o saldo sem exigir acesso ao Perfil.
class _TokenInfoCard extends StatelessWidget {
  final int balance;

  const _TokenInfoCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.reward.withValues(alpha: 0.22),
        border: Border.all(color: AppColors.reward),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.reward,
            child: Icon(Icons.toll_rounded, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cada acerto vale 1 ficha!',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Conclua a atividade para guardar as fichas. '
                  'Em breve, você poderá usá-las no Mercadinho.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  'Seu saldo: $balance ${balance == 1 ? 'ficha' : 'fichas'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressHint extends StatelessWidget {
  final UserProgressProvider progress;

  const _ProgressHint({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              progress.activitiesCompleted == 0
                  ? 'Faça uma atividade para começar seu progresso.'
                  : 'Você já concluiu ${progress.activitiesCompleted} atividade(s). Continue assim!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
