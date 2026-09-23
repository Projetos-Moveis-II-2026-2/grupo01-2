import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/math_question.dart';
import '../../providers/user_progress_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/stat_badge.dart';
import 'math_exercise_screen.dart';

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
                        color: AppColors.honey,
                      ),
                      const SizedBox(width: 12),
                      StatBadge(
                        icon: Icons.task_alt_rounded,
                        label: 'atividades',
                        value: '${progress.activitiesCompleted}',
                        color: AppColors.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
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
                    onPressed: () => _openExercise(
                      context,
                      MathOperation.addition,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ActivityCard(
                    operation: MathOperation.subtraction,
                    description: 'Calcule trocos e veja quanto ainda sobra.',
                    onPressed: () => _openExercise(
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

  void _openExercise(BuildContext context, MathOperation operation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MathExerciseScreen(operation: operation),
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
        color: AppColors.honeyLight.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.honeyDark),
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
