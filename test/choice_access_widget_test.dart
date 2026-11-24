import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mercadinho_matematico/data/mock_data.dart';
import 'package:mercadinho_matematico/models/user_profile.dart';
import 'package:mercadinho_matematico/providers/user_progress_provider.dart';
import 'package:mercadinho_matematico/screens/choices/choice_detail_screen.dart';

import 'support/memory_user_storage.dart';

Future<UserProgressProvider> _providerWithBalance(int balance) async {
  final storage = MemoryUserStorage()
    ..saved = UserProfile.initial.copyWith(tokenBalance: balance);
  final progress = UserProgressProvider(storage: storage);
  await progress.load();
  return progress;
}

Future<void> _showScenario(
  WidgetTester tester,
  UserProgressProvider progress,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: progress,
      child: MaterialApp(
        home: ChoiceDetailScreen(scenario: MockData.choiceMedium.first),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('cenário bloqueado não exibe opções antes da compra',
      (tester) async {
    final progress = await _providerWithBalance(1);
    await _showScenario(tester, progress);

    expect(find.text('O que você faria?'), findsNothing);
    expect(find.text('Jogar por 1 ficha'), findsOneWidget);
    expect(progress.tokenBalance, 1);
  });

  testWidgets('confirmação debita uma ficha e libera as opções',
      (tester) async {
    final progress = await _providerWithBalance(2);
    await _showScenario(tester, progress);

    await tester.tap(find.text('Jogar por 1 ficha'));
    await tester.pumpAndSettle();
    expect(find.text('Vamos jogar?'), findsOneWidget);
    expect(find.text('Custa 1 ficha!'), findsOneWidget);
    expect(find.text('Você tem 2 fichas.'), findsOneWidget);
    expect(progress.tokenBalance, 2);

    await tester.tap(find.text('Usar 1 ficha'));
    await tester.pumpAndSettle();

    expect(progress.tokenBalance, 1);
    expect(progress.isChoiceUnlocked('choice_gift'), isTrue);
    expect(find.text('O que você faria?'), findsOneWidget);
  });

  testWidgets('cancelar confirmação preserva o saldo e o bloqueio',
      (tester) async {
    final progress = await _providerWithBalance(2);
    await _showScenario(tester, progress);

    await tester.tap(find.text('Jogar por 1 ficha'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Agora não'));
    await tester.pumpAndSettle();

    expect(progress.tokenBalance, 2);
    expect(progress.isChoiceUnlocked('choice_gift'), isFalse);
    expect(find.text('O que você faria?'), findsNothing);
  });

  testWidgets('saldo zero oferece voltar para Matemática', (tester) async {
    final progress = await _providerWithBalance(0);
    await _showScenario(tester, progress);

    expect(find.text('Jogar por 1 ficha'), findsNothing);
    expect(find.text('Ganhar fichas na Matemática'), findsOneWidget);
    expect(find.text('O que você faria?'), findsNothing);

    await tester.tap(find.text('Ganhar fichas na Matemática'));
    await tester.pumpAndSettle();
    expect(find.text('Matemática Básica'), findsOneWidget);
  });

  testWidgets('cenário previamente concluído abre sem descontar',
      (tester) async {
    final storage = MemoryUserStorage()
      ..saved = UserProfile.initial.copyWith(
        tokenBalance: 0,
        completedActivityIds: {'choice_gift'},
      );
    final progress = UserProgressProvider(storage: storage);
    await progress.load();
    await _showScenario(tester, progress);

    expect(find.text('O que você faria?'), findsOneWidget);
    expect(progress.tokenBalance, 0);
  });

  testWidgets('escolha financeira mostra reflexão, sem chamar de erro',
      (tester) async {
    final storage = MemoryUserStorage()
      ..saved = UserProfile.initial.copyWith(
        tokenBalance: 0,
        unlockedChoiceIds: {'choice_gift'},
      );
    final progress = UserProgressProvider(storage: storage);
    await progress.load();
    await _showScenario(tester, progress);

    await tester.ensureVisible(find.text('Guardar para comprar algo mais caro depois'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar para comprar algo mais caro depois'));
    await tester.pumpAndSettle();
    expect(find.text('Vamos pensar?'), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_rounded), findsOneWidget);
    expect(find.text('Ops! Tente de novo!'), findsNothing);
    expect(find.text('+10 pontos pela participação'), findsOneWidget);
    expect(progress.tokenBalance, 0);

    await tester.tap(find.text('Entendi!'));
    await tester.pumpAndSettle();
    expect(find.text('Ler explicação de novo'), findsOneWidget);
    await tester.ensureVisible(find.text('Ler explicação de novo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ler explicação de novo'));
    await tester.pumpAndSettle();
    expect(find.text('Vamos pensar?'), findsOneWidget);
    await tester.tap(find.text('Entendi!'));
    await tester.pumpAndSettle();
    expect(progress.profile.score, 10);
  });

  testWidgets('erro objetivo exibe dica e mantém a tentativa',
      (tester) async {
    final scenario = MockData.choiceEasy.first;
    final storage = MemoryUserStorage()
      ..saved = UserProfile.initial.copyWith(
        unlockedChoiceIds: {scenario.id},
      );
    final progress = UserProgressProvider(storage: storage);
    await progress.load();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: progress,
        child: MaterialApp(home: ChoiceDetailScreen(scenario: scenario)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('💵 Cédula de R\$ 10'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('💵 Cédula de R\$ 10'));
    await tester.pumpAndSettle();
    expect(find.text('Ops! Tente de novo!'), findsOneWidget);
    expect(find.text('Vou tentar de novo!'), findsOneWidget);
    expect(progress.profile.score, 0);
    await tester.tap(find.text('Vou tentar de novo!'));
    await tester.pumpAndSettle();
    expect(find.text('Escolha a resposta:'), findsOneWidget);

    await tester.ensureVisible(find.text('💵 Cédula de R\$ 5'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('💵 Cédula de R\$ 5'));
    await tester.pumpAndSettle();
    expect(find.text('Muito bem!'), findsOneWidget);
    expect(find.text('+5 pontos pelo acerto'), findsOneWidget);
    expect(progress.profile.score, 5);
  });

  testWidgets('avatar escolhido aparece no diálogo de reflexão',
      (tester) async {
    final storage = MemoryUserStorage()
      ..saved = UserProfile.initial.copyWith(
        unlockedChoiceIds: {'choice_gift'},
        avatarId: 'fox',
        avatarChosen: true,
      );
    final progress = UserProgressProvider(storage: storage);
    await progress.load();
    await _showScenario(tester, progress);
    await tester.ensureVisible(find.text('Guardar para comprar algo mais caro depois'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar para comprar algo mais caro depois'));
    await tester.pumpAndSettle();

    expect(find.text('Vamos pensar?'), findsOneWidget);
    expect(find.text('🦊'), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_rounded), findsNothing);
  });
}
