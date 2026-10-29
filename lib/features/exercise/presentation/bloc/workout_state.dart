import 'package:equatable/equatable.dart';
import '../../domain/entities/exercise_entities.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

class WorkoutIdle extends WorkoutState {}

class WorkoutActive extends WorkoutState {
  final ExerciseType exercise;
  final int reps;
  final int good;
  final int bad;
  final int accuracy;
  final int elapsedSeconds;
  final String currentFeedback;
  final bool isGoodForm;
  final Map<String, int> badDetails;

  const WorkoutActive({
    required this.exercise,
    this.reps = 0,
    this.good = 0,
    this.bad = 0,
    this.accuracy = 100,
    this.elapsedSeconds = 0,
    this.currentFeedback = 'พร้อมแล้ว เริ่มออกกำลังกายได้เลย!',
    this.isGoodForm = true,
    required this.badDetails,
  });

  WorkoutActive copyWith({
    ExerciseType? exercise,
    int? reps,
    int? good,
    int? bad,
    int? accuracy,
    int? elapsedSeconds,
    String? currentFeedback,
    bool? isGoodForm,
    Map<String, int>? badDetails,
  }) {
    return WorkoutActive(
      exercise: exercise ?? this.exercise,
      reps: reps ?? this.reps,
      good: good ?? this.good,
      bad: bad ?? this.bad,
      accuracy: accuracy ?? this.accuracy,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      currentFeedback: currentFeedback ?? this.currentFeedback,
      isGoodForm: isGoodForm ?? this.isGoodForm,
      badDetails: badDetails ?? this.badDetails,
    );
  }

  @override
  List<Object?> get props => [
        exercise,
        reps,
        good,
        bad,
        accuracy,
        elapsedSeconds,
        currentFeedback,
        isGoodForm,
        badDetails,
      ];
}

class WorkoutCompleted extends WorkoutState {
  final WorkoutSession session;
  final bool isSaving;
  final bool isSaved;
  final String? error;

  const WorkoutCompleted({
    required this.session,
    this.isSaving = false,
    this.isSaved = false,
    this.error,
  });

  WorkoutCompleted copyWith({
    WorkoutSession? session,
    bool? isSaving,
    bool? isSaved,
    String? error,
  }) {
    return WorkoutCompleted(
      session: session ?? this.session,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      error: error,
    );
  }

  @override
  List<Object?> get props => [session, isSaving, isSaved, error];
}
