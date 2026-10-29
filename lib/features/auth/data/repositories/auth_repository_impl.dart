import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ApiClient apiClient;

  AuthRepositoryImpl({required this.remoteDataSource, required this.apiClient});

  @override
  Future<Either<Failure, User>> login({required String identifier, required String password}) async {
    try {
      final user = await remoteDataSource.login(identifier: identifier, password: password);
      return Right(user);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> register({required String username, required String email, required String password}) async {
    try {
      final msg = await remoteDataSource.register(username: username, email: email, password: password);
      return Right(msg);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp({required String username, required String otp}) async {
    try {
      await remoteDataSource.verifyOtp(username: username, otp: otp);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getMe() async {
    try {
      final user = await remoteDataSource.getMe();
      return Right(user);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> hasSession() async {
    final token = apiClient.getToken();
    return token != null && token.isNotEmpty;
  }
}
