import 'package:flutter_test/flutter_test.dart';
import 'package:mercadinho_matematico/models/activity_record.dart';
import 'package:mercadinho_matematico/models/user_profile.dart';
import 'support/memory_user_storage.dart';
import 'package:mercadinho_matematico/providers/user_progress_provider.dart';

ActivityRecord _activity(
  String id, {
  int independent = 0,
  int assisted = 0,
  int points = 0,
  DateTime? completedAt,
}) {
  return ActivityRecord(
    activityId: id,
    activityName: 'Atividade de teste',
    completedAt: completedAt ?? DateTime(2026, 11, 24),
    pointsEarned: points,
    independentCorrectAnswers: independent,
    assistedCorrectAnswers: assisted,
    incorrectAttempts: 0,
  );
}

void main() {
  test('perfil antigo recebe zero fichas sem perder pontos', () {
    final profile = UserProfile.fromJson({
      'name': 'Estudante',
      'avatarId': 'student',
      'score': 40,
    });

    expect(profile.score, 40);
    expect(profile.tokenBalance, 0);
    expect(profile.toJson()['tokenBalance'], 0);
  });

  test('saldo negativo salvo anteriormente é normalizado para zero', () {
    final profile = UserProfile.fromJson({'tokenBalance': -5});
    expect(profile.tokenBalance, 0);
  });

  test('Matemática concede uma ficha por acerto, com ou sem dica', () async {
    final storage = MemoryUserStorage();
    final progress = UserProgressProvider(storage: storage);
    await progress.load();

    await progress.completeActivity(
      _activity('addition_easy', independent: 3, assisted: 1, points: 35),
    );

    expect(progress.profile.score, 35);
    expect(progress.tokenBalance, 4);
    expect(progress.profile.activityHistory.length, 1);
    expect(storage.saved!.tokenBalance, 4);
  });

  test('Mercadinho não concede fichas nesta etapa', () async {
    final progress = UserProgressProvider(storage: MemoryUserStorage());
    await progress.load();

    await progress.completeActivity(
      _activity('choice_price_note', independent: 1, points: 10),
    );

    expect(progress.profile.score, 10);
    expect(progress.tokenBalance, 0);
  });

  test('repetir atividade matemática concluída concede novas fichas', () async {
    final progress = UserProgressProvider(storage: MemoryUserStorage());
    await progress.load();
    final record = _activity('subtraction_medium', independent: 4, points: 40);

    await progress.completeActivity(record);
    await progress.completeActivity(_activity(
      'subtraction_medium',
      independent: 4,
      points: 40,
      completedAt: DateTime(2026, 11, 24, 0, 1),
    ));

    expect(progress.tokenBalance, 8);
    expect(progress.profile.score, 80);
    expect(progress.completedActivityTypes, 1);
    expect(progress.activitiesCompleted, 2);
  });


  test('a mesma conclusão não pode ser recompensada duas vezes', () async {
    final progress = UserProgressProvider(storage: MemoryUserStorage());
    await progress.load();
    final record = _activity('addition_easy', independent: 4, points: 40);

    await progress.completeActivity(record);
    await progress.completeActivity(record);

    expect(progress.tokenBalance, 4);
    expect(progress.profile.score, 40);
    expect(progress.activitiesCompleted, 1);
  });

  test('saldo persiste ao carregar novamente o perfil', () async {
    final storage = MemoryUserStorage();
    final first = UserProgressProvider(storage: storage);
    await first.load();
    await first.completeActivity(
      _activity('addition_hard', independent: 2, assisted: 2, points: 30),
    );

    final second = UserProgressProvider(storage: storage);
    await second.load();

    expect(second.tokenBalance, 4);
    expect(second.profile.score, 30);
    expect(second.profile.activityHistory.length, 1);
  });
}
