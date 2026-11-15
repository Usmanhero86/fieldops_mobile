import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/dashboard_local_dao.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required DashboardLocalDao dao})
      : _dao = dao,
        super(const DashboardInitial());

  final DashboardLocalDao _dao;

  Future<void> load() async {
    emit(const DashboardLoading());
    try {
      final results = await Future.wait([
        _dao.getStats(),
        _dao.getProjectPerformance(),
        _dao.getRecentActivities(),
      ]);
      emit(
        DashboardLoaded(
          stats: results[0] as DashboardStats,
          performance: results[1] as List<ProjectPerformanceRow>,
          recentActivities: results[2] as List<RecentActivityRow>,
        ),
      );
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> refresh() => load();
}
