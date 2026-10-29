import '../../domain/entities/exercise_entities.dart';

class WorkoutSessionModel extends WorkoutSession {
  const WorkoutSessionModel({
    required super.exercise,
    super.reps,
    super.good,
    super.bad,
    super.accuracy,
    required super.totalTime,
    required super.badDetails,
    super.createdAt,
  });

  factory WorkoutSessionModel.fromJson(Map<String, dynamic> json) {
    final exKey = json['exercise']?.toString().toLowerCase() ?? 'squat';
    final ex = ExerciseType.values.firstWhere(
      (e) => e.key == exKey,
      orElse: () => ExerciseType.squat,
    );

    final detailsMap = <String, int>{};
    if (json['bad_details'] is Map) {
      (json['bad_details'] as Map).forEach((k, v) {
        detailsMap[k.toString()] = (v as num?)?.toInt() ?? 0;
      });
    }

    final reps = (json['reps'] as num?)?.toInt() ?? (json['total_reps'] as num?)?.toInt() ?? 0;
    final good = (json['good'] as num?)?.toInt() ?? 0;
    final bad = (json['bad'] as num?)?.toInt() ?? 0;
    final totalTime = (json['total_time'] as num?)?.toDouble() ?? (json['duration_sec'] as num?)?.toDouble() ?? 0.0;
    final accuracy = (json['accuracy'] as num?)?.toInt() ?? (reps > 0 ? ((good / reps) * 100).round() : 100);

    return WorkoutSessionModel(
      exercise: ex,
      reps: reps,
      good: good,
      bad: bad,
      accuracy: accuracy,
      totalTime: totalTime,
      badDetails: detailsMap,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise.key,
      'reps': reps,
      'good': good,
      'bad': bad,
      'accuracy': accuracy,
      'total_time': totalTime,
      'bad_details': badDetails,
    };
  }
}
