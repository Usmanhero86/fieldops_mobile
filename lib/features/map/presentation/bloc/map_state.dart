part of 'map_cubit.dart';

sealed class MapState {
  const MapState();
}

final class MapInitial extends MapState {
  const MapInitial();
}

final class MapLoading extends MapState {
  const MapLoading();
}

final class MapLoaded extends MapState {
  const MapLoaded({
    required this.beneficiaryMarkers,
    required this.activityMarkers,
    required this.showBeneficiaries,
    required this.showActivities,
  });

  final List<MapMarkerData> beneficiaryMarkers;
  final List<MapMarkerData> activityMarkers;
  final bool showBeneficiaries;
  final bool showActivities;

  List<MapMarkerData> get visibleMarkers => [
        if (showBeneficiaries) ...beneficiaryMarkers,
        if (showActivities) ...activityMarkers,
      ];

  MapLoaded copyWith({
    bool? showBeneficiaries,
    bool? showActivities,
  }) =>
      MapLoaded(
        beneficiaryMarkers: beneficiaryMarkers,
        activityMarkers: activityMarkers,
        showBeneficiaries:
            showBeneficiaries ?? this.showBeneficiaries,
        showActivities: showActivities ?? this.showActivities,
      );
}

final class MapError extends MapState {
  const MapError({required this.message});
  final String message;
}
