import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../models/activity_record.dart';
import '../../models/math_question.dart';
import '../../providers/user_progress_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

/// Tela de exercícios de uma operação (Adição ou Subtração).
///
/// Cada questão segue uma tentativa discreta: apresenta o estímulo, recebe
/// uma resposta e mostra uma consequência imediata. Um erro oferece uma
/// dica visual e mantém a questão aberta para nova tentativa.
class MathExerciseScreen extends StatefulWidget {
  final MathOperation operation;

  const MathExerciseScreen({super.key, required this.operation});

  @override
  State<MathExerciseScreen> createState() => _MathExerciseScreenState();
}

class _MathExerciseScreenState extends State<MathExerciseScreen> {
  late final List<MathQuestion> _questions = widget.operation ==
          MathOperation.addition
      ? MockData.additionQuestions
      : MockData.subtractionQuestions;

  int _currentIndex = 0;
  int _correctCount = 0;
  int _independentCorrectAnswers = 0;
  int _assistedCorrectAnswers = 0;
  int _incorrectAttempts = 0;
  bool _answered = false;
  bool _showHint = false;
  bool _usedHint = false;
  bool _activityRecorded = false;

  MathQuestion get _currentQuestion => _questions[_currentIndex];
  bool get _isLastQuestion => _currentIndex == _questions.length - 1;

  void _selectOption(int option) {
    if (_answered) return;
    setState(() {
      if (option == _currentQuestion.correctAnswer) {
        _answered = true;
        _correctCount++;
        if (_usedHint) {
          _assistedCorrectAnswers++;
        } else {
          _independentCorrectAnswers++;
        }
      } else {
        _showHint = true;
        _usedHint = true;
        _incorrectAttempts++;
      }
    });
  }

  Future<void> _nextQuestion() async {
    if (_isLastQuestion) {
      await _showSummary();
      return;
    }
    setState(() {
      _currentIndex++;
      _answered = false;
      _showHint = false;
      _usedHint = false;
    });
  }

  Future<void> _showSummary() async {
    if (!_activityRecorded) {
      _activityRecorded = true;
      final pointsEarned =
          _independentCorrectAnswers *
              UserProgressProvider.independentAnswerPoints +
          _assistedCorrectAnswers * UserProgressProvider.assistedAnswerPoints;

      await context.read<UserProgressProvider>().completeActivity(
            ActivityRecord(
              activityId: widget.operation.activityId,
              activityName: widget.operation.label,
              completedAt: DateTime.now(),
              pointsEarned: pointsEarned,
              independentCorrectAnswers: _independentCorrectAnswers,
              assistedCorrectAnswers: _assistedCorrectAnswers,
              incorrectAttempts: _incorrectAttempts,
            ),
          );
    }
    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Fim da atividade!'),
          content: Text(
            'Você acertou $_correctCount de ${_questions.length} '
            'perguntas de ${widget.operation.label.toLowerCase()}.\n\n'
            'Você ganhou '
            '${_independentCorrectAnswers * UserProgressProvider.independentAnswerPoints + _assistedCorrectAnswers * UserProgressProvider.assistedAnswerPoints} pontos. '
            'Seu progresso foi salvo.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Voltar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _currentIndex = 0;
                  _correctCount = 0;
                  _independentCorrectAnswers = 0;
                  _assistedCorrectAnswers = 0;
                  _incorrectAttempts = 0;
                  _answered = false;
                  _showHint = false;
                  _usedHint = false;
                  _activityRecorded = false;
                });
              },
              child: const Text('Praticar de novo'),
            ),
          ],
        );
      },
    );
  }

  Color? _optionColor(int option) {
    if (_answered && option == _currentQuestion.correctAnswer) {
      return AppColors.success;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.operation.label)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: AppColors.honeyLight,
              color: AppColors.honey,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Text(
              'Pergunta ${_currentIndex + 1} de ${_questions.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _currentQuestion.prompt,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.6,
                children: _currentQuestion.options.map((option) {
                  final color = _optionColor(option);
                  return _OptionButton(
                    value: option,
                    color: color,
                    onTap: _answered ? null : () => _selectOption(option),
                  );
                }).toList(),
              ),
            ),
            if (_showHint || _answered)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ExerciseFeedback(
                  isHint: !_answered,
                  message: _answered
                      ? (_usedHint
                          ? 'Boa! Você encontrou a resposta depois da dica.'
                          : 'Muito bem! Resposta correta.')
                      : '${_currentQuestion.hint}. Tente novamente.',
                ),
              ),
            if (_answered)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PrimaryButton(
                  label: _isLastQuestion ? 'Finalizar' : 'Próxima',
                  onPressed: () => _nextQuestion(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final int value;
  final Color? color;
  final VoidCallback? onTap;

  const _OptionButton({
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final background = color ?? AppColors.card;
    final foreground = color != null ? Colors.white : AppColors.textPrimary;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      elevation: color == null ? 1 : 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color ?? AppColors.honeyDark.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            'R\$ $value',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExerciseFeedback extends StatelessWidget {
  final bool isHint;
  final String message;

  const _ExerciseFeedback({required this.isHint, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isHint ? AppColors.honeyLight : AppColors.success,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(
              isHint ? Icons.lightbulb_outline : Icons.check_circle,
              color: AppColors.bark,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.bark,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
