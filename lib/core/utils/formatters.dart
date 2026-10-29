import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String exerciseNameTh(String? ex) {
    if (ex == null) return '—';
    switch (ex.toLowerCase()) {
      case 'squat':
        return 'สควอช (Squat)';
      case 'pushup':
        return 'วิดพื้น (Push-up)';
      case 'plank':
        return 'แพลงก์ (Plank)';
      default:
        return ex.toUpperCase();
    }
  }

  static String formatExerciseName(String? ex) => exerciseNameTh(ex);

  static String errorDetailTh(String errorKey) {
    switch (errorKey.toLowerCase()) {
      case 'squat_bad_heel':
      case 'heel_lift':
        return 'ส้นเท้าลอย';
      case 'squat_bad_back':
      case 'back_rounding':
        return 'หลังโค้งงอ';
      case 'pushup_bad_hips':
      case 'plank_bad_hips':
      case 'hip_sag':
        return 'สะโพกตก/โก่ง';
      case 'pushup_bad_knees':
      case 'plank_bad_knees':
      case 'bent_knees':
        return 'เข่างอ';
      case 'pushup_bad_neck':
      case 'plank_bad_neck':
      case 'neck_drop':
        return 'ก้ม/เงยศีรษะผิดท่า';
      default:
        return errorKey.replaceAll('_', ' ');
    }
  }

  static String formatFormError(String errorKey) => errorDetailTh(errorKey);

  static String formatDuration(num? seconds) {
    if (seconds == null) return '00:00';
    final totalSec = seconds.toInt();
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String formatAccuracy(num? acc) {
    if (acc == null) return '0%';
    final val = acc.toDouble();
    if (val <= 1.0 && val > 0.0) {
      return '${(val * 100).round()}%';
    }
    return '${val.round()}%';
  }

  static String formatThaiDateTime(dynamic dateOrIso) {
    if (dateOrIso == null) return '—';
    DateTime dt;
    if (dateOrIso is DateTime) {
      dt = dateOrIso;
    } else if (dateOrIso is String) {
      final parsed = DateTime.tryParse(dateOrIso);
      if (parsed == null) return dateOrIso;
      dt = parsed;
    } else {
      return '—';
    }

    final local = dt.toLocal();
    final dayMonth = DateFormat('dd MMM yyyy, HH:mm').format(local);
    return dayMonth;
  }

  static String formatDate(dynamic dateOrIso) => formatThaiDateTime(dateOrIso);
}
