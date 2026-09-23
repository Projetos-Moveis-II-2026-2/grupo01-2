/// Alternativa de escolha dentro de um cenário de "Escolha Certa".
class ChoiceOption {
  final String label;
  final String feedback;
  /// `null` indica uma escolha sem resposta certa ou errada. Quando definido,
  /// identifica uma alternativa de uma tentativa discreta.
  final bool? isCorrect;

  const ChoiceOption({
    required this.label,
    required this.feedback,
    this.isCorrect,
  });
}

/// Cenário mockado do módulo "Escolha Certa" (educação financeira).
///
/// Os cenários podem ser decisões financeiras sem resposta única ou
/// tentativas discretas com alternativa correta e dica visual.
class ChoiceScenario {
  final String id;
  final String title;
  final String description;
  final List<ChoiceOption> options;
  final String? hint;
  final String? emoji;

  const ChoiceScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.options,
    this.hint,
    this.emoji,
  });

  bool get isDiscreteTrial =>
      options.any((option) => option.isCorrect != null);
}
