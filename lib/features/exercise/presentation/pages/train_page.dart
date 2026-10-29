import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/exercise_entities.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';

class TrainPage extends StatefulWidget {
  final ExerciseType exercise;

  const TrainPage({super.key, required this.exercise});

  @override
  State<TrainPage> createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutBloc>().add(StartWorkoutEvent(widget.exercise));
  }

  void _showWorkoutSummaryDialog(BuildContext ctx, WorkoutSession session) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<WorkoutBloc>(),
        child: BlocConsumer<WorkoutBloc, WorkoutState>(
          listener: (dialogCtx, state) {
            if (state is WorkoutCompleted && state.isSaved) {
              Navigator.pop(dialogCtx); // close dialog
              Navigator.pop(context);   // return to select page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 บันทึกสถิติการออกกำลังกายสำเร็จ!'),
                  backgroundColor: AppColors.correct,
                ),
              );
            }
          },
          builder: (dialogCtx, state) {
            final isSaving = state is WorkoutCompleted && state.isSaving;

            return AlertDialog(
              backgroundColor: AppColors.cardElevated,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Text('🏆 ', style: TextStyle(fontSize: 22)),
                  Text('สรุปผลการออกกำลังกาย', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.exercise.titleTh,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _SummaryMetric(
                        label: widget.exercise.isTimerBased ? 'เวลาที่ค้างได้' : 'จำนวนครั้ง',
                        value: widget.exercise.isTimerBased
                            ? Formatters.formatDuration(session.totalTime)
                            : '${session.reps} ครั้ง',
                      ),
                      _SummaryMetric(
                        label: 'ความถูกต้อง',
                        value: '${session.accuracy}%',
                        valueColor: session.accuracy >= 80 ? AppColors.correct : AppColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (session.badDetails.isNotEmpty) ...[
                    const Text('จุดที่ต้องระวัง (Form Flaws):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    ...session.badDetails.entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('• ${Formatters.errorDetailTh(e.key)}', style: const TextStyle(fontSize: 12, color: AppColors.error)),
                              Text('${e.value} ครั้ง', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error)),
                            ],
                          ),
                        )),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<WorkoutBloc>().add(ResetWorkoutEvent());
                    Navigator.pop(dialogCtx);
                    Navigator.pop(context);
                  },
                  child: const Text('ไม่บันทึก', style: TextStyle(color: AppColors.textMuted)),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () {
                          context.read<WorkoutBloc>().add(SaveCurrentWorkoutEvent());
                        },
                  child: isSaving
                      ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                      : const Text('บันทึกผลการซ้อม'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.read<WorkoutBloc>().add(FinishWorkoutEvent());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(widget.exercise.titleTh),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.stop_circle_outlined, color: AppColors.error),
              label: const Text('เสร็จสิ้น', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
              onPressed: () {
                context.read<WorkoutBloc>().add(FinishWorkoutEvent());
              },
            ),
          ],
        ),
        body: BlocConsumer<WorkoutBloc, WorkoutState>(
          listener: (context, state) {
            if (state is WorkoutCompleted) {
              _showWorkoutSummaryDialog(context, state.session);
            }
          },
          builder: (context, state) {
            if (state is WorkoutActive) {
              final isGood = state.isGoodForm;

              return Column(
                children: [
                  // Real-time camera & AI Canvas Simulation Area
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isGood ? AppColors.correct : AppColors.error,
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Central Pose Skeleton Simulator Visual
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.exercise.emoji, style: const TextStyle(fontSize: 72)),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: (isGood ? AppColors.correct : AppColors.error).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isGood ? '● FORM CORRECT (ตรวจจับ 33 จุด)' : '✕ POSE ERROR DETECTED',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isGood ? AppColors.correct : AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Elapsed Timer in Corner
                          Positioned(
                            top: 14,
                            left: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.timer_outlined, size: 14, color: AppColors.cyan),
                                  const SizedBox(width: 4),
                                  Text(
                                    Formatters.formatDuration(state.elapsedSeconds),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Real-time Feedback Announcement Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isGood ? AppColors.correct : AppColors.error).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isGood ? AppColors.correct : AppColors.error),
                      ),
                      child: Text(
                        state.currentFeedback,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isGood ? AppColors.correct : AppColors.error,
                        ),
                      ),
                    ),
                  ),

                  // Metrics Cards
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppCard(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('จำนวนครั้ง (TOTAL)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                                  const SizedBox(height: 6),
                                  Text(
                                    state.reps.toString(),
                                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppCard(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('GOOD / BAD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${state.good}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.correct)),
                                      const Text(' / ', style: TextStyle(fontSize: 20, color: AppColors.textMuted)),
                                      Text('${state.bad}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.error)),
                                    ],
                                  ),
                                  Text('${state.accuracy}% Accuracy', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Simulation Controls for Testing AI Form Correction on Device/Emulator
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.correctBg,
                              foregroundColor: AppColors.correct,
                              side: const BorderSide(color: AppColors.correct),
                            ),
                            icon: const Icon(Icons.check_circle_outline, size: 16),
                            label: const Text('+ Rep ถูกต้อง', style: TextStyle(fontSize: 12)),
                            onPressed: () {
                              context.read<WorkoutBloc>().add(
                                    const RecordRepEvent(
                                      isGood: true,
                                      feedback: '✅ ฟอร์มยอดเยี่ยม! ท่าสวยมาก',
                                    ),
                                  );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.errorBg,
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                            ),
                            icon: const Icon(Icons.warning_amber_rounded, size: 16),
                            label: const Text('+ ผิดฟอร์ม', style: TextStyle(fontSize: 12)),
                            onPressed: () {
                              final errorKey = widget.exercise == ExerciseType.squat
                                  ? 'squat_bad_heel'
                                  : widget.exercise == ExerciseType.pushup
                                      ? 'pushup_bad_hips'
                                      : 'plank_bad_hips';
                              context.read<WorkoutBloc>().add(
                                    RecordRepEvent(
                                      isGood: false,
                                      errorKey: errorKey,
                                      feedback: '⚠️ ${Formatters.errorDetailTh(errorKey)}! กรุณาปรับท่าทาง',
                                    ),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          },
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryMetric({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor ?? AppColors.textPrimary)),
      ],
    );
  }
}
