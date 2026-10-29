import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistoryRequested extends HistoryEvent {
  const LoadHistoryRequested();
}

class FilterHistoryByExerciseRequested extends HistoryEvent {
  final String exerciseType; // 'all', 'squat', 'pushup', 'plank'

  const FilterHistoryByExerciseRequested(this.exerciseType);

  @override
  List<Object?> get props => [exerciseType];
}
