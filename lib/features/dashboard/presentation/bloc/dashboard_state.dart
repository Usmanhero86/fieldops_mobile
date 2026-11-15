part of 'dashboard_cubit.dart';

sealed class DashboardState {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  const DashboardLoaded({
    required this.stats,
    required this.performance,
    required this.recentActivities,
  });

  final DashboardStats stats;
  final List<ProjectPerformanceRow> performance;
  final List<RecentActivityRow> recentActivities;
}

final class DashboardError extends DashboardState {
  const DashboardError({required this.message});
  final String message;
}
