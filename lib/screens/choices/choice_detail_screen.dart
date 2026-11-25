import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/activity_record.dart';
import '../../models/choice_scenario.dart';
import '../../models/difficulty.dart';
import '../../providers/user_progress_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/choice_token_banner.dart';
import '../../widgets/choice_learning_dialog.dart';
import '../../widgets/choice_unlock_dialog.dart';
import '../math/math_home_screen.dart';

/// Detalhe de um cenário de "Mercadinho": apresenta a situação e as
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
  bool _isUnlocking = false;

  Future<void> _selectOption(ChoiceOption option) async {
    if (_selected != null) return;

    if (widget.scenario.isDiscreteTrial && option.isCorrect != true) {
      setState(() {
        _showHint = true;
        _usedHint = true;
        _incorrectAttempts++;
      });
      await _showLearningDialog(
        title: 'Ops! Tente de novo!',
        message: widget.scenario.hint ?? 'Olhe os valores e tente de novo.',
        isHint: true,
      );
      return;
    }

    setState(() => _selected = option);
    await _recordActivity();
    if (!mounted) return;
    await _showResultDialog(option);
  }

  Future<void> _showLearningDialog({
    required String title,
    required String message,
    bool isHint = false,
    String? pointsLabel,
  }) async {
    if (!mounted) return;
    final profile = context.read<UserProgressProvider>().profile;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ChoiceLearningDialog(
        title: title,
        message: message,
        isHint: isHint,
        avatarId: profile.avatarId,
        avatarChosen: profile.avatarChosen,
        pointsLabel: pointsLabel,
      ),
    );
  }

  Future<void> _showResultDialog(ChoiceOption option) {
    final isObjective = widget.scenario.isDiscreteTrial;
    return _showLearningDialog(
      title: isObjective ? 'Muito bem!' : 'Vamos pensar?',
      message: option.feedback,
      pointsLabel: isObjective
          ? '+$_pointsEarned pontos pelo acerto'
          : '+$_pointsEarned pontos pela participação',
    );
  }

  Future<void> _recordActivity() async {
    if (_activityRecorded) return;
    _activityRecorded = true;

    final scenario = widget.scenario;
    final independentAnswers = scenario.isDiscreteTrial && !_usedHint ? 1 : 0;
    final assistedAnswers = scenario.isDiscreteTrial && _usedHint ? 1 : 0;
    _pointsEarned = scenario.isDiscreteTrial
        ? (independentAnswers * UserProgressProvider.independentAnswerPoints +
            assistedAnswers * UserProgressProvider.assistedAnswerPoints)
        : UserProgressProvider.independentAnswerPoints;

    await context.read<UserProgressProvider>().completeActivity(
          ActivityRecord(
            activityId: scenario.id,
            activityName: '${scenario.title} (${scenario.difficulty.label})',
            completedAt: DateTime.now(),
            pointsEarned: _pointsEarned,
            independentCorrectAnswers: independentAnswers,
            assistedCorrectAnswers: assistedAnswers,
            incorrectAttempts: _incorrectAttempts,
          ),
        );
  }

  /// Confirmar antes de gastar: uma ficha é debitada apenas pelo provider.
  Future<void> _confirmUnlock() async {
    if (_isUnlocking) return;
    final progress = context.read<UserProgressProvider>();
    if (progress.isChoiceUnlocked(widget.scenario.id)) return;
    if (!progress.isReady || progress.isChoiceUnlockInProgress) return;
    if (progress.tokenBalance < UserProgressProvider.choiceUnlockCost) {
      _showUnlockMessage('Você precisa de 1 ficha para desbloquear.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ChoiceUnlockDialog(balance: progress.tokenBalance),
    );
    if (!mounted || confirmed != true) return;

    setState(() => _isUnlocking = true);
    final result = await progress.unlockChoice(widget.scenario.id);
    if (!mounted) return;
    setState(() => _isUnlocking = false);

    switch (result) {
      case ChoiceUnlockResult.unlocked:
        _showUnlockMessage('Situação desbloqueada! Você usou 1 ficha.');
        break;
      case ChoiceUnlockResult.alreadyUnlocked:
        // O Consumer exibirá a atividade sem cobrar novamente.
        break;
      case ChoiceUnlockResult.insufficientTokens:
        _showUnlockMessage('Suas fichas acabaram. Vamos ganhar mais?');
        break;
      case ChoiceUnlockResult.inProgress:
        _showUnlockMessage('Espere a outra compra terminar.');
        break;
      case ChoiceUnlockResult.saveFailed:
        _showUnlockMessage(
          progress.storageMessage ?? 'Não foi possível salvar a compra.',
        );
        break;
      case ChoiceUnlockResult.invalidChoice:
      case ChoiceUnlockResult.notReady:
        _showUnlockMessage('Não foi possível liberar esta situação agora.');
        break;
    }
  }

  void _showUnlockMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Abre Matemática com uma seta visível para voltar ao Mercadinho.
  void _openMathPractice() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Ganhar fichas')),
          body: const MathHomeScreen(),
        ),
      ),
    );
  }

  Widget _buildLockedContent(UserProgressProvider progress) {
    final hasTokens =
        progress.tokenBalance >= UserProgressProvider.choiceUnlockCost;
    final scenario = widget.scenario;
    final canUnlock =
        progress.isReady && !progress.isChoiceUnlockInProgress && !_isUnlocking;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ChoiceTokenBanner(),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text(scenario.emoji ?? '🛒',
                        style: const TextStyle(fontSize: 42)),
                    const SizedBox(height: 8),
                    Text(
                      scenario.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 14),
                    const Icon(Icons.lock_outline_rounded,
                        size: 38, color: AppColors.textSecondary),
                    const SizedBox(height: 8),
                    Text(
                      hasTokens
                          ? 'Esta atividade custa 1 ficha.'
                          : 'Suas fichas acabaram! Que tal praticar Matemática?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Depois, você joga de graça!',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (hasTokens)
              ElevatedButton.icon(
                onPressed: canUnlock ? _confirmUnlock : null,
                icon: const Icon(Icons.monetization_on_rounded),
                label: Text(
                    _isUnlocking ? 'Desbloqueando...' : 'Jogar por 1 ficha'),
              )
            else
              ElevatedButton.icon(
                onPressed: _openMathPractice,
                icon: const Icon(Icons.calculate_rounded),
                label: const Text('Ganhar fichas na Matemática'),
              ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voltar às situações'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scenario = widget.scenario;
    final diffColor = Color(scenario.difficulty.colorValue);
    final progress = context.watch<UserProgressProvider>();
    final isUnlocked = progress.isChoiceUnlocked(scenario.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercadinho'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              label: Text(
                scenario.difficulty.label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: diffColor,
                ),
              ),
              backgroundColor: diffColor.withValues(alpha: 0.15),
              side: BorderSide.none,
            ),
          ),
        ],
      ),
      body: !isUnlocked
          ? _buildLockedContent(progress)
          : SingleChildScrollView(
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
                          ? 'Escolha a resposta:'
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
                      icon: scenario.isDiscreteTrial
                          ? Icons.check_circle_rounded
                          : Icons.menu_book_rounded,
                      message: scenario.isDiscreteTrial
                          ? 'Muito bem! Você ganhou $_pointsEarned pontos.'
                          : 'Escolha registrada! Você ganhou $_pointsEarned pontos por participar.',
                      isHint: false,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _showResultDialog(_selected!),
                      icon: const Icon(Icons.lightbulb_outline_rounded),
                      label: const Text('Ler explicação de novo'),
                    ),
                    const SizedBox(height: 18),
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

    return Semantics(
      button: true,
      label: option.label,
      selected: isHighlighted,
      child: Padding(
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
                  color: isHighlighted ? AppColors.primary : AppColors.border,
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
