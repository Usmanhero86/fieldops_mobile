import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/storage/app_database.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../injection_container/injection_container.dart';
import '../../data/map_local_dao.dart';
import '../bloc/map_cubit.dart';

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapCubit(dao: MapLocalDao(sl<AppDatabase>()))..load(),
      child: const _MapView(),
    );
  }
}

// ---------------------------------------------------------------------------
// View
// ---------------------------------------------------------------------------

class _MapView extends StatefulWidget {
  const _MapView();

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  final _mapController = MapController();

  /// Centre on Maiduguri by default — the demo data is clustered there.
  static const _defaultCenter = LatLng(11.8311, 13.1510);
  static const _defaultZoom = 12.0;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _showMarkerDetail(BuildContext context, MapMarkerData marker) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _MarkerDetailSheet(marker: marker),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: false,
        actions: [
          BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              if (state is! MapLoaded) return const SizedBox.shrink();
              return Row(
                children: [
                  _FilterChip(
                    label: 'Beneficiaries',
                    active: state.showBeneficiaries,
                    color: AppColors.primary,
                    onTap: () =>
                        context.read<MapCubit>().toggleBeneficiaries(),
                  ),
                  const SizedBox(width: 4),
                  _FilterChip(
                    label: 'Activities',
                    active: state.showActivities,
                    color: AppColors.success,
                    onTap: () => context.read<MapCubit>().toggleActivities(),
                  ),
                  const SizedBox(width: 8),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          if (state is MapLoading || state is MapInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MapError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.map_outlined,
                      size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  Text(state.message),
                  TextButton(
                    onPressed: () => context.read<MapCubit>().load(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final loaded = state as MapLoaded;
          final markers = loaded.visibleMarkers;

          return FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _defaultCenter,
              initialZoom: _defaultZoom,
              minZoom: 4,
              maxZoom: 18,
            ),
            children: [
              // OpenStreetMap tile layer
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.fieldops.mobile',
                maxNativeZoom: 19,
              ),

              // Marker layer
              MarkerLayer(
                markers: markers.map((m) {
                  final isBeneficiary = m.type == 'beneficiary';
                  return Marker(
                    width: 36,
                    height: 36,
                    point: LatLng(m.latitude, m.longitude),
                    child: GestureDetector(
                      onTap: () => _showMarkerDetail(context, m),
                      child: _MarkerPin(isBeneficiary: isBeneficiary),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),

      // Legend & refresh
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Refresh
          FloatingActionButton.small(
            heroTag: 'map_refresh',
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.primary,
            onPressed: () => context.read<MapCubit>().load(),
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 8),
          // Re-centre
          FloatingActionButton.small(
            heroTag: 'map_centre',
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.primary,
            onPressed: () => _mapController.move(_defaultCenter, _defaultZoom),
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Marker pin widget
// ---------------------------------------------------------------------------

class _MarkerPin extends StatelessWidget {
  const _MarkerPin({required this.isBeneficiary});

  final bool isBeneficiary;

  @override
  Widget build(BuildContext context) {
    final color = isBeneficiary ? AppColors.primary : AppColors.success;
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isBeneficiary ? Icons.person : Icons.assignment,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter chip
// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? color : Colors.white54,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Marker detail bottom sheet
// ---------------------------------------------------------------------------

class _MarkerDetailSheet extends StatelessWidget {
  const _MarkerDetailSheet({required this.marker});

  final MapMarkerData marker;

  @override
  Widget build(BuildContext context) {
    final isBeneficiary = marker.type == 'beneficiary';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Type badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isBeneficiary
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isBeneficiary ? 'Beneficiary' : 'Field Activity',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isBeneficiary
                        ? AppColors.primary
                        : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            marker.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Detail rows
          _DetailRow(
            icon: Icons.location_city_outlined,
            label: 'Community',
            value: marker.subtitle,
          ),
          _DetailRow(
            icon: Icons.folder_open,
            label: 'Project',
            value: marker.detail,
          ),
          if (marker.registeredAt != null)
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: isBeneficiary ? 'Registered' : 'Date',
              value: DateFormat('dd MMM yyyy').format(marker.registeredAt!),
            ),
          if (marker.fieldOfficerName != null)
            _DetailRow(
              icon: Icons.badge_outlined,
              label: 'Field Officer',
              value: marker.fieldOfficerName!,
            ),
          _DetailRow(
            icon: Icons.gps_fixed,
            label: 'Coordinates',
            value:
                '${marker.latitude.toStringAsFixed(5)}, '
                '${marker.longitude.toStringAsFixed(5)}',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          SizedBox(
            width: 88,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
