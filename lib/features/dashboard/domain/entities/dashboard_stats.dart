import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int totalReps;
  final double averageAccuracy;
  final double totalTime;
  final Map<String, int> repsByExercise;
  final Map<String, double> accuracyByExercise;
  final Map<String, double> timeByExercise;
  final List<MapEntry<String, int>> topWeaknesses;
  final bool isAboveAverageTime;
  final bool isAboveAverageAcc;

  const DashboardStats({
    required this.totalReps,
    required this.averageAccuracy,
    required this.totalTime,
    required this.repsByExercise,
    required this.accuracyByExercise,
    required this.timeByExercise,
    required this.topWeaknesses,
    required this.isAboveAverageTime,
    required this.isAboveAverageAcc,
  });

  @override
  List<Object?> get props => [
        totalReps,
        averageAccuracy,
        totalTime,
        repsByExercise,
        accuracyByExercise,
        timeByExercise,
        topWeaknesses,
        isAboveAverageTime,
        isAboveAverageAcc,
      ];
}
