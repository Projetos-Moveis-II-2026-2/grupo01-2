import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../models/difficulty.dart';
import '../../providers/user_progress_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/choice_token_banner.dart';
import 'choice_detail_screen.dart';

/// Tela de seleção de dificuldade para o módulo Mercadinho.
class ChoicesDifficultyScreen extends StatelessWidget {
  const ChoicesDifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mercadinho')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Escolha o nível',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecione o nível de desafio para as situações.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              const ChoiceTokenBanner(showDescription: false),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: Difficulty.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final difficulty = Difficulty.values[index];
                    final scenarios =
                        MockData.choicesByDifficulty(difficulty);
                    return _ChoiceDifficultyCard(
                      difficulty: difficulty,
                      scenarioCount: scenarios.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceDifficultyCard extends StatelessWidget {
  final Difficulty difficulty;
  final int scenarioCount;

  const _ChoiceDifficultyCard({
    required this.difficulty,
    required this.scenarioCount,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(difficulty.colorValue);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  _ChoicesByDifficultyScreen(difficulty: difficulty),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 52,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      difficulty.label,
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: color,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$scenarioCount situaç${scenarioCount == 1 ? 'ão' : 'ões'}',
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lista os cenários filtrados por nível de dificuldade.
class _ChoicesByDifficultyScreen extends StatelessWidget {
  final Difficulty difficulty;

  const _ChoicesByDifficultyScreen({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final scenarios = MockData.choicesByDifficulty(difficulty);
    final color = Color(difficulty.colorValue);
    final progress = context.watch<UserProgressProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('${difficulty.label} — Mercadinho')),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: ChoiceTokenBanner(showDescription: false),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: scenarios.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final scenario = scenarios[index];
                  final unlocked = progress.isChoiceUnlocked(scenario.id);
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        // A própria tela de detalhe impede jogar sem desbloquear.
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ChoiceDetailScreen(scenario: scenario),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: color.withValues(alpha: 0.2),
                              child: Text(
                                scenario.emoji ?? '🛒',
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    scenario.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    unlocked
                                        ? 'Desbloqueada • jogar de graça'
                                        : 'Desbloquear por 1 ficha',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: unlocked
                                              ? AppColors.primary
                                              : AppColors.textSecondary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              unlocked
                                  ? Icons.lock_open_rounded
                                  : Icons.lock_outline_rounded,
                              color: unlocked
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ],
                        ),
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
  }
}
