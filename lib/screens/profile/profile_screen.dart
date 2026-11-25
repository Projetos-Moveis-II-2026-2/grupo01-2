import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/activity_record.dart';
import '../../models/app_avatar.dart';
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
                      _AvatarButton(
                        avatarId: profile.avatarId,
                        onTap: () =>
                            _showAvatarPicker(context, profile.avatarId),
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
                _TokenBalanceCard(balance: progress.tokenBalance),
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
            Text(
              '${progress.completedActivityTypes} de '
              '${progress.totalActivityTypes} atividades diferentes concluídas',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            _ModuleProgress(
              label: 'Matemática',
              completed: progress.completedMathTypes,
              total: UserProgressProvider.mathActivityIds.length,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            _ModuleProgress(
              label: 'Mercadinho',
              completed: progress.completedChoiceTypes,
              total: UserProgressProvider.choiceActivityIds.length,
              color: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleProgress extends StatelessWidget {
  final String label;
  final int completed;
  final int total;
  final Color color;

  const _ModuleProgress({
    required this.label,
    required this.completed,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final value = total == 0 ? 0.0 : (completed / total).clamp(0.0, 1.0);
    return Semantics(
      label: '$label: $completed de $total atividades concluídas',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Text('$completed/$total'),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: value,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: color.withValues(alpha: 0.18),
            color: color,
          ),
        ],
      ),
    );
  }
}

/// Saldo em destaque; pontos e fichas são indicadores diferentes.
class _TokenBalanceCard extends StatelessWidget {
  final int balance;

  const _TokenBalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.reward.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.reward),
      ),
      child: Row(
        children: [
          const Icon(Icons.toll_rounded,
              size: 42, color: AppColors.textPrimary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minhas fichas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  '$balance ${balance == 1 ? 'ficha' : 'fichas'}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Ganhe uma por acerto em Matemática. '
                  'Use suas fichas para liberar situações no Mercadinho.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
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
    final dateLabel = '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: record.activityId.startsWith('choice')
              ? AppColors.secondaryLight
              : AppColors.primaryLight,
          child: Icon(
            record.activityId.startsWith('choice')
                ? Icons.shopping_basket_outlined
                : Icons.calculate_outlined,
            color: record.activityId.startsWith('choice')
                ? AppColors.secondary
                : AppColors.primary,
          ),
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

class _AvatarButton extends StatelessWidget {
  final String avatarId;
  final VoidCallback onTap;

  const _AvatarButton({required this.avatarId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final avatar = AppAvatar.byId(avatarId);

    return Semantics(
      button: true,
      label: 'Avatar ${avatar.name}. Alterar foto de perfil',
      child: Tooltip(
        message: 'Alterar foto de perfil',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 46,
                backgroundColor: avatar.backgroundColor,
                child: Text(
                  avatar.emoji,
                  style: const TextStyle(fontSize: 44),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2.5),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 16,
                    color: AppColors.surface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showAvatarPicker(BuildContext context, String currentId) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Escolha sua foto de perfil',
                style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Toque em um personagem para atualizar seu perfil.',
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: AppAvatar.all.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (_, index) {
                    final avatar = AppAvatar.all[index];
                    final isSelected = avatar.id == currentId;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        context
                            .read<UserProgressProvider>()
                            .updateAvatar(avatar.id);
                        Navigator.of(sheetContext).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: avatar.backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              avatar.emoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              avatar.name,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
