import 'package:flutter/foundation.dart';

import '../data/local_user_storage.dart';
import '../models/activity_record.dart';
import '../models/user_profile.dart';

/// Estado global do usuário único e dos resultados das atividades.
class UserProgressProvider extends ChangeNotifier {
  static const independentAnswerPoints = 10;
  static const assistedAnswerPoints = 5;

  static const activityIds = <String>{
    // Matemática — Adição
    'addition_easy',
    'addition_medium',
    'addition_hard',
    // Matemática — Subtração
    'subtraction_easy',
    'subtraction_medium',
    'subtraction_hard',
    // Escolha Certa — Fácil
    'choice_price_note',
    'choice_coin_easy',
    'choice_note_10',
    'choice_coin_bread',
    'choice_two_notes',
    'choice_enough_money',
    // Escolha Certa — Médio
    'choice_gift',
    'choice_promotion',
    'choice_shopping_list',
    'choice_compare_brands',
    'choice_change_check',
    // Escolha Certa — Difícil
    'choice_month_end',
    'choice_budget',
    'choice_saving_goal',
    'choice_cash_discount',
    'choice_snack_vs_cook',
  };

  final LocalUserStorage _storage;

  UserProfile _profile = UserProfile.initial;
  bool _isReady = false;
  String? _storageMessage;

  UserProgressProvider({required LocalUserStorage storage})
      : _storage = storage;

  UserProfile get profile => _profile;
  bool get isReady => _isReady;
  String? get storageMessage => _storageMessage;
  int get activitiesCompleted => _profile.activitiesCompleted;
  int get completedActivityTypes => _profile.completedActivityIds
      .where(activityIds.contains)
      .length;
  int get totalActivityTypes => activityIds.length;
  int get independentCorrectAnswers => _profile.independentCorrectAnswers;
  int get assistedCorrectAnswers => _profile.assistedCorrectAnswers;
  int get incorrectAttempts => _profile.incorrectAttempts;

  double get progress => totalActivityTypes == 0
      ? 0
      : (completedActivityTypes / totalActivityTypes)
          .clamp(0.0, 1.0)
          .toDouble();

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
    _profile = _profile.copyWith(avatarId: avatarId);
    notifyListeners();
    try {
      await _storage.saveProfile(_profile);
    } catch (_) {
      _storageMessage = 'Não foi possível salvar os dados neste dispositivo.';
      notifyListeners();
    }
  }

  Future<void> completeActivity(ActivityRecord record) async {
    _profile = _profile.copyWith(
      score: _profile.score + record.pointsEarned,
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
