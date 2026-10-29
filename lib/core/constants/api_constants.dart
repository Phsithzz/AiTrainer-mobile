class ApiConstants {
  ApiConstants._();

  static const String defaultBaseUrl = 'http://10.0.2.2:8000';
  static const String defaultLocalhostUrl = 'http://localhost:8000';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String me = '/auth/me';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Exercise endpoints
  static const String workouts = '/exercise/workouts';
  static const String dashboard = '/exercise/dashboard';

  // WebSocket endpoints
  static String wsExercise(String baseUrl, String exercise) {
    final uri = Uri.parse(baseUrl);
    final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
    return '$wsScheme://${uri.host}:${uri.port}/exercise/$exercise';
  }
}
