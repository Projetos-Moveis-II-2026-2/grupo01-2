/// Níveis de dificuldade das atividades do MercaMática.
enum Difficulty { easy, medium, hard }

extension DifficultyLabel on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'Fácil';
      case Difficulty.medium:
        return 'Médio';
      case Difficulty.hard:
        return 'Difícil';
    }
  }

  String get description {
    switch (this) {
      case Difficulty.easy:
        return 'Valores pequenos, até R\$ 10';
      case Difficulty.medium:
        return 'Valores maiores, até R\$ 50';
      case Difficulty.hard:
        return 'Valores grandes e planejamento de orçamento';
    }
  }

  /// Cor associada ao nível de dificuldade.
  int get colorValue {
    switch (this) {
      case Difficulty.easy:
        return 0xFF67A96B; // primary green
      case Difficulty.medium:
        return 0xFFF3C75F; // reward yellow
      case Difficulty.hard:
        return 0xFFE89A55; // accent orange
    }
  }
}
