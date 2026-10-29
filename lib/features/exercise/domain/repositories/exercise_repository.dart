import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exercise_entities.dart';

abstract class ExerciseRepository {
  Future<Either<Failure, void>> saveWorkout(WorkoutSession workout);
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory();
}
