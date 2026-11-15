part of 'activity_log_cubit.dart';

/// States emitted by [ActivityLogCubit].
sealed class ActivityLogState {
  const ActivityLogState();
}

final class ActivityLogIdle extends ActivityLogState {
  const ActivityLogIdle();
}

final class ActivityLogSaving extends ActivityLogState {
  const ActivityLogSaving();
}

final class ActivityLogSuccess extends ActivityLogState {
  const ActivityLogSuccess({required this.activityId});
  final String activityId;
}

final class ActivityLogFailure extends ActivityLogState {
  const ActivityLogFailure({required this.message});
  final String message;
}
