import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/app_colors.dart';

void main() {
  test('AppColors definition check', () {
    expect(AppColors.primary, isNotNull);
    expect(AppColors.background, isNotNull);
    expect(AppColors.accent, isNotNull);
  });
}
