import 'activity_record.dart';

/// Perfil local único e seus dados de desempenho.
class UserProfile {
  static const initial = UserProfile(
    name: 'Estudante',
    avatarId: 'student',
    avatarChosen: false,
  );

  final String name;
  final String avatarId;
  /// Indica se o estudante escolheu um avatar (inclusive o Estudante).
  final bool avatarChosen;
  final int score;
  /// Fichas virtuais disponíveis para uso no Mercadinho.
  final int tokenBalance;
  /// IDs dos cenários do Mercadinho pagos e liberados permanentemente.
  final Set<String> unlockedChoiceIds;
  final List<ActivityRecord> activityHistory;
  final Set<String> completedActivityIds;

  const UserProfile({
    required this.name,
    this.avatarId = 'student',
    this.avatarChosen = false,
    this.score = 0,
    this.tokenBalance = 0,
    this.unlockedChoiceIds = const {},
    this.activityHistory = const [],
    this.completedActivityIds = const {},
  });

  int get activitiesCompleted => activityHistory.length;

  int get independentCorrectAnswers => activityHistory.fold(
        0,
        (total, record) => total + record.independentCorrectAnswers,
      );

  int get assistedCorrectAnswers => activityHistory.fold(
        0,
        (total, record) => total + record.assistedCorrectAnswers,
      );

  int get incorrectAttempts => activityHistory.fold(
        0,
        (total, record) => total + record.incorrectAttempts,
      );

  UserProfile copyWith({
    String? name,
    String? avatarId,
    bool? avatarChosen,
    int? score,
    int? tokenBalance,
    Set<String>? unlockedChoiceIds,
    List<ActivityRecord>? activityHistory,
    Set<String>? completedActivityIds,
  }) {
    return UserProfile(
      name: name ?? this.name,
      avatarId: avatarId ?? this.avatarId,
      avatarChosen: avatarChosen ?? this.avatarChosen,
      score: score ?? this.score,
      tokenBalance: tokenBalance ?? this.tokenBalance,
      unlockedChoiceIds: unlockedChoiceIds ?? this.unlockedChoiceIds,
      activityHistory: activityHistory ?? this.activityHistory,
      completedActivityIds:
          completedActivityIds ?? this.completedActivityIds,
    );
  }

  Map<String, Object> toJson() {
    return {
      'name': name,
      'avatarId': avatarId,
      'avatarChosen': avatarChosen,
      'score': score,
      'tokenBalance': tokenBalance,
      'unlockedChoiceIds': unlockedChoiceIds.toList(),
      'activityHistory':
          activityHistory.map((record) => record.toJson()).toList(),
      'completedActivityIds': completedActivityIds.toList(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final history = json['activityHistory'] as List<dynamic>? ?? const [];
    final savedTokens = json['tokenBalance'];
    final savedUnlocked = json['unlockedChoiceIds'];
    final unlockedIds = savedUnlocked is List
        ? savedUnlocked.whereType<String>().toSet()
        : <String>{};
    final completedIds =
        json['completedActivityIds'] as List<dynamic>? ?? const [];

    return UserProfile(
      name: json['name'] as String? ?? 'Estudante',
      avatarId: json['avatarId'] as String? ?? 'student',
      // Compatibilidade com perfis antigos: um avatar diferente do padrão
      // é considerado escolhido. O padrão antigo 'student' era ambíguo.
      avatarChosen: json['avatarChosen'] as bool? ??
          (json['avatarId'] is String && json['avatarId'] != 'student'),
      score: json['score'] as int? ?? 0,
      // JSONs antigos não possuem este campo; saldo negativo não é válido.
      tokenBalance: savedTokens is int && savedTokens >= 0 ? savedTokens : 0,
      unlockedChoiceIds: unlockedIds,
      activityHistory: history
          .map(
            (record) => ActivityRecord.fromJson(
              Map<String, dynamic>.from(record as Map),
            ),
          )
          .toList(),
      completedActivityIds: completedIds.whereType<String>().toSet(),
    );
  }
}
