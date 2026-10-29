import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/exercise_entities.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_data_source.dart';
import '../models/workout_model.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource remoteDataSource;

  ExerciseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> saveWorkout(WorkoutSession workout) async {
    try {
      final model = WorkoutSessionModel(
        exercise: workout.exercise,
        reps: workout.reps,
        good: workout.good,
        bad: workout.bad,
        accuracy: workout.accuracy,
        totalTime: workout.totalTime,
        badDetails: workout.badDetails,
      );
      await remoteDataSource.saveWorkout(model);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory() async {
    try {
      final list = await remoteDataSource.getWorkoutHistory();
      return Right(list);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
