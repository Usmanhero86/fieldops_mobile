import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/map_local_dao.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required MapLocalDao dao}) : _dao = dao, super(const MapInitial());

  final MapLocalDao _dao;

  Future<void> load() async {
    emit(const MapLoading());
    try {
      final results = await Future.wait([
        _dao.getBeneficiaryMarkers(),
        _dao.getActivityMarkers(),
      ]);
      emit(
        MapLoaded(
          beneficiaryMarkers: results[0],
          activityMarkers: results[1],
          showBeneficiaries: true,
          showActivities: true,
        ),
      );
    } catch (e) {
      emit(MapError(message: e.toString()));
    }
  }

  void toggleBeneficiaries() {
    if (state is! MapLoaded) return;
    final s = state as MapLoaded;
    emit(s.copyWith(showBeneficiaries: !s.showBeneficiaries));
  }

  void toggleActivities() {
    if (state is! MapLoaded) return;
    final s = state as MapLoaded;
    emit(s.copyWith(showActivities: !s.showActivities));
  }
}
