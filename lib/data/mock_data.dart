import '../models/choice_scenario.dart';
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

  static const List<MathQuestion> additionQuestions = [
    MathQuestion(
      prompt:
          'Você comprou 3 maçãs a R\$ 2 cada.\nQuanto você vai pagar no total?',
      hint: 'Dica: 2 + 2 + 2',
      options: [5, 6, 7, 8],
      correctAnswer: 6,
    ),
    MathQuestion(
      prompt:
          'No mercadinho, um suco custa R\$ 4 e um pão custa R\$ 3.\nQual o valor total da compra?',
      hint: 'Dica: 4 + 3',
      options: [6, 7, 8, 9],
      correctAnswer: 7,
    ),
    MathQuestion(
      prompt:
          'Você levou 2 pacotes de biscoito (R\$ 5 cada) e 1 chocolate (R\$ 4).\nQuanto custou a compra?',
      hint: 'Dica: 5 + 5 + 4',
      options: [12, 13, 14, 15],
      correctAnswer: 14,
    ),
    MathQuestion(
      prompt:
          'Sua compra deu R\$ 10 e você ainda comprou um item de R\$ 5.\nQual o novo total?',
      hint: 'Dica: 10 + 5',
      options: [13, 14, 15, 16],
      correctAnswer: 15,
    ),
  ];

  static const List<MathQuestion> subtractionQuestions = [
    MathQuestion(
      prompt:
          'Você pagou com uma nota de R\$ 10 uma compra de R\$ 7.\nQuanto de troco você recebe?',
      hint: 'Dica: 10 - 7',
      options: [2, 3, 4, 5],
      correctAnswer: 3,
    ),
    MathQuestion(
      prompt:
          'Você tinha R\$ 20 e gastou R\$ 12 no mercadinho.\nQuanto sobrou?',
      hint: 'Dica: 20 - 12',
      options: [6, 7, 8, 9],
      correctAnswer: 8,
    ),
    MathQuestion(
      prompt:
          'Uma fruta custava R\$ 6, mas está com desconto de R\$ 2.\nQual o novo preço?',
      hint: 'Dica: 6 - 2',
      options: [2, 3, 4, 5],
      correctAnswer: 4,
    ),
    MathQuestion(
      prompt:
          'Você pagou R\$ 50 por uma compra de R\$ 34.\nQuanto de troco você deve receber?',
      hint: 'Dica: 50 - 34',
      options: [14, 15, 16, 17],
      correctAnswer: 16,
    ),
  ];

  static const List<ChoiceScenario> choiceScenarios = [
    ChoiceScenario(
      id: 'choice_price_note',
      title: 'Escolha a cédula certa',
      description:
          'A maçã custa R\$ 5. Toque na cédula com o mesmo valor.',
      emoji: '🍎',
      hint: 'Compare os números. A cédula com o valor correspondente está destacada.',
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
      id: 'choice_gift',
      title: 'Você ganhou R\$ 20 de presente',
      description:
          'O que você prefere fazer com esse dinheiro antes de ir ao mercadinho?',
      options: [
        ChoiceOption(
          label: 'Guardar para comprar algo mais caro depois',
          feedback: 'Você escolheu guardar o dinheiro. Boa forma de planejar!',
        ),
        ChoiceOption(
          label: 'Gastar tudo agora em doces',
          feedback: 'Você escolheu gastar tudo agora.',
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_promotion',
      title: 'Um brinquedo está em promoção',
      description:
          'O brinquedo custa R\$ 15, mas você só precisa mesmo de um lápis de R\$ 3. O que fazer?',
      options: [
        ChoiceOption(
          label: 'Comprar apenas o lápis, que é o necessário',
          feedback:
              'Você escolheu comprar só o que precisava. Isso ajuda a economizar!',
        ),
        ChoiceOption(
          label: 'Comprar o brinquedo também',
          feedback: 'Você escolheu comprar o brinquedo além do lápis.',
        ),
      ],
    ),
    ChoiceScenario(
      id: 'choice_month_end',
      title: 'Fechando o mês',
      description:
          'Sobraram R\$ 5 depois das compras do mercadinho. O que fazer com esse valor?',
      options: [
        ChoiceOption(
          label: 'Colocar no cofrinho para juntar dinheiro',
          feedback: 'Você escolheu guardar no cofrinho.',
        ),
        ChoiceOption(
          label: 'Gastar com algo do momento',
          feedback: 'Você escolheu gastar o valor que sobrou.',
        ),
      ],
    ),
  ];
}
