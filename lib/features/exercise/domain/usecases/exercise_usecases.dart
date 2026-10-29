import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exercise_entities.dart';
import '../repositories/exercise_repository.dart';

class SaveWorkoutUseCase {
  final ExerciseRepository repository;
  SaveWorkoutUseCase(this.repository);

  Future<Either<Failure, void>> call(WorkoutSession workout) {
    return repository.saveWorkout(workout);
  }
}

class GetWorkoutHistoryUseCase {
  final ExerciseRepository repository;
  GetWorkoutHistoryUseCase(this.repository);

  Future<Either<Failure, List<WorkoutSession>>> call() {
    return repository.getWorkoutHistory();
  }
}
