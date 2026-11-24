import '../models/choice_scenario.dart';
import '../models/difficulty.dart';
import '../models/math_question.dart';
import '../models/user_profile.dart';

/// Todos os dados desta etapa são mockados (nenhuma chamada de rede ou
/// banco de dados), conforme solicitado para o primeiro protótipo
/// navegável do MercaMática.
class MockData {
  MockData._();

  static const UserProfile profile = UserProfile(
    name: 'Estudante',
  );

  // ─────────────────────────────────────────────────────
  //  ADIÇÃO — Fácil
  // ─────────────────────────────────────────────────────
  static const List<MathQuestion> additionEasy = [
    MathQuestion(
      prompt: 'Você comprou 3 maçãs a R\$ 2 cada.\nQuanto você vai pagar no total?',
      hint: 'Dica: 2 + 2 + 2',
      options: [5, 6, 7, 8],
      correctAnswer: 6,
      difficulty: Difficulty.easy,
    ),
    MathQuestion(
      prompt: 'No mercadinho, um suco custa R\$ 4 e um pão custa R\$ 3.\nQual o valor total da compra?',
      hint: 'Dica: 4 + 3',
      options: [6, 7, 8, 9],
      correctAnswer: 7,
      difficulty: Difficulty.easy,
    ),
    MathQuestion(
      prompt: 'Uma banana custa R\$ 1 e um iogurte custa R\$ 2.\nQuanto você vai pagar?',
      hint: 'Dica: 1 + 2',
      options: [2, 3, 4, 5],
      correctAnswer: 3,
      difficulty: Difficulty.easy,
    ),
    MathQuestion(
      prompt: 'Você comprou 2 pirulitos de R\$ 1 cada.\nQuanto custou?',
      hint: 'Dica: 1 + 1',
      options: [1, 2, 3, 4],
      correctAnswer: 2,
      difficulty: Difficulty.easy,
    ),
  ];

  // ─────────────────────────────────────────────────────
  //  ADIÇÃO — Médio
  // ─────────────────────────────────────────────────────
  static const List<MathQuestion> additionMedium = [
    MathQuestion(
      prompt: 'Você levou 2 pacotes de biscoito (R\$ 5 cada) e 1 chocolate (R\$ 4).\nQuanto custou a compra?',
      hint: 'Dica: 5 + 5 + 4',
      options: [12, 13, 14, 15],
      correctAnswer: 14,
      difficulty: Difficulty.medium,
    ),
    MathQuestion(
      prompt: 'Sua compra deu R\$ 10 e você ainda comprou um item de R\$ 5.\nQual o novo total?',
      hint: 'Dica: 10 + 5',
      options: [13, 14, 15, 16],
      correctAnswer: 15,
      difficulty: Difficulty.medium,
    ),
    MathQuestion(
      prompt: 'No mercado, você comprou arroz por R\$ 12 e feijão por R\$ 8.\nQuanto gastou?',
      hint: 'Dica: 12 + 8',
      options: [18, 19, 20, 21],
      correctAnswer: 20,
      difficulty: Difficulty.medium,
    ),
    MathQuestion(
      prompt: 'Um pacote de macarrão custa R\$ 7 e o molho custa R\$ 6.\nQual o total?',
      hint: 'Dica: 7 + 6',
      options: [11, 12, 13, 14],
      correctAnswer: 13,
      difficulty: Difficulty.medium,
    ),
  ];

  // ─────────────────────────────────────────────────────
  //  ADIÇÃO — Difícil
  // ─────────────────────────────────────────────────────
  static const List<MathQuestion> additionHard = [
    MathQuestion(
      prompt: 'Você comprou um brinquedo de R\$ 35 e um livro de R\$ 28.\nQuanto gastou ao todo?',
      hint: 'Dica: 35 + 28',
      options: [53, 58, 63, 68],
      correctAnswer: 63,
      difficulty: Difficulty.hard,
    ),
    MathQuestion(
      prompt: 'No supermercado, a compra da semana deu R\$ 47 e você adicionou itens de R\$ 25.\nQual o total?',
      hint: 'Dica: 47 + 25',
      options: [62, 67, 72, 77],
      correctAnswer: 72,
      difficulty: Difficulty.hard,
    ),
    MathQuestion(
      prompt: 'Um presente custa R\$ 56 e o papel de embrulho custa R\$ 8.\nQuanto você vai gastar?',
      hint: 'Dica: 56 + 8',
      options: [60, 62, 64, 66],
      correctAnswer: 64,
      difficulty: Difficulty.hard,
    ),
    MathQuestion(
      prompt: 'Você juntou R\$ 38 de mesada com R\$ 45 que ganhou de presente.\nQuanto tem agora?',
      hint: 'Dica: 38 + 45',
      options: [73, 78, 83, 88],
      correctAnswer: 83,
      difficulty: Difficulty.hard,
    ),
  ];

  // ─────────────────────────────────────────────────────
  //  SUBTRAÇÃO — Fácil
  // ─────────────────────────────────────────────────────
  static const List<MathQuestion> subtractionEasy = [
    MathQuestion(
      prompt: 'Você pagou com uma nota de R\$ 10 uma compra de R\$ 7.\nQuanto de troco você recebe?',
      hint: 'Dica: 10 - 7',
      options: [2, 3, 4, 5],
      correctAnswer: 3,
      difficulty: Difficulty.easy,
    ),
    MathQuestion(
      prompt: 'Você tinha R\$ 5 e gastou R\$ 2 em um doce.\nQuanto sobrou?',
      hint: 'Dica: 5 - 2',
      options: [1, 2, 3, 4],
      correctAnswer: 3,
      difficulty: Difficulty.easy,
    ),
    MathQuestion(
      prompt: 'Uma fruta custava R\$ 6, mas está com desconto de R\$ 2.\nQual o novo preço?',
      hint: 'Dica: 6 - 2',
      options: [2, 3, 4, 5],
      correctAnswer: 4,
      difficulty: Difficulty.easy,
    ),
    MathQuestion(
      prompt: 'Você tinha R\$ 8 e comprou um suco de R\$ 3.\nQuanto ficou?',
      hint: 'Dica: 8 - 3',
      options: [3, 4, 5, 6],
      correctAnswer: 5,
      difficulty: Difficulty.easy,
    ),
  ];

  // ─────────────────────────────────────────────────────
  //  SUBTRAÇÃO — Médio
  // ─────────────────────────────────────────────────────
  static const List<MathQuestion> subtractionMedium = [
    MathQuestion(
      prompt: 'Você tinha R\$ 20 e gastou R\$ 12 no mercadinho.\nQuanto sobrou?',
      hint: 'Dica: 20 - 12',
      options: [6, 7, 8, 9],
      correctAnswer: 8,
      difficulty: Difficulty.medium,
    ),
    MathQuestion(
      prompt: 'Você pagou R\$ 20 por uma compra de R\$ 13.\nQuanto de troco?',
      hint: 'Dica: 20 - 13',
      options: [5, 6, 7, 8],
      correctAnswer: 7,
      difficulty: Difficulty.medium,
    ),
    MathQuestion(
      prompt: 'No cofrinho tinha R\$ 30 e você tirou R\$ 18.\nQuanto ficou?',
      hint: 'Dica: 30 - 18',
      options: [10, 11, 12, 13],
      correctAnswer: 12,
      difficulty: Difficulty.medium,
    ),
    MathQuestion(
      prompt: 'Você tinha R\$ 25 e comprou material escolar de R\$ 16.\nQuanto sobrou?',
      hint: 'Dica: 25 - 16',
      options: [7, 8, 9, 10],
      correctAnswer: 9,
      difficulty: Difficulty.medium,
    ),
  ];

  // ─────────────────────────────────────────────────────
  //  SUBTRAÇÃO — Difícil
  // ─────────────────────────────────────────────────────
  static const List<MathQuestion> subtractionHard = [
    MathQuestion(
      prompt: 'Você pagou R\$ 50 por uma compra de R\$ 34.\nQuanto de troco você deve receber?',
      hint: 'Dica: 50 - 34',
      options: [14, 15, 16, 17],
      correctAnswer: 16,
      difficulty: Difficulty.hard,
    ),
    MathQuestion(
      prompt: 'Sua mesada é de R\$ 80 e você gastou R\$ 47.\nQuanto sobrou?',
      hint: 'Dica: 80 - 47',
      options: [23, 28, 33, 38],
      correctAnswer: 33,
      difficulty: Difficulty.hard,
    ),
    MathQuestion(
      prompt: 'Você tinha R\$ 100 e fez uma compra de R\$ 65.\nQuanto de troco recebeu?',
      hint: 'Dica: 100 - 65',
      options: [25, 30, 35, 40],
      correctAnswer: 35,
      difficulty: Difficulty.hard,
    ),
    MathQuestion(
      prompt: 'No cofrinho tinha R\$ 95 e você usou R\$ 58 para comprar um presente.\nQuanto ficou?',
      hint: 'Dica: 95 - 58',
      options: [32, 37, 42, 47],
      correctAnswer: 37,
      difficulty: Difficulty.hard,
    ),
  ];

  /// Retorna as perguntas de matemática filtradas por operação e dificuldade.
  static List<MathQuestion> mathQuestions(MathOperation operation, Difficulty difficulty) {
    if (operation == MathOperation.addition) {
      switch (difficulty) {
        case Difficulty.easy:
          return additionEasy;
        case Difficulty.medium:
          return additionMedium;
        case Difficulty.hard:
          return additionHard;
      }
    } else {
      switch (difficulty) {
        case Difficulty.easy:
          return subtractionEasy;
        case Difficulty.medium:
          return subtractionMedium;
        case Difficulty.hard:
          return subtractionHard;
      }
    }
  }

  /// Mantém compatibilidade — retorna todas as perguntas de adição.
  static List<MathQuestion> get additionQuestions =>
      [...additionEasy, ...additionMedium, ...additionHard];

  /// Mantém compatibilidade — retorna todas as perguntas de subtração.
  static List<MathQuestion> get subtractionQuestions =>
      [...subtractionEasy, ...subtractionMedium, ...subtractionHard];

  // ─────────────────────────────────────────────────────
  //  ESCOLHA CERTA — Fácil (6 situações)
  // ─────────────────────────────────────────────────────
  static const List<ChoiceScenario> choiceEasy = [
    ChoiceScenario(
      id: 'choice_price_note',
      title: 'Escolha a cédula certa',
      description: 'A maçã custa R\$ 5. Toque na cédula com o mesmo valor.',
      emoji: '🍎',
      hint: 'Compare os números. A cédula com o valor correspondente está destacada.',
      difficulty: Difficulty.easy,
      options: [
        ChoiceOption(
          label: '💵 Cédula de R\$ 5',
          feedback: 'Isso mesmo! A cédula de R\$ 5 corresponde ao preço da maçã.',
          isCorrect: true,
        ),
        ChoiceOption(
          label: '💵 Cédula de R\$ 10',
          feedback: 'Compare o valor da cédula com o preço do produto.',
          isCorrect: false,
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_coin_easy',
      title: 'Duas moedas para o pirulito',
      description: 'O pirulito custa R\$ 2. Com quais moedas você pode pagar?',
      emoji: '🍭',
      hint: 'Dica: 1 + 1 = 2. Pense em duas moedas de R\$ 1.',
      difficulty: Difficulty.easy,
      options: [
        ChoiceOption(
          label: '🪙 Duas moedas de R\$ 1',
          feedback: 'Isso mesmo! Duas moedas de R\$ 1 somam R\$ 2.',
          isCorrect: true,
        ),
        ChoiceOption(
          label: '🪙 Uma moeda de R\$ 1',
          feedback: 'Uma moeda de R\$ 1 ainda não paga o pirulito.',
          isCorrect: false,
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_note_10',
      title: 'Pagando com a cédula de R\$ 10',
      description: 'Um pote de sorvete custa R\$ 10. Qual cédula tem o valor exato para pagar sem precisar de troco?',
      emoji: '🍦',
      hint: 'Procure a nota de R\$ 10.',
      difficulty: Difficulty.easy,
      options: [
        ChoiceOption(
          label: '💵 Cédula de R\$ 10',
          feedback: 'Perfeito! Com a cédula de R\$ 10 você paga o valor exato da compra.',
          isCorrect: true,
        ),
        ChoiceOption(
          label: '💵 Cédula de R\$ 20',
          feedback: 'A nota de R\$ 20 é maior do que o preço, você precisaria de troco.',
          isCorrect: false,
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_coin_bread',
      title: 'Moedinha para o pão',
      description: 'O pão quentinho na padaria custa R\$ 1. Qual moeda você deve entregar ao padeiro?',
      emoji: '🥖',
      hint: 'Procure a moeda que tem o número 1 gravado.',
      difficulty: Difficulty.easy,
      options: [
        ChoiceOption(
          label: '🪙 Moeda de R\$ 1',
          feedback: 'Excelente! A moeda de R\$ 1 paga certinho o seu pão.',
          isCorrect: true,
        ),
        ChoiceOption(
          label: '🪙 Moeda de 50 centavos',
          feedback: '50 centavos é menos do que R\$ 1, ainda faltaria dinheiro!',
          isCorrect: false,
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_two_notes',
      title: 'Juntando duas notas para o gibi',
      description: 'O gibi custa R\$ 4. Você tem duas notas de R\$ 2 no bolso. O que fazer?',
      emoji: '📚',
      hint: 'Lembre-se: 2 + 2 = 4.',
      difficulty: Difficulty.easy,
      options: [
        ChoiceOption(
          label: 'Juntar as duas notas de R\$ 2 para pagar os R\$ 4',
          feedback: 'Muito bem! Somando 2 + 2 você tem exatamente os R\$ 4 do gibi.',
          isCorrect: true,
        ),
        ChoiceOption(
          label: 'Dizer que não dá para comprar porque não tem nota de 4',
          feedback: 'Não existe nota de 4, mas juntando duas notas de 2 dá o valor exato!',
          isCorrect: false,
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_enough_money',
      title: 'O dinheiro dá para comprar?',
      description: 'Você tem uma nota de R\$ 5 e quer comprar um suco de fruta que custa R\$ 3. Seu dinheiro é suficiente?',
      emoji: '🧃',
      hint: 'Pense se 5 é maior que 3.',
      difficulty: Difficulty.easy,
      options: [
        ChoiceOption(
          label: 'Sim, e ainda recebo R\$ 2 de troco!',
          feedback: 'Isso aí! R\$ 5 é maior que R\$ 3, e 5 - 3 = 2 de troco.',
          isCorrect: true,
        ),
        ChoiceOption(
          label: 'Não, 5 é menor que 3',
          feedback: 'Na verdade, R\$ 5 é maior que R\$ 3, então dá e sobra!',
          isCorrect: false,
        ),
      ],
    ),
  ];

  // ─────────────────────────────────────────────────────
  //  ESCOLHA CERTA — Médio (5 situações)
  // ─────────────────────────────────────────────────────
  static const List<ChoiceScenario> choiceMedium = [
    ChoiceScenario(
      id: 'choice_gift',
      title: 'Você ganhou R\$ 20 de presente',
      description: 'O que você prefere fazer com esse dinheiro antes de ir ao mercadinho?',
      emoji: '🎁',
      difficulty: Difficulty.medium,
      options: [
        ChoiceOption(
          label: 'Guardar para comprar algo mais caro depois',
          feedback: 'Você escolheu guardar o dinheiro. Poupar é uma ótima forma de realizar planos maiores!',
        ),
        ChoiceOption(
          label: 'Gastar tudo agora em doces',
          feedback: 'Você escolheu gastar tudo no momento. Lembre-se de que guardar um pouco ajuda no futuro.',
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_promotion',
      title: 'Um brinquedo está em promoção',
      description: 'O brinquedo custa R\$ 15, mas você só precisa mesmo de um lápis de R\$ 3. O que fazer?',
      emoji: '✏️',
      difficulty: Difficulty.medium,
      options: [
        ChoiceOption(
          label: 'Comprar apenas o lápis, que é o necessário',
          feedback: 'Você escolheu comprar só o que precisava. Evitar compras por impulso ajuda a economizar!',
        ),
        ChoiceOption(
          label: 'Comprar o brinquedo também',
          feedback: 'Você comprou o brinquedo. Cuidado com promoções de coisas que você não planejava comprar!',
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_shopping_list',
      title: 'A lista de compras',
      description: 'Você foi ao mercadinho com uma lista de compras para o lanche. No caminho, viu um brinquedo colorido. O que fazer?',
      emoji: '📝',
      difficulty: Difficulty.medium,
      options: [
        ChoiceOption(
          label: 'Seguir a lista primeiro para garantir os itens essenciais',
          feedback: 'Excelente atitude! Seguir a lista evita esquecer o que é importante e gastar à toa.',
        ),
        ChoiceOption(
          label: 'Comprar o brinquedo e deixar faltar o lanche',
          feedback: 'Você priorizou o brinquedo, mas o lanche era a necessidade principal do dia.',
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_compare_brands',
      title: 'Comparando preços no mercado',
      description: 'O achocolatado de marca famosa custa R\$ 9. Outra marca de ótima qualidade custa R\$ 6. Qual escolher?',
      emoji: '🍫',
      difficulty: Difficulty.medium,
      options: [
        ChoiceOption(
          label: 'Levar o de R\$ 6 e guardar os R\$ 3 de economia',
          feedback: 'Ótima decisão! Pesquisar e comparar marcas similares rende uma boa economia.',
        ),
        ChoiceOption(
          label: 'Levar o mais caro apenas pelo desenho da embalagem',
          feedback: 'Você escolheu a embalagem mais cara. Às vezes pagamos mais só pela marca!',
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_change_check',
      title: 'Conferindo o troco',
      description: 'Você pagou R\$ 10 em uma compra de R\$ 8 e o atendente te devolveu R\$ 5 de troco por engano. O que você faz?',
      emoji: '🤝',
      difficulty: Difficulty.medium,
      options: [
        ChoiceOption(
          label: 'Avisar o atendente com honestidade e devolver os R\$ 3 a mais',
          feedback: 'Parabéns pela honestidade! O troco correto era R\$ 2 (10 - 8). Você fez a coisa certa!',
        ),
        ChoiceOption(
          label: 'Ficar em silêncio e guardar o dinheiro a mais',
          feedback: 'A honestidade é fundamental. O atendente teria que pagar essa diferença do próprio bolso.',
        ),
      ],
    ),
  ];

  // ─────────────────────────────────────────────────────
  //  ESCOLHA CERTA — Difícil (5 situações)
  // ─────────────────────────────────────────────────────
  static const List<ChoiceScenario> choiceHard = [
    ChoiceScenario(
      id: 'choice_month_end',
      title: 'Fechando o mês',
      description: 'Sobraram R\$ 5 depois das compras do mercadinho. O que fazer com esse valor?',
      emoji: '🐷',
      difficulty: Difficulty.hard,
      options: [
        ChoiceOption(
          label: 'Colocar no cofrinho para juntar dinheiro',
          feedback: 'Você escolheu guardar no cofrinho. Pequenas economias se transformam em grandes conquistas!',
        ),
        ChoiceOption(
          label: 'Gastar com algo do momento',
          feedback: 'Você escolheu gastar o valor que sobrou.',
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_budget',
      title: 'Planejando as compras da semana',
      description: 'Você tem R\$ 50. O arroz custa R\$ 15, o feijão R\$ 10, o leite R\$ 8 e um jogo R\$ 25. O que você faz?',
      emoji: '🛒',
      difficulty: Difficulty.hard,
      options: [
        ChoiceOption(
          label: 'Comprar arroz, feijão e leite (R\$ 33) e guardar R\$ 17',
          feedback: 'Ótima escolha! Você priorizou o necessário para a família e ainda guardou dinheiro.',
        ),
        ChoiceOption(
          label: 'Comprar tudo e pedir mais R\$ 8 emprestado',
          feedback: 'Cuidado! Gastar mais do que se ganha gera dívidas difíceis de pagar.',
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_saving_goal',
      title: 'Meta do cofrinho para um jogo',
      description: 'Você quer comprar um jogo de R\$ 40 daqui a 2 meses. Ganhou R\$ 10 hoje. Qual a melhor decisão?',
      emoji: '🎯',
      difficulty: Difficulty.hard,
      options: [
        ChoiceOption(
          label: 'Guardar no cofre para atingir a meta dos R\$ 40',
          feedback: 'Excelente! Ter paciência e foco na meta é o segredo de quem sabe cuidar do dinheiro.',
        ),
        ChoiceOption(
          label: 'Gastar em salgadinho agora e desistir do jogo',
          feedback: 'Você escolheu o prazer imediato, mas vai demorar muito mais para conseguir o jogo.',
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_cash_discount',
      title: 'Desconto à vista ou parcelado?',
      description: 'A mochila escolar custa R\$ 60 à vista ou 3 parcelas de R\$ 25 (total R\$ 75). Você tem o valor guardado. O que fazer?',
      emoji: '🎒',
      difficulty: Difficulty.hard,
      options: [
        ChoiceOption(
          label: 'Pagar R\$ 60 à vista e economizar R\$ 15 no total',
          feedback: 'Sensacional! Pagar à vista com desconto é muito mais vantajoso do que pagar juros nas parcelas.',
        ),
        ChoiceOption(
          label: 'Parcelar em 3 vezes e pagar R\$ 75',
          feedback: 'Parcelando você pagaria R\$ 15 mais caro à toa, mesmo já tendo o dinheiro guardado.',
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_snack_vs_cook',
      title: 'Lanche pronto ou preparar em casa?',
      description: 'Um lanche pronto custa R\$ 12 por dia. Comprar os ingredientes no mercadinho custa R\$ 20 e rende para toda a semana (5 dias). O que vale mais a pena?',
      emoji: '🥪',
      difficulty: Difficulty.hard,
      options: [
        ChoiceOption(
          label: 'Comprar os ingredientes no mercado por R\$ 20',
          feedback: 'Excelente raciocínio! O lanche pronto daria R\$ 60 na semana (5 × 12). Comprar os ingredientes economiza R\$ 40!',
        ),
        ChoiceOption(
          label: 'Comprar o lanche pronto todos os dias por R\$ 12',
          feedback: 'Comprando todo dia você gastaria R\$ 60 na semana, o triplo do que preparando em casa.',
        ),
      ],
    ),
  ];

  /// Retorna cenários de escolha filtrados por dificuldade.
  static List<ChoiceScenario> choicesByDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return choiceEasy;
      case Difficulty.medium:
        return choiceMedium;
      case Difficulty.hard:
        return choiceHard;
    }
  }

  /// Mantém compatibilidade — retorna todos os cenários.
  static List<ChoiceScenario> get choiceScenarios =>
      [...choiceEasy, ...choiceMedium, ...choiceHard];
}
