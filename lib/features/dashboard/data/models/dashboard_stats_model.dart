import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalReps,
    required super.averageAccuracy,
    required super.totalTime,
    required super.repsByExercise,
    required super.accuracyByExercise,
    required super.timeByExercise,
    required super.topWeaknesses,
    required super.isAboveAverageTime,
    required super.isAboveAverageAcc,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final myStats = json['my_stats'] as Map<String, dynamic>? ?? {};
    final comp = json['comparison'] as Map<String, dynamic>? ?? {};

    final repsMap = <String, int>{};
    if (myStats['reps_by_ex'] is Map) {
      (myStats['reps_by_ex'] as Map).forEach((k, v) => repsMap[k.toString()] = (v as num?)?.toInt() ?? 0);
    }

    final accMap = <String, double>{};
    if (myStats['acc_by_ex'] is Map) {
      (myStats['acc_by_ex'] as Map).forEach((k, v) => accMap[k.toString()] = (v as num?)?.toDouble() ?? 0.0);
    }

    final timeMap = <String, double>{};
    if (myStats['time_by_ex'] is Map) {
      (myStats['time_by_ex'] as Map).forEach((k, v) => timeMap[k.toString()] = (v as num?)?.toDouble() ?? 0.0);
    }

    final weaknesses = <MapEntry<String, int>>[];
    final rawWeaknesses = myStats['top_weakness'] ?? myStats['weaknesses'];
    if (rawWeaknesses is List) {
      for (final item in rawWeaknesses) {
        if (item is List && item.length >= 2) {
          weaknesses.add(MapEntry(item[0].toString(), (item[1] as num?)?.toInt() ?? 0));
        }
      }
    }

    return DashboardStatsModel(
      totalReps: (myStats['total_reps'] as num?)?.toInt() ?? 0,
      averageAccuracy: (myStats['average_accuracy'] as num?)?.toDouble() ?? 0.0,
      totalTime: (myStats['total_time'] as num?)?.toDouble() ?? 0.0,
      repsByExercise: repsMap,
      accuracyByExercise: accMap,
      timeByExercise: timeMap,
      topWeaknesses: weaknesses,
      isAboveAverageTime: comp['is_above_average_time'] ?? false,
      isAboveAverageAcc: comp['is_above_average_acc'] ?? false,
    );
  }
}
