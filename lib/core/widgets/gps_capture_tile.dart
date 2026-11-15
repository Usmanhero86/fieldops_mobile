import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../themes/app_colors.dart';
import '../error/failures.dart';
import '../utils/location_service.dart';

/// A tappable tile that captures the device GPS location on demand.
///
/// Shows a spinner while acquiring the fix, then displays the lat/lon pair
/// with a green indicator. Any [PermissionFailure] is shown as an inline
/// error message so the officer can open Settings and retry.
class GpsCaptureTile extends StatefulWidget {
  const GpsCaptureTile({
    super.key,
    this.onLocationCaptured,
    this.initialPosition,
  });

  /// Called with the captured [Position] once a GPS fix is obtained.
  final void Function(Position position)? onLocationCaptured;

  /// Pre-populate the display with an existing position (e.g. on edit).
  final Position? initialPosition;

  @override
  State<GpsCaptureTile> createState() => _GpsCaptureTileState();
}

class _GpsCaptureTileState extends State<GpsCaptureTile> {
  final _locationService = const LocationService();

  Position? _position;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  Future<void> _capture() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _locationService.getCurrentPosition();

    if (!mounted) return;

    switch (result) {
      case Success(:final value):
        setState(() {
          _position = value;
          _loading = false;
        });
        widget.onLocationCaptured?.call(value);

      case Err(:final failure):
        setState(() {
          _error = switch (failure) {
            // ignore: invalid_use_of_visible_for_testing_member
            _ =>
              failure
                  .toString()
                  .replaceFirst(
                    RegExp(r'^[A-Za-z]+Failure\(permissionName: |message: '),
                    '',
                  )
                  .replaceFirst(RegExp(r'\)\s*$'), ''),
          };
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GPS Location',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: _loading ? null : _capture,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _error != null
                      ? AppColors.error
                      : _position != null
                      ? AppColors.success
                      : AppColors.border,
                ),
              ),
              child: _loading
                  ? const Row(
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Acquiring GPS fix…',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    )
                  : _position != null
                  ? Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${_position!.latitude.toStringAsFixed(6)}, '
                            '${_position!.longitude.toStringAsFixed(6)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.refresh,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    )
                  : const Row(
                      children: [
                        Icon(
                          Icons.gps_fixed,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Tap to capture GPS location',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                _error!,
                style: const TextStyle(fontSize: 12, color: AppColors.error),
              ),
            ),
        ],
      ),
    );
  }
}
