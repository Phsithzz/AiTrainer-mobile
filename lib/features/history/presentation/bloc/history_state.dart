import 'package:equatable/equatable.dart';
import '../../../exercise/domain/entities/exercise_entities.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<WorkoutSession> allWorkouts;
  final List<WorkoutSession> filteredWorkouts;
  final String selectedFilter;

  const HistoryLoaded({
    required this.allWorkouts,
    required this.filteredWorkouts,
    this.selectedFilter = 'all',
  });

  @override
  List<Object?> get props => [allWorkouts, filteredWorkouts, selectedFilter];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
