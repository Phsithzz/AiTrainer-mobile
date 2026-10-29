import 'package:equatable/equatable.dart';

enum ExerciseType {
  squat('squat', 'สควอช (Squat)', '🏋️', 'ตรวจจับส้นเท้าลอย และหลังโค้งงอ'),
  pushup('pushup', 'วิดพื้น (Push-up)', '💪', 'ตรวจจับสะโพกห้อย ขางอ และคอก้ม'),
  plank('plank', 'แพลงก์ (Plank)', '⏱️', 'จับเวลาค้างท่า ตรวจจับสะโพกตก/โด่ง และเข่างอ');

  final String key;
  final String titleTh;
  final String emoji;
  final String description;

  const ExerciseType(this.key, this.titleTh, this.emoji, this.description);

  bool get isTimerBased => this == ExerciseType.plank;
}

class WorkoutSession extends Equatable {
  final ExerciseType exercise;
  final int reps;
  final int good;
  final int bad;
  final int accuracy;
  final double totalTime;
  final Map<String, int> badDetails;
  final DateTime? createdAt;

  const WorkoutSession({
    required this.exercise,
    this.reps = 0,
    this.good = 0,
    this.bad = 0,
    this.accuracy = 100,
    required this.totalTime,
    required this.badDetails,
    this.createdAt,
  });

  @override
  List<Object?> get props => [exercise, reps, good, bad, accuracy, totalTime, badDetails, createdAt];
}

class FramePrediction extends Equatable {
  final String label;
  final double confidence;
  final String feedback;
  final bool countRep;
  final int reps;
  final int goodCount;
  final int badCount;
  final String state; // "UP" | "DOWN" | "HOLD"
  final bool isGood;

  const FramePrediction({
    required this.label,
    required this.confidence,
    required this.feedback,
    required this.countRep,
    required this.reps,
    required this.goodCount,
    required this.badCount,
    required this.state,
    required this.isGood,
  });

  @override
  List<Object?> get props => [label, confidence, feedback, countRep, reps, goodCount, badCount, state, isGood];
}
