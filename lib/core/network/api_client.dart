import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../errors/failures.dart';

class ApiClient {
  final Dio dio;
  final SharedPreferences prefs;

  static const String keyToken = 'auth_token';
  static const String keyUsername = 'auth_username';
  static const String keyBaseUrl = 'base_url';
  static const String keyIsMock = 'is_mock_mode';

  ApiClient({required this.dio, required this.prefs}) {
    _initDio();
  }

  void _initDio() {
    dio.options.baseUrl = getBaseUrl();
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  String getBaseUrl() {
    return prefs.getString(keyBaseUrl) ?? ApiConstants.defaultBaseUrl;
  }

  Future<void> setBaseUrl(String url) async {
    await prefs.setString(keyBaseUrl, url);
    dio.options.baseUrl = url;
  }

  bool isMockMode() {
    return prefs.getBool(keyIsMock) ?? false;
  }

  Future<void> setMockMode(bool enabled) async {
    await prefs.setBool(keyIsMock, enabled);
  }

  String? getToken() => prefs.getString(keyToken);
  String? getSavedUsername() => prefs.getString(keyUsername);

  Future<void> saveSession(String token, String username) async {
    await prefs.setString(keyToken, token);
    await prefs.setString(keyUsername, username);
  }

  Future<void> clearSession() async {
    await prefs.remove(keyToken);
    await prefs.remove(keyUsername);
  }

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    if (isMockMode()) {
      return _mockHandler('GET', endpoint, queryParameters: queryParameters);
    }

    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<dynamic> post(String endpoint, {dynamic data}) async {
    if (isMockMode()) {
      return _mockHandler('POST', endpoint, data: data);
    }

    try {
      final response = await dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ AI Trainer ได้ กรุณาตรวจสอบ IP Server');
    }

    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    String message = 'เกิดข้อผิดพลาดในการประมวลผล';

    if (responseData is Map && responseData['detail'] != null) {
      message = responseData['detail'].toString();
    } else if (e.message != null && e.message!.isNotEmpty) {
      message = e.message!;
    }

    if (statusCode == 401) {
      return AuthFailure(message);
    }
    return ServerFailure(message, statusCode: statusCode);
  }

  dynamic _mockHandler(String method, String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) {
    final now = DateTime.now();

    if (endpoint == ApiConstants.login) {
      return {
        'access_token': 'mock_token_aitrainer_athlete_123',
        'username': data?['identifier'] ?? 'Athlete Pro',
      };
    }

    if (endpoint == ApiConstants.register) {
      return {'message': 'สมัครสมาชิกสำเร็จ รหัส OTP ถูกส่งไปยังอีเมลแล้ว'};
    }

    if (endpoint == ApiConstants.verifyOtp) {
      return {'message': 'ยืนยันรหัส OTP สำเร็จ'};
    }

    if (endpoint == ApiConstants.me) {
      return {
        'username': getSavedUsername() ?? 'Athlete Pro',
        'email': 'athlete@aitrainer.com',
      };
    }

    if (endpoint == ApiConstants.workouts) {
      if (method == 'POST') {
        return {'message': 'บันทึกสถิติสำเร็จ'};
      }
      return [
        {
          'exercise': 'squat',
          'reps': 15,
          'good': 12,
          'bad': 3,
          'accuracy': 80,
          'total_time': 55.0,
          'bad_details': {'squat_bad_heel': 2, 'squat_bad_back': 1},
          'created_at': now.subtract(const Duration(hours: 2)).toIso8601String(),
        },
        {
          'exercise': 'pushup',
          'reps': 20,
          'good': 18,
          'bad': 2,
          'accuracy': 90,
          'total_time': 70.0,
          'bad_details': {'pushup_bad_hips': 2},
          'created_at': now.subtract(const Duration(days: 1)).toIso8601String(),
        },
        {
          'exercise': 'plank',
          'reps': 0,
          'good': 0,
          'bad': 0,
          'accuracy': 95,
          'total_time': 120.0,
          'bad_details': {'plank_bad_hips': 1},
          'created_at': now.subtract(const Duration(days: 2)).toIso8601String(),
        },
      ];
    }

    if (endpoint == ApiConstants.dashboard) {
      return {
        'my_stats': {
          'total_reps': 35,
          'average_accuracy': 88.5,
          'total_time': 245.0,
          'reps_by_ex': {'squat': 15, 'pushup': 20, 'plank': 0},
          'acc_by_ex': {'squat': 80, 'pushup': 90, 'plank': 95},
          'time_by_ex': {'squat': 55.0, 'pushup': 70.0, 'plank': 120.0},
          'top_weakness': [
            ['squat_bad_heel', 4],
            ['pushup_bad_hips', 3],
            ['squat_bad_back', 2],
          ],
        },
        'comparison': {
          'is_above_average_time': true,
          'is_above_average_acc': true,
        },
      };
    }

    return {};
  }
}
