import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final GetMeUseCase getMeUseCase;
  final LogoutUseCase logoutUseCase;
  final ApiClient apiClient;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOtpUseCase,
    required this.getMeUseCase,
    required this.logoutUseCase,
    required this.apiClient,
  }) : super(AuthInitial()) {
    on<CheckAuthSessionEvent>(_onCheckAuthSession);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<RegisterSubmittedEvent>(_onRegisterSubmitted);
    on<VerifyOtpSubmittedEvent>(_onVerifyOtpSubmitted);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<SwitchMockModeEvent>(_onSwitchMockMode);
  }

  Future<void> _onCheckAuthSession(CheckAuthSessionEvent event, Emitter<AuthState> emit) async {
    final isMock = apiClient.isMockMode();
    final token = apiClient.getToken();

    if (token == null || token.isEmpty) {
      emit(Unauthenticated(isMock: isMock));
      return;
    }

    emit(AuthLoading());
    final result = await getMeUseCase();
    result.fold(
      (failure) {
        apiClient.clearSession();
        emit(Unauthenticated(message: failure.message, isMock: isMock));
      },
      (user) => emit(Authenticated(user: user, isMock: isMock)),
    );
  }

  Future<void> _onLoginSubmitted(LoginSubmittedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final isMock = apiClient.isMockMode();
    final result = await loginUseCase(identifier: event.identifier, password: event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user: user, isMock: isMock)),
    );
  }

  Future<void> _onRegisterSubmitted(RegisterSubmittedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      username: event.username,
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (msg) => emit(OtpSentState(username: event.username, message: msg)),
    );
  }

  Future<void> _onVerifyOtpSubmitted(VerifyOtpSubmittedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await verifyOtpUseCase(username: event.username, otp: event.otp);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated(message: 'ยืนยัน OTP สำเร็จแล้ว กรุณาเข้าสู่ระบบ')),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await logoutUseCase();
    emit(Unauthenticated(isMock: apiClient.isMockMode()));
  }

  Future<void> _onSwitchMockMode(SwitchMockModeEvent event, Emitter<AuthState> emit) async {
    await apiClient.setMockMode(event.isMock);
    add(CheckAuthSessionEvent());
  }
}
