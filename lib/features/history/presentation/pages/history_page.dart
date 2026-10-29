import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/constants/app_colors.dart';
import 'package:mobile/core/utils/formatters.dart';
import 'package:mobile/core/widgets/app_card.dart';
import 'package:mobile/features/exercise/domain/entities/exercise_entities.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(const LoadHistoryRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ประวัติการฝึกซ้อม'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HistoryBloc>().add(const LoadHistoryRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is HistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<HistoryBloc>().add(const LoadHistoryRequested()),
                    child: const Text('ลองใหม่อีกครั้ง'),
                  ),
                ],
              ),
            );
          }

          if (state is HistoryLoaded) {
            return Column(
              children: [
                _buildFilterChips(context, state.selectedFilter),
                Expanded(
                  child: state.filteredWorkouts.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () async {
                            context.read<HistoryBloc>().add(const LoadHistoryRequested());
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: state.filteredWorkouts.length,
                            itemBuilder: (context, index) {
                              final item = state.filteredWorkouts[index];
                              return _buildWorkoutCard(item);
                            },
                          ),
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, String currentFilter) {
    final filters = [
      {'key': 'all', 'label': 'ทั้งหมด'},
      {'key': 'squat', 'label': 'Squat'},
      {'key': 'pushup', 'label': 'Push-up'},
      {'key': 'plank', 'label': 'Plank'},
    ];

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = currentFilter == filter['key'];
          return ChoiceChip(
            label: Text(filter['label']!),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surfaceVariant,
            labelStyle: TextStyle(
              color: isSelected ? Colors.black : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            onSelected: (_) {
              context
                  .read<HistoryBloc>()
                  .add(FilterHistoryByExerciseRequested(filter['key']!));
            },
          );
        },
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutSession session) {
    final Color badgeColor = AppColors.getAccuracyColor(session.accuracy);
    final isPlank = session.exercise == ExerciseType.plank;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    session.exercise.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.exercise.titleTh,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      session.createdAt != null
                          ? Formatters.formatDate(session.createdAt!)
                          : 'การฝึกซ้อม',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '${session.accuracy}%',
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricColumn(
                isPlank ? 'ระยะเวลา' : 'จำนวนครั้ง',
                isPlank
                    ? Formatters.formatDuration(session.totalTime.toInt())
                    : '${session.reps} ครั้ง',
                Icons.repeat,
              ),
              _buildMetricColumn(
                'ครั้งที่ถูกต้อง',
                '${session.good} ครั้ง',
                Icons.check_circle_outline,
                color: AppColors.success,
              ),
              _buildMetricColumn(
                'จุดที่ต้องปรับ',
                '${session.bad} ครั้ง',
                Icons.warning_amber_rounded,
                color: session.bad > 0 ? AppColors.error : AppColors.textSecondary,
              ),
            ],
          ),
          if (session.badDetails.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: session.badDetails.entries.map((entry) {
                final label = Formatters.formatFormError(entry.key);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$label (${entry.value})',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color ?? AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 64, color: AppColors.textSecondary),
          SizedBox(height: 16),
          Text(
            'ยังไม่มีประวัติการฝึกซ้อม',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'เริ่มออกกำลังกายเลยเพื่อบันทึกสถิติของคุณ!',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
