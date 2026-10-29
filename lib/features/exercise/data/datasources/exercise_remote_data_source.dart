import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/workout_model.dart';

abstract class ExerciseRemoteDataSource {
  Future<void> saveWorkout(WorkoutSessionModel workout);
  Future<List<WorkoutSessionModel>> getWorkoutHistory();
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ApiClient client;

  ExerciseRemoteDataSourceImpl({required this.client});

  @override
  Future<void> saveWorkout(WorkoutSessionModel workout) async {
    await client.post(
      ApiConstants.workouts,
      data: workout.toJson(),
    );
  }

  @override
  Future<List<WorkoutSessionModel>> getWorkoutHistory() async {
    final response = await client.get(ApiConstants.workouts);
    if (response is List) {
      return response
          .map((item) => WorkoutSessionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
