import 'package:geolocator/geolocator.dart';

import '../error/failures.dart';

/// Thin wrapper around [Geolocator] that handles permission checks and
/// returns a typed [Result].
class LocationService {
  const LocationService();

  /// Requests location permission if not already granted and returns the
  /// current [Position], or an [Err] describing why it failed.
  Future<Result<Position>> getCurrentPosition() async {
    // Check whether location services are enabled on the device.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const Err(
        PermissionFailure(permissionName: 'Location services are disabled.'),
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const Err(
          PermissionFailure(
            permissionName: 'Location permission denied.',
          ),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const Err(
        PermissionFailure(
          permissionName:
              'Location permission permanently denied. Enable it in Settings.',
        ),
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return Success(position);
    } catch (e) {
      return Err(NetworkFailure(message: e.toString()));
    }
  }
}
