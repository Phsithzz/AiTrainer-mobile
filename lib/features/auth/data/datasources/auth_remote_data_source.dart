import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String identifier, required String password});
  Future<String> register({required String username, required String email, required String password});
  Future<void> verifyOtp({required String username, required String otp});
  Future<UserModel> getMe();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login({required String identifier, required String password}) async {
    final response = await client.post(
      ApiConstants.login,
      data: {'identifier': identifier, 'password': password},
    );
    final token = response['access_token'] as String;
    final username = response['username'] as String? ?? identifier;
    await client.saveSession(token, username);
    return UserModel(username: username, email: '');
  }

  @override
  Future<String> register({required String username, required String email, required String password}) async {
    final response = await client.post(
      ApiConstants.register,
      data: {'username': username, 'email': email, 'password': password},
    );
    return response['message']?.toString() ?? 'OTP Sent';
  }

  @override
  Future<void> verifyOtp({required String username, required String otp}) async {
    await client.post(
      ApiConstants.verifyOtp,
      data: {'username': username, 'otp': otp},
    );
  }

  @override
  Future<UserModel> getMe() async {
    final response = await client.get(ApiConstants.me);
    return UserModel.fromJson(response);
  }

  @override
  Future<void> logout() async {
    await client.clearSession();
  }
}
