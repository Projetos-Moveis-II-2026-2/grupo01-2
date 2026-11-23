import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/difficulty.dart';
import '../../theme/app_theme.dart';
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
              const SizedBox(height: 24),
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

    return Scaffold(
      appBar: AppBar(
        title: Text('${difficulty.label} — Mercadinho'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: scenarios.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final scenario = scenarios[index];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ChoiceDetailScreen(scenario: scenario),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        scenario.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
