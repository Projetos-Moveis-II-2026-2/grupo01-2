import 'package:flutter/foundation.dart';

import '../data/local_user_storage.dart';
import '../models/activity_record.dart';
import '../models/user_profile.dart';

/// Estado global do usuário único e dos resultados das atividades.
class UserProgressProvider extends ChangeNotifier {
  static const independentAnswerPoints = 10;
  static const assistedAnswerPoints = 5;

  static const activityIds = <String>{
    'addition',
    'subtraction',
    'choice_price_note',
    'choice_gift',
    'choice_promotion',
    'choice_month_end',
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
