import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;

  DashboardBloc({required this.getDashboardStatsUseCase}) : super(DashboardInitial()) {
    on<LoadDashboardStatsEvent>(_onLoadDashboardStats);
  }

  Future<void> _onLoadDashboardStats(LoadDashboardStatsEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    final result = await getDashboardStatsUseCase();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (stats) => emit(DashboardLoaded(stats)),
    );
  }
}
