import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/exercise_entities.dart';
import 'train_page.dart';

class SelectExercisePage extends StatefulWidget {
  const SelectExercisePage({super.key});

  @override
  State<SelectExercisePage> createState() => _SelectExercisePageState();
}

class _SelectExercisePageState extends State<SelectExercisePage> {
  ExerciseType _selected = ExerciseType.squat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('เลือกท่าออกกำลังกาย'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          const Text(
            'CHOOSE EXERCISE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          // Exercise Options
          ...ExerciseType.values.map((ex) {
            final isChosen = _selected == ex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                color: isChosen ? AppColors.cardElevated : AppColors.card,
                border: Border.all(
                  color: isChosen ? AppColors.primary : AppColors.cardBorder,
                  width: isChosen ? 1.5 : 1,
                ),
                onTap: () => setState(() => _selected = ex),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: (isChosen ? AppColors.primary : AppColors.cardBorder).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(ex.emoji, style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ex.titleTh,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isChosen ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ex.description,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (isChosen)
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),

          // Instruction Tips
          AppCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.camera_alt_outlined, size: 18, color: AppColors.cyan),
                    SizedBox(width: 8),
                    Text('คำแนะนำในการตั้งกล้อง', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '• วางมือถือให้เห็นทั้งร่างกาย ตั้งแต่ศีรษะถึงปลายเท้า\n• จัดแสงให้สว่างพอดี หลีกเลี่ยงแสงย้อนจากด้านหลัง\n• AI จะตรวจจับ 33 จุดข้อต่อ (Pose Landmarks) แบบ Real-time',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Start Button
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow_rounded, size: 22),
            label: Text('เริ่มการฝึก ${_selected.titleTh}'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrainPage(exercise: _selected),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
