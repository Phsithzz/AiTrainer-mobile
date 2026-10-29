import 'package:equatable/equatable.dart';
import '../../domain/entities/exercise_entities.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
}

class StartWorkoutEvent extends WorkoutEvent {
  final ExerciseType exercise;

  const StartWorkoutEvent(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

class RecordRepEvent extends WorkoutEvent {
  final bool isGood;
  final String? errorKey;
  final String feedback;

  const RecordRepEvent({
    required this.isGood,
    this.errorKey,
    required this.feedback,
  });

  @override
  List<Object?> get props => [isGood, errorKey, feedback];
}

class WorkoutTimerTickEvent extends WorkoutEvent {}

class FinishWorkoutEvent extends WorkoutEvent {}

class SaveCurrentWorkoutEvent extends WorkoutEvent {}

class ResetWorkoutEvent extends WorkoutEvent {}
