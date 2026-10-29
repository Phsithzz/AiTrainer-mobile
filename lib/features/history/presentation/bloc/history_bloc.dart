import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/exercise/domain/entities/exercise_entities.dart';
import 'package:mobile/features/exercise/domain/usecases/exercise_usecases.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetWorkoutHistoryUseCase getWorkoutHistoryUseCase;

  HistoryBloc({required this.getWorkoutHistoryUseCase}) : super(HistoryInitial()) {
    on<LoadHistoryRequested>(_onLoadHistory);
    on<FilterHistoryByExerciseRequested>(_onFilterHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistoryRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    final result = await getWorkoutHistoryUseCase();
    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (workouts) {
        emit(HistoryLoaded(
          allWorkouts: workouts,
          filteredWorkouts: workouts,
          selectedFilter: 'all',
        ));
      },
    );
  }

  void _onFilterHistory(
    FilterHistoryByExerciseRequested event,
    Emitter<HistoryState> emit,
  ) {
    if (state is HistoryLoaded) {
      final currentState = state as HistoryLoaded;
      List<WorkoutSession> filtered;
      if (event.exerciseType == 'all') {
        filtered = currentState.allWorkouts;
      } else {
        filtered = currentState.allWorkouts
            .where((w) => w.exercise.key.toLowerCase() == event.exerciseType.toLowerCase())
            .toList();
      }

      emit(HistoryLoaded(
        allWorkouts: currentState.allWorkouts,
        filteredWorkouts: filtered,
        selectedFilter: event.exerciseType,
      ));
    }
  }
}
