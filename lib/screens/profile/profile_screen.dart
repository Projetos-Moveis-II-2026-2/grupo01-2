import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/activity_record.dart';
import '../../providers/user_progress_provider.dart';
import '../../theme/app_theme.dart';

/// Perfil e desempenho do usuário local único.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Consumer<UserProgressProvider>(
        builder: (context, progress, _) {
          if (!progress.isReady) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = progress.profile;
          final recentHistory =
              profile.activityHistory.reversed.take(5).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text('Perfil local'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (progress.storageMessage != null) ...[
                  _NoticeCard(message: progress.storageMessage!),
                  const SizedBox(height: 16),
                ],
                _ProgressCard(progress: progress),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = (constraints.maxWidth - 12) / 2;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _StatCard(
                          width: cardWidth,
                          icon: Icons.stars_outlined,
                          label: 'Pontos',
                          value: '${profile.score}',
                        ),
                        _StatCard(
                          width: cardWidth,
                          icon: Icons.task_alt,
                          label: 'Atividades feitas',
                          value: '${progress.activitiesCompleted}',
                        ),
                        _StatCard(
                          width: cardWidth,
                          icon: Icons.flash_on_outlined,
                          label: 'Acertos sem dica',
                          value: '${progress.independentCorrectAnswers}',
                        ),
                        _StatCard(
                          width: cardWidth,
                          icon: Icons.lightbulb_outline,
                          label: 'Acertos com dica',
                          value: '${progress.assistedCorrectAnswers}',
                        ),
                        _StatCard(
                          width: cardWidth,
                          icon: Icons.refresh,
                          label: 'Tentativas com erro',
                          value: '${progress.incorrectAttempts}',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Atividades recentes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (recentHistory.isEmpty)
                  const _NoticeCard(
                    message: 'As atividades concluídas aparecerão aqui.',
                  )
                else
                  ...recentHistory.map(
                    (record) => _ActivityHistoryCard(record: record),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final UserProgressProvider progress;

  const _ProgressCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progresso', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: AppColors.primaryLight,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              '${progress.completedActivityTypes} de '
              '${progress.totalActivityTypes} atividades diferentes concluídas',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityHistoryCard extends StatelessWidget {
  final ActivityRecord record;

  const _ActivityHistoryCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final date = record.completedAt.toLocal();
    final dateLabel =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';

    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.shopping_basket_outlined, color: AppColors.primary),
        ),
        title: Text(record.activityName),
        subtitle: Text(
          '$dateLabel · ${record.independentCorrectAnswers} sem dica · '
          '${record.assistedCorrectAnswers} com dica · '
          '${record.incorrectAttempts} erros',
        ),
        trailing: Text(
          '+${record.pointsEarned}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final String message;

  const _NoticeCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondaryLight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.secondary),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
