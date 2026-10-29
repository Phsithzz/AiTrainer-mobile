import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/exercise/data/models/workout_model.dart';
import 'package:mobile/features/exercise/domain/entities/exercise_entities.dart';
import 'package:mobile/features/dashboard/data/models/dashboard_stats_model.dart';

void main() {
  group('Models Serialization Tests', () {
    test('UserModel.fromJson parses correctly', () {
      final json = {
        'username': 'fitpro',
        'email': 'fitpro@example.com',
      };

      final model = UserModel.fromJson(json);

      expect(model.username, 'fitpro');
      expect(model.email, 'fitpro@example.com');
    });

    test('UserModel.toJson serializes correctly', () {
      const model = UserModel(
        username: 'test',
        email: 'test@example.com',
      );

      final json = model.toJson();

      expect(json['username'], 'test');
      expect(json['email'], 'test@example.com');
    });

    test('WorkoutSessionModel.fromJson and toJson roundtrip', () {
      final json = {
        'exercise': 'squat',
        'reps': 15,
        'good': 12,
        'bad': 3,
        'accuracy': 80,
        'total_time': 45.0,
        'bad_details': {'squat_bad_heel': 2, 'squat_bad_back': 1},
        'created_at': '2026-10-29T10:00:00.000Z',
      };

      final model = WorkoutSessionModel.fromJson(json);

      expect(model.exercise, ExerciseType.squat);
      expect(model.reps, 15);
      expect(model.good, 12);
      expect(model.bad, 3);
      expect(model.accuracy, 80);
      expect(model.totalTime, 45.0);
      expect(model.badDetails['squat_bad_heel'], 2);

      final exportedJson = model.toJson();
      expect(exportedJson['exercise'], 'squat');
      expect(exportedJson['reps'], 15);
      expect(exportedJson['good'], 12);
      expect(exportedJson['bad'], 3);
      expect(exportedJson['accuracy'], 80);
      expect(exportedJson['total_time'], 45.0);
    });

    test('DashboardStatsModel.fromJson parses dashboard payload correctly', () {
      final json = {
        'my_stats': {
          'total_reps': 150,
          'average_accuracy': 85.0,
          'total_time': 3600.0,
          'reps_by_ex': {'squat': 80, 'pushup': 70},
          'acc_by_ex': {'squat': 88.0, 'pushup': 82.0},
          'time_by_ex': {'squat': 1800.0, 'pushup': 1800.0},
          'top_weakness': [
            ['squat_bad_heel', 8],
            ['pushup_bad_hips', 4],
          ],
        },
        'comparison': {
          'is_above_average_time': true,
          'is_above_average_acc': true,
        },
      };

      final model = DashboardStatsModel.fromJson(json);

      expect(model.totalReps, 150);
      expect(model.averageAccuracy, 85.0);
      expect(model.totalTime, 3600.0);
      expect(model.repsByExercise['squat'], 80);
      expect(model.accuracyByExercise['squat'], 88.0);
      expect(model.topWeaknesses.first.key, 'squat_bad_heel');
      expect(model.topWeaknesses.first.value, 8);
      expect(model.isAboveAverageTime, true);
      expect(model.isAboveAverageAcc, true);
    });
  });
}
