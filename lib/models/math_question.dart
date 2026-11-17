import 'difficulty.dart';

/// Tipos de operação matemática suportados nesta etapa.
enum MathOperation { addition, subtraction }

extension MathOperationLabel on MathOperation {
  String get activityId =>
      this == MathOperation.addition ? 'addition' : 'subtraction';

  String get label {
    switch (this) {
      case MathOperation.addition:
        return 'Adição';
      case MathOperation.subtraction:
        return 'Subtração';
    }
  }

  String get emoji {
    switch (this) {
      case MathOperation.addition:
        return '➕';
      case MathOperation.subtraction:
        return '➖';
    }
  }
}

/// Pergunta mockada de matemática, contextualizada em uma situação de
/// compra/venda (conforme a proposta do Mercadinho Matemático).
class MathQuestion {
  final String prompt;
  final String hint;
  final List<int> options;
  final int correctAnswer;
  final Difficulty difficulty;

  const MathQuestion({
    required this.prompt,
    required this.hint,
    required this.options,
    required this.correctAnswer,
    this.difficulty = Difficulty.easy,
  });
}
