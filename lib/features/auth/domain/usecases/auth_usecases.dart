import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call({required String identifier, required String password}) {
    return repository.login(identifier: identifier, password: password);
  }
}

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<Either<Failure, String>> call({required String username, required String email, required String password}) {
    return repository.register(username: username, email: email, password: password);
  }
}

class VerifyOtpUseCase {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, void>> call({required String username, required String otp}) {
    return repository.verifyOtp(username: username, otp: otp);
  }
}

class GetMeUseCase {
  final AuthRepository repository;
  GetMeUseCase(this.repository);

  Future<Either<Failure, User>> call() {
    return repository.getMe();
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
