import 'package:flutter/foundation.dart';

import '../data/local_user_storage.dart';
import '../models/activity_record.dart';
import '../models/user_profile.dart';

/// Resultado de uma tentativa de desbloqueio no Mercadinho.
enum ChoiceUnlockResult {
  unlocked,
  alreadyUnlocked,
  insufficientTokens,
  invalidChoice,
  notReady,
  inProgress,
  saveFailed,
}

/// Estado global do usuário único e dos resultados das atividades.
class UserProgressProvider extends ChangeNotifier {
  static const independentAnswerPoints = 10;
  static const assistedAnswerPoints = 5;
  static const tokensPerMathCorrectAnswer = 1;
  static const choiceUnlockCost = 1;

  /// Apenas Matemática Básica concede fichas nesta etapa.
  static const mathActivityIds = <String>{
    'addition_easy',
    'addition_medium',
    'addition_hard',
    'subtraction_easy',
    'subtraction_medium',
    'subtraction_hard',
  };

  static int tokensEarnedFor(ActivityRecord record) {
    if (!mathActivityIds.contains(record.activityId)) return 0;

    final independent = record.independentCorrectAnswers;
    final assisted = record.assistedCorrectAnswers;
    final correctAnswers =
        (independent > 0 ? independent : 0) + (assisted > 0 ? assisted : 0);
    return correctAnswers * tokensPerMathCorrectAnswer;
  }

  /// Cenários válidos que podem ser desbloqueados mediante fichas.
  static const choiceActivityIds = <String>{
    // Mercadinho — Fácil
    'choice_price_note',
    'choice_coin_easy',
    'choice_note_10',
    'choice_coin_bread',
    'choice_two_notes',
    'choice_enough_money',
    // Mercadinho — Médio
    'choice_gift',
    'choice_promotion',
    'choice_shopping_list',
    'choice_compare_brands',
    'choice_change_check',
    // Mercadinho — Difícil
    'choice_month_end',
    'choice_budget',
    'choice_saving_goal',
    'choice_cash_discount',
    'choice_snack_vs_cook',
  };

  static const activityIds = <String>{
    ...mathActivityIds,
    ...choiceActivityIds,
  };

  final LocalUserStorage _storage;

  UserProfile _profile = UserProfile.initial;
  bool _isReady = false;
  bool _isChoiceUnlockInProgress = false;
  String? _storageMessage;

  UserProgressProvider({required LocalUserStorage storage})
      : _storage = storage;

  UserProfile get profile => _profile;
  bool get isReady => _isReady;
  String? get storageMessage => _storageMessage;
  int get activitiesCompleted => _profile.activitiesCompleted;
  int get tokenBalance => _profile.tokenBalance;
  bool get isChoiceUnlockInProgress => _isChoiceUnlockInProgress;

  /// Situações antigas já concluídas permanecem liberadas sem nova cobrança.
  bool isChoiceUnlocked(String activityId) {
    if (!choiceActivityIds.contains(activityId)) return false;
    return _profile.unlockedChoiceIds.contains(activityId) ||
        _profile.completedActivityIds.contains(activityId) ||
        _profile.activityHistory.any((r) => r.activityId == activityId);
  }

  /// Debita uma única ficha e só libera o cenário se o salvamento funcionar.
  /// A validação e o débito ficam centralizados aqui, não nas telas.
  Future<ChoiceUnlockResult> unlockChoice(String activityId) async {
    if (!choiceActivityIds.contains(activityId)) {
      return ChoiceUnlockResult.invalidChoice;
    }
    if (!_isReady) return ChoiceUnlockResult.notReady;
    if (isChoiceUnlocked(activityId)) {
      return ChoiceUnlockResult.alreadyUnlocked;
    }
    if (_isChoiceUnlockInProgress) {
      return ChoiceUnlockResult.inProgress;
    }
    if (_profile.tokenBalance < choiceUnlockCost) {
      return ChoiceUnlockResult.insufficientTokens;
    }

    _isChoiceUnlockInProgress = true;
    notifyListeners();

    final updated = _profile.copyWith(
      tokenBalance: _profile.tokenBalance - choiceUnlockCost,
      unlockedChoiceIds: {
        ..._profile.unlockedChoiceIds,
        activityId,
      },
    );

    try {
      // Só publica a compra no estado após persistir saldo e desbloqueio juntos.
      await _storage.saveProfile(updated);
      _profile = updated;
      _storageMessage = null;
      return ChoiceUnlockResult.unlocked;
    } catch (_) {
      // O perfil anterior permanece intacto: sem cobrança parcial.
      _storageMessage =
          'Não foi possível salvar o desbloqueio neste dispositivo.';
      return ChoiceUnlockResult.saveFailed;
    } finally {
      _isChoiceUnlockInProgress = false;
      notifyListeners();
    }
  }

  int get completedActivityTypes =>
      _profile.completedActivityIds.where(activityIds.contains).length;
  int get totalActivityTypes => activityIds.length;
  int get independentCorrectAnswers => _profile.independentCorrectAnswers;
  int get assistedCorrectAnswers => _profile.assistedCorrectAnswers;
  int get incorrectAttempts => _profile.incorrectAttempts;

  double get progress => totalActivityTypes == 0
      ? 0
      : (completedActivityTypes / totalActivityTypes)
          .clamp(0.0, 1.0)
          .toDouble();

  int get completedMathTypes =>
      _profile.completedActivityIds.where(mathActivityIds.contains).length;

  int get completedChoiceTypes =>
      _profile.completedActivityIds.where(choiceActivityIds.contains).length;

  Future<void> load() async {
    try {
      _profile = await _storage.loadProfile() ?? UserProfile.initial;
    } catch (_) {
      _profile = UserProfile.initial;
      _storageMessage = 'Não foi possível carregar os dados salvos.';
    }

    _isReady = true;
    notifyListeners();
  }

  Future<void> updateUserName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    _profile = _profile.copyWith(name: trimmed);
    notifyListeners();
    try {
      await _storage.saveProfile(_profile);
    } catch (_) {
      _storageMessage = 'Não foi possível salvar os dados neste dispositivo.';
      notifyListeners();
    }
  }

  Future<void> updateAvatar(String avatarId) async {
    _profile = _profile.copyWith(avatarId: avatarId, avatarChosen: true);
    notifyListeners();
    try {
      await _storage.saveProfile(_profile);
    } catch (_) {
      _storageMessage = 'Não foi possível salvar os dados neste dispositivo.';
      notifyListeners();
    }
  }

  Future<void> completeActivity(ActivityRecord record) async {
    // A mesma conclusão não pode gerar pontos/fichas duas vezes.
    // Repetições legítimas possuem novos horários de conclusão.
    final isDuplicate = _profile.activityHistory.any(
      (previous) =>
          previous.activityId == record.activityId &&
          previous.completedAt.isAtSameMomentAs(record.completedAt),
    );
    if (isDuplicate) return;

    final earnedTokens = tokensEarnedFor(record);
    _profile = _profile.copyWith(
      score: _profile.score + record.pointsEarned,
      tokenBalance: _profile.tokenBalance + earnedTokens,
      activityHistory: [..._profile.activityHistory, record],
      completedActivityIds: {
        ..._profile.completedActivityIds,
        record.activityId,
      },
    );
    _storageMessage = null;
    notifyListeners();

    try {
      await _storage.saveProfile(_profile);
    } catch (_) {
      _storageMessage = 'Não foi possível salvar os dados neste dispositivo.';
      notifyListeners();
    }
  }
}
