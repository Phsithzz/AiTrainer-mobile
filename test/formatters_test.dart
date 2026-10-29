import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/formatters.dart';

void main() {
  group('Formatters Unit Tests', () {
    test('exerciseNameTh returns correct Thai translations', () {
      expect(Formatters.exerciseNameTh('squat'), 'สควอช (Squat)');
      expect(Formatters.exerciseNameTh('pushup'), 'วิดพื้น (Push-up)');
      expect(Formatters.exerciseNameTh('plank'), 'แพลงก์ (Plank)');
      expect(Formatters.exerciseNameTh('unknown'), 'UNKNOWN');
    });

    test('errorDetailTh returns correct Thai error explanations', () {
      expect(Formatters.errorDetailTh('squat_bad_heel'), 'ส้นเท้าลอย');
      expect(Formatters.errorDetailTh('squat_bad_back'), 'หลังโค้งงอ');
      expect(Formatters.errorDetailTh('pushup_bad_hips'), 'สะโพกตก/โก่ง');
      expect(Formatters.errorDetailTh('pushup_bad_knees'), 'เข่างอ');
      expect(Formatters.errorDetailTh('pushup_bad_neck'), 'ก้ม/เงยศีรษะผิดท่า');
      expect(Formatters.errorDetailTh('plank_bad_hips'), 'สะโพกตก/โก่ง');
      expect(Formatters.errorDetailTh('plank_bad_knees'), 'เข่างอ');
      expect(Formatters.errorDetailTh('plank_bad_neck'), 'ก้ม/เงยศีรษะผิดท่า');
      expect(Formatters.errorDetailTh('custom_error'), 'custom error');
    });

    test('formatDuration formats seconds to MM:SS correctly', () {
      expect(Formatters.formatDuration(0), '00:00');
      expect(Formatters.formatDuration(45), '00:45');
      expect(Formatters.formatDuration(75), '01:15');
      expect(Formatters.formatDuration(3665), '61:05');
    });

    test('formatAccuracy formats percentages correctly', () {
      expect(Formatters.formatAccuracy(0.854), '85%');
      expect(Formatters.formatAccuracy(100), '100%');
      expect(Formatters.formatAccuracy(0), '0%');
    });
  });
}
