/// Resumo de uma atividade concluída, usado no histórico e no reforço.
class ActivityRecord {
  final String activityId;
  final String activityName;
  final DateTime completedAt;
  final int pointsEarned;
  final int independentCorrectAnswers;
  final int assistedCorrectAnswers;
  final int incorrectAttempts;

  const ActivityRecord({
    required this.activityId,
    required this.activityName,
    required this.completedAt,
    required this.pointsEarned,
    required this.independentCorrectAnswers,
    required this.assistedCorrectAnswers,
    required this.incorrectAttempts,
  });

  Map<String, Object> toJson() {
    return {
      'activityId': activityId,
      'activityName': activityName,
      'completedAt': completedAt.toIso8601String(),
      'pointsEarned': pointsEarned,
      'independentCorrectAnswers': independentCorrectAnswers,
      'assistedCorrectAnswers': assistedCorrectAnswers,
      'incorrectAttempts': incorrectAttempts,
    };
  }

  factory ActivityRecord.fromJson(Map<String, dynamic> json) {
    return ActivityRecord(
      activityId: json['activityId'] as String,
      activityName: json['activityName'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      pointsEarned: json['pointsEarned'] as int? ?? 0,
      independentCorrectAnswers:
          json['independentCorrectAnswers'] as int? ?? 0,
      assistedCorrectAnswers: json['assistedCorrectAnswers'] as int? ?? 0,
      incorrectAttempts: json['incorrectAttempts'] as int? ?? 0,
    );
  }
}
