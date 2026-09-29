import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/activity_record.dart';
import '../../models/choice_scenario.dart';
import '../../providers/user_progress_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

/// Detalhe de um cenário de "Escolha Certa": apresenta a situação e as
/// alternativas. A primeira atividade usa Tentativa Discreta, com dica
/// visual e nova tentativa em caso de erro.
class ChoiceDetailScreen extends StatefulWidget {
  final ChoiceScenario scenario;

  const ChoiceDetailScreen({super.key, required this.scenario});

  @override
  State<ChoiceDetailScreen> createState() => _ChoiceDetailScreenState();
}

class _ChoiceDetailScreenState extends State<ChoiceDetailScreen> {
  ChoiceOption? _selected;
  bool _showHint = false;
  bool _usedHint = false;
  int _incorrectAttempts = 0;
  int _pointsEarned = 0;
  bool _activityRecorded = false;

  Future<void> _selectOption(ChoiceOption option) async {
    if (_selected != null) return;

    if (widget.scenario.isDiscreteTrial && option.isCorrect != true) {
      setState(() {
        _showHint = true;
        _usedHint = true;
        _incorrectAttempts++;
      });
      return;
    }

    setState(() => _selected = option);
    await _recordActivity();
  }

  Future<void> _recordActivity() async {
    if (_activityRecorded) return;
    _activityRecorded = true;

    final scenario = widget.scenario;
    final independentAnswers =
        scenario.isDiscreteTrial && !_usedHint ? 1 : 0;
    final assistedAnswers = scenario.isDiscreteTrial && _usedHint ? 1 : 0;
    _pointsEarned =
        independentAnswers * UserProgressProvider.independentAnswerPoints +
            assistedAnswers * UserProgressProvider.assistedAnswerPoints;

    await context.read<UserProgressProvider>().completeActivity(
          ActivityRecord(
            activityId: scenario.id,
            activityName: scenario.title,
            completedAt: DateTime.now(),
            pointsEarned: _pointsEarned,
            independentCorrectAnswers: independentAnswers,
            assistedCorrectAnswers: assistedAnswers,
            incorrectAttempts: _incorrectAttempts,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final scenario = widget.scenario;

    return Scaffold(
      appBar: AppBar(title: const Text('Escolha Certa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scenario.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scenario.emoji ?? '🛒',
                      style: const TextStyle(fontSize: 34),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        scenario.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_selected == null) ...[
              Text(
                scenario.isDiscreteTrial
                    ? 'Qual cédula corresponde ao preço?'
                    : 'O que você faria?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ...scenario.options.map((option) => _ChoiceOptionButton(
                    option: option,
                    isDiscreteTrial: scenario.isDiscreteTrial,
                    showHint: _showHint,
                    onPressed: () => _selectOption(option),
                  )),
              if (_showHint) ...[
                const SizedBox(height: 8),
                _FeedbackCard(
                  icon: Icons.lightbulb_outline,
                  message: scenario.hint ??
                      'Observe as opções e tente novamente.',
                  isHint: true,
                ),
              ],
            ] else ...[
              _FeedbackCard(
                icon: Icons.check_circle,
                message: _usedHint
                    ? 'Você conseguiu depois da dica! ${_selected!.feedback} '
                        'Você recebeu $_pointsEarned pontos.'
                    : scenario.isDiscreteTrial
                        ? '${_selected!.feedback} '
                            'Você recebeu $_pointsEarned pontos.'
                        : _selected!.feedback,
                isHint: false,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Voltar para as situações',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChoiceOptionButton extends StatelessWidget {
  final ChoiceOption option;
  final bool isDiscreteTrial;
  final bool showHint;
  final VoidCallback onPressed;

  const _ChoiceOptionButton({
    required this.option,
    required this.isDiscreteTrial,
    required this.showHint,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isHighlighted =
        isDiscreteTrial && showHint && option.isCorrect == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isHighlighted ? AppColors.primaryLight : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isHighlighted
                    ? AppColors.primary
                    : AppColors.border,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isHighlighted) ...[
                  const Icon(Icons.check_circle_outline,
                      color: AppColors.primary),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    option.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool isHint;

  const _FeedbackCard({
    required this.icon,
    required this.message,
    required this.isHint,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isHint ? AppColors.secondaryLight : AppColors.primaryLight,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.textPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
