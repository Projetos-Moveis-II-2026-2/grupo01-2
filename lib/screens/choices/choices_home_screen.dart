import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/choice_scenario.dart';
import '../../theme/app_theme.dart';
import 'choice_detail_screen.dart';

/// Lista de situações mockadas do módulo "Escolha Certa" (educação
/// financeira), conforme a Etapa 1 da proposta.
class ChoicesHomeScreen extends StatelessWidget {
  const ChoicesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const scenarios = MockData.choiceScenarios;

    return Scaffold(
      appBar: AppBar(title: const Text('Escolha Certa')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: scenarios.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final scenario = scenarios[index];
          return _ScenarioCard(
            scenario: scenario,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChoiceDetailScreen(scenario: scenario),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final ChoiceScenario scenario;
  final VoidCallback onTap;

  const _ScenarioCard({required this.scenario, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.honeyLight,
                child: Icon(Icons.savings_outlined, color: AppColors.bark),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  scenario.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
