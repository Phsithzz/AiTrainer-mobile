import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({required String identifier, required String password});
  Future<Either<Failure, String>> register({required String username, required String email, required String password});
  Future<Either<Failure, void>> verifyOtp({required String username, required String otp});
  Future<Either<Failure, User>> getMe();
  Future<Either<Failure, void>> logout();
  Future<bool> hasSession();
}
