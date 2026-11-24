import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mercadinho_matematico/models/activity_record.dart';
import 'package:mercadinho_matematico/models/user_profile.dart';
import 'package:mercadinho_matematico/providers/user_progress_provider.dart';

import 'support/memory_user_storage.dart';

class _FailingStorage extends MemoryUserStorage {
  @override
  Future<void> saveProfile(UserProfile profile) async {
    throw StateError('Falha simulada ao salvar');
  }
}

class _SlowStorage extends MemoryUserStorage {
  final started = Completer<void>();
  final release = Completer<void>();

  @override
  Future<void> saveProfile(UserProfile profile) async {
    started.complete();
    await release.future;
    await super.saveProfile(profile);
  }
}

Future<UserProgressProvider> _progressWithTokens(
  MemoryUserStorage storage, {
  int tokens = 0,
}) async {
  storage.saved = UserProfile.initial.copyWith(tokenBalance: tokens);
  final progress = UserProgressProvider(storage: storage);
  await progress.load();
  return progress;
}

void main() {
  test('perfil antigo não precisa de campo de desbloqueios', () {
    final profile = UserProfile.fromJson({'score': 25, 'tokenBalance': 2});

    expect(profile.score, 25);
    expect(profile.tokenBalance, 2);
    expect(profile.unlockedChoiceIds, isEmpty);
  });

  test('não permite desbloqueio antes do carregamento do perfil', () async {
    final progress = UserProgressProvider(storage: MemoryUserStorage());

    expect(
      await progress.unlockChoice('choice_gift'),
      ChoiceUnlockResult.notReady,
    );
    expect(progress.tokenBalance, 0);
  });

  test('não aceita IDs desconhecidos ou de Matemática', () async {
    final storage = MemoryUserStorage();
    final progress = await _progressWithTokens(storage, tokens: 3);

    expect(
      await progress.unlockChoice('addition_easy'),
      ChoiceUnlockResult.invalidChoice,
    );
    expect(
      await progress.unlockChoice('choice_inexistente'),
      ChoiceUnlockResult.invalidChoice,
    );
    expect(progress.tokenBalance, 3);
    expect(progress.profile.unlockedChoiceIds, isEmpty);
  });

  test('bloqueia compra com zero fichas, sem saldo negativo', () async {
    final storage = MemoryUserStorage();
    final progress = await _progressWithTokens(storage);

    expect(
      await progress.unlockChoice('choice_gift'),
      ChoiceUnlockResult.insufficientTokens,
    );
    expect(progress.tokenBalance, 0);
    expect(progress.isChoiceUnlocked('choice_gift'), isFalse);
    expect(storage.saved!.tokenBalance, 0);
  });

  test('desconta exatamente uma ficha e não altera os pontos', () async {
    final storage = MemoryUserStorage();
    storage.saved = UserProfile.initial.copyWith(score: 45, tokenBalance: 2);
    final progress = UserProgressProvider(storage: storage);
    await progress.load();

    expect(
      await progress.unlockChoice('choice_gift'),
      ChoiceUnlockResult.unlocked,
    );
    expect(progress.tokenBalance, 1);
    expect(progress.profile.score, 45);
    expect(progress.isChoiceUnlocked('choice_gift'), isTrue);
    expect(storage.saved!.tokenBalance, 1);
    expect(storage.saved!.unlockedChoiceIds, contains('choice_gift'));
  });

  test('repetir um cenário desbloqueado não cobra novamente', () async {
    final storage = MemoryUserStorage();
    final progress = await _progressWithTokens(storage, tokens: 2);

    expect(
      await progress.unlockChoice('choice_promotion'),
      ChoiceUnlockResult.unlocked,
    );
    expect(
      await progress.unlockChoice('choice_promotion'),
      ChoiceUnlockResult.alreadyUnlocked,
    );
    expect(progress.tokenBalance, 1);
  });

  test('compras diferentes não podem deixar o saldo negativo', () async {
    final storage = MemoryUserStorage();
    final progress = await _progressWithTokens(storage, tokens: 1);

    expect(
      await progress.unlockChoice('choice_price_note'),
      ChoiceUnlockResult.unlocked,
    );
    expect(
      await progress.unlockChoice('choice_gift'),
      ChoiceUnlockResult.insufficientTokens,
    );
    expect(progress.tokenBalance, 0);
    expect(progress.isChoiceUnlocked('choice_gift'), isFalse);
  });

  test('cenários concluídos antes da atualização já estão liberados', () async {
    final storage = MemoryUserStorage();
    storage.saved = UserProfile.fromJson({
      'tokenBalance': 0,
      'completedActivityIds': ['choice_budget'],
    });
    final progress = UserProgressProvider(storage: storage);
    await progress.load();

    expect(progress.isChoiceUnlocked('choice_budget'), isTrue);
    expect(
      await progress.unlockChoice('choice_budget'),
      ChoiceUnlockResult.alreadyUnlocked,
    );
    expect(progress.tokenBalance, 0);
  });

  test('histórico antigo também preserva desbloqueios', () async {
    final storage = MemoryUserStorage();
    storage.saved = UserProfile.initial.copyWith(
      activityHistory: [
        ActivityRecord(
          activityId: 'choice_coin_easy',
          activityName: 'Situação antiga',
          completedAt: DateTime(2026, 11, 20),
          pointsEarned: 10,
          independentCorrectAnswers: 1,
          assistedCorrectAnswers: 0,
          incorrectAttempts: 0,
        ),
      ],
    );
    final progress = UserProgressProvider(storage: storage);
    await progress.load();

    expect(progress.isChoiceUnlocked('choice_coin_easy'), isTrue);
    expect(
      await progress.unlockChoice('choice_coin_easy'),
      ChoiceUnlockResult.alreadyUnlocked,
    );
  });

  test('desbloqueio persiste ao reiniciar o provider', () async {
    final storage = MemoryUserStorage();
    final first = await _progressWithTokens(storage, tokens: 2);

    expect(
      await first.unlockChoice('choice_saving_goal'),
      ChoiceUnlockResult.unlocked,
    );
    final second = UserProgressProvider(storage: storage);
    await second.load();

    expect(second.tokenBalance, 1);
    expect(second.isChoiceUnlocked('choice_saving_goal'), isTrue);
    expect(
      await second.unlockChoice('choice_saving_goal'),
      ChoiceUnlockResult.alreadyUnlocked,
    );
    expect(second.tokenBalance, 1);
  });

  test('se salvar falhar, não debita nem libera a situação', () async {
    final storage = _FailingStorage();
    final progress = await _progressWithTokens(storage, tokens: 2);

    expect(
      await progress.unlockChoice('choice_gift'),
      ChoiceUnlockResult.saveFailed,
    );
    expect(progress.tokenBalance, 2);
    expect(progress.isChoiceUnlocked('choice_gift'), isFalse);
    expect(storage.saved!.tokenBalance, 2);
    expect(progress.storageMessage, isNotNull);
  });

  test('dois toques durante o salvamento não cobram duas vezes', () async {
    final storage = _SlowStorage();
    final progress = await _progressWithTokens(storage, tokens: 2);

    final first = progress.unlockChoice('choice_gift');
    await storage.started.future;

    expect(progress.isChoiceUnlockInProgress, isTrue);
    expect(
      await progress.unlockChoice('choice_gift'),
      ChoiceUnlockResult.inProgress,
    );
    expect(
      await progress.unlockChoice('choice_promotion'),
      ChoiceUnlockResult.inProgress,
    );

    storage.release.complete();
    expect(await first, ChoiceUnlockResult.unlocked);
    expect(progress.isChoiceUnlockInProgress, isFalse);
    expect(progress.tokenBalance, 1);
    expect(storage.saved!.tokenBalance, 1);
    expect(progress.profile.unlockedChoiceIds, hasLength(1));
  });
}
