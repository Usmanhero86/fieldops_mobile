import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/activity_local_dao.dart';

part 'activity_log_state.dart';

/// Manages the save lifecycle for the Field Activity form.
class ActivityLogCubit extends Cubit<ActivityLogState> {
  ActivityLogCubit({required ActivityLocalDao dao})
      : _dao = dao,
        super(const ActivityLogIdle());

  final ActivityLocalDao _dao;

  /// Persists the validated activity data plus its photo paths locally.
  Future<void> save({
    required String projectId,
    required String communityId,
    required String activityType,
    required DateTime date,
    required int maleCount,
    required int femaleCount,
    required int childrenCount,
    String? description,
    double? latitude,
    double? longitude,
    required String fieldOfficerId,
    List<String> photoPaths = const [],
  }) async {
    emit(const ActivityLogSaving());
    try {
      final id = await _dao.insertActivity(
        projectId: projectId,
        communityId: communityId,
        activityType: activityType,
        date: date,
        maleCount: maleCount,
        femaleCount: femaleCount,
        childrenCount: childrenCount,
        description: description,
        latitude: latitude,
        longitude: longitude,
        fieldOfficerId: fieldOfficerId,
        photoPaths: photoPaths,
      );
      emit(ActivityLogSuccess(activityId: id));
    } catch (e) {
      emit(ActivityLogFailure(message: e.toString()));
    }
  }

  void reset() => emit(const ActivityLogIdle());
}
