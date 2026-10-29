import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final username = authState is Authenticated ? authState.user.username : 'Athlete';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🏋️ ', style: TextStyle(fontSize: 20)),
            Text('สวัสดี, $username'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
            onPressed: () {
              context.read<DashboardBloc>().add(LoadDashboardStatsEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is DashboardLoaded) {
            final stats = state.stats;

            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                context.read<DashboardBloc>().add(LoadDashboardStatsEvent());
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                children: [
                  // Comparison Trophy Banner
                  if (stats.isAboveAverageAcc || stats.isAboveAverageTime)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.emoji_events_outlined, color: AppColors.primary, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'ยอดเยี่ยมมาก! สถิติความแม่นยำของคุณสูงกว่าค่าเฉลี่ยสากล',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Overview Stats Grid
                  const Text(
                    'OVERALL PERFORMANCE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Total Reps',
                          value: '${stats.totalReps}',
                          unit: 'ครั้ง',
                          icon: Icons.fitness_center_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          title: 'Accuracy',
                          value: Formatters.formatAccuracy(stats.averageAccuracy),
                          unit: 'เฉลี่ย',
                          icon: Icons.check_circle_outline_rounded,
                          color: AppColors.cyan,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          title: 'Workout Time',
                          value: Formatters.formatDuration(stats.totalTime),
                          unit: 'นาที:วิ',
                          icon: Icons.timer_outlined,
                          color: AppColors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Breakdown By Exercise
                  const Text(
                    'BREAKDOWN BY EXERCISE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _ExerciseRow(
                          emoji: '🏋️',
                          title: 'Squat',
                          reps: '${stats.repsByExercise["squat"] ?? 0} reps',
                          accuracy: stats.accuracyByExercise["squat"] ?? 0,
                        ),
                        const Divider(height: 20),
                        _ExerciseRow(
                          emoji: '💪',
                          title: 'Push-up',
                          reps: '${stats.repsByExercise["pushup"] ?? 0} reps',
                          accuracy: stats.accuracyByExercise["pushup"] ?? 0,
                        ),
                        const Divider(height: 20),
                        _ExerciseRow(
                          emoji: '⏱️',
                          title: 'Plank',
                          reps: Formatters.formatDuration(stats.timeByExercise["plank"] ?? 0),
                          accuracy: stats.accuracyByExercise["plank"] ?? 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Top Weaknesses Analysis
                  const Text(
                    'TOP FORM WEAKNESSES (จุดที่ต้องแก้ไข)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (stats.topWeaknesses.isEmpty)
                    const AppCard(
                      child: Center(
                        child: Text(
                          'ยังไม่พบข้อผิดพลาด รักษาสรีระการฝึกที่ดีต่อไป! ✨',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ...stats.topWeaknesses.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: AppCard(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  Formatters.errorDetailTh(item.key),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.errorBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${item.value} ครั้ง',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            );
          }

          return Center(
            child: ElevatedButton(
              onPressed: () => context.read<DashboardBloc>().add(LoadDashboardStatsEvent()),
              child: const Text('โหลดสถิติ'),
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color, letterSpacing: -0.5),
          ),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String reps;
  final num accuracy;

  const _ExerciseRow({
    required this.emoji,
    required this.title,
    required this.reps,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(reps, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.correct.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${accuracy.round()}% ACC',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.correct),
          ),
        ),
      ],
    );
  }
}
