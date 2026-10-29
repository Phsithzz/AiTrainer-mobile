import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthSessionEvent extends AuthEvent {}

class LoginSubmittedEvent extends AuthEvent {
  final String identifier;
  final String password;

  const LoginSubmittedEvent({required this.identifier, required this.password});

  @override
  List<Object?> get props => [identifier, password];
}

class RegisterSubmittedEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const RegisterSubmittedEvent({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}

class VerifyOtpSubmittedEvent extends AuthEvent {
  final String username;
  final String otp;

  const VerifyOtpSubmittedEvent({required this.username, required this.otp});

  @override
  List<Object?> get props => [username, otp];
}

class LogoutRequestedEvent extends AuthEvent {}

class SwitchMockModeEvent extends AuthEvent {
  final bool isMock;

  const SwitchMockModeEvent(this.isMock);

  @override
  List<Object?> get props => [isMock];
}
