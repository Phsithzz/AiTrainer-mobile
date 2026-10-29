import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/exercise_entities.dart';
import '../../domain/usecases/exercise_usecases.dart';
import 'workout_event.dart';
import 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final SaveWorkoutUseCase saveWorkoutUseCase;
  Timer? _timer;

  WorkoutBloc({required this.saveWorkoutUseCase}) : super(WorkoutIdle()) {
    on<StartWorkoutEvent>(_onStartWorkout);
    on<RecordRepEvent>(_onRecordRep);
    on<WorkoutTimerTickEvent>(_onTimerTick);
    on<FinishWorkoutEvent>(_onFinishWorkout);
    on<SaveCurrentWorkoutEvent>(_onSaveCurrentWorkout);
    on<ResetWorkoutEvent>(_onResetWorkout);
  }

  void _onStartWorkout(StartWorkoutEvent event, Emitter<WorkoutState> emit) {
    _timer?.cancel();
    emit(WorkoutActive(
      exercise: event.exercise,
      badDetails: const {},
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(WorkoutTimerTickEvent());
    });
  }

  void _onTimerTick(WorkoutTimerTickEvent event, Emitter<WorkoutState> emit) {
    if (state is WorkoutActive) {
      final current = state as WorkoutActive;
      emit(current.copyWith(elapsedSeconds: current.elapsedSeconds + 1));
    }
  }

  void _onRecordRep(RecordRepEvent event, Emitter<WorkoutState> emit) {
    if (state is WorkoutActive) {
      final current = state as WorkoutActive;
      final newReps = current.reps + 1;
      final newGood = current.good + (event.isGood ? 1 : 0);
      final newBad = current.bad + (event.isGood ? 0 : 1);
      final newAcc = newReps > 0 ? ((newGood / newReps) * 100).round() : 100;

      final updatedBadDetails = Map<String, int>.from(current.badDetails);
      if (!event.isGood && event.errorKey != null) {
        updatedBadDetails[event.errorKey!] = (updatedBadDetails[event.errorKey!] ?? 0) + 1;
      }

      emit(current.copyWith(
        reps: newReps,
        good: newGood,
        bad: newBad,
        accuracy: newAcc,
        currentFeedback: event.feedback,
        isGoodForm: event.isGood,
        badDetails: updatedBadDetails,
      ));
    }
  }

  void _onFinishWorkout(FinishWorkoutEvent event, Emitter<WorkoutState> emit) {
    _timer?.cancel();
    if (state is WorkoutActive) {
      final current = state as WorkoutActive;
      final session = WorkoutSession(
        exercise: current.exercise,
        reps: current.reps,
        good: current.good,
        bad: current.bad,
        accuracy: current.accuracy,
        totalTime: current.elapsedSeconds.toDouble(),
        badDetails: current.badDetails,
        createdAt: DateTime.now(),
      );
      emit(WorkoutCompleted(session: session));
    }
  }

  Future<void> _onSaveCurrentWorkout(SaveCurrentWorkoutEvent event, Emitter<WorkoutState> emit) async {
    if (state is WorkoutCompleted) {
      final current = state as WorkoutCompleted;
      emit(current.copyWith(isSaving: true));

      final result = await saveWorkoutUseCase(current.session);
      result.fold(
        (failure) => emit(current.copyWith(isSaving: false, error: failure.message)),
        (_) => emit(current.copyWith(isSaving: false, isSaved: true)),
      );
    }
  }

  void _onResetWorkout(ResetWorkoutEvent event, Emitter<WorkoutState> emit) {
    _timer?.cancel();
    emit(WorkoutIdle());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
