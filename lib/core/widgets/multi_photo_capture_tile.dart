import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../themes/app_colors.dart';

/// Multi-photo capture widget used by the Field Activity form.
///
/// Displays a scrollable row of thumbnails. The officer taps the ➕ tile to
/// add more photos (up to [maxPhotos]).  Each thumbnail has a remove button.
class MultiPhotoCaptureTile extends StatefulWidget {
  const MultiPhotoCaptureTile({
    super.key,
    this.label = 'Photos',
    this.maxPhotos = 5,
    this.onPhotosChanged,
    this.initialPaths = const [],
  });

  final String label;
  final int maxPhotos;

  /// Called with the current list of absolute file paths whenever it changes.
  final void Function(List<String> paths)? onPhotosChanged;

  final List<String> initialPaths;

  @override
  State<MultiPhotoCaptureTile> createState() => _MultiPhotoCaptureTileState();
}

class _MultiPhotoCaptureTileState extends State<MultiPhotoCaptureTile> {
  final _picker = ImagePicker();
  late final List<String> _paths;

  @override
  void initState() {
    super.initState();
    _paths = List<String>.from(widget.initialPaths);
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop();
    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1280,
    );
    if (file == null) return;
    setState(() => _paths.add(file.path));
    widget.onPhotosChanged?.call(List.unmodifiable(_paths));
  }

  void _remove(int index) {
    setState(() => _paths.removeAt(index));
    widget.onPhotosChanged?.call(List.unmodifiable(_paths));
  }

  void _showSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take photo'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Choose from gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canAdd = _paths.length < widget.maxPhotos;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(${_paths.length}/${widget.maxPhotos})',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Existing thumbnails
                for (int i = 0; i < _paths.length; i++)
                  _Thumbnail(
                    path: _paths[i],
                    onRemove: () => _remove(i),
                  ),
                // Add-photo tile
                if (canAdd)
                  GestureDetector(
                    onTap: _showSourceSheet,
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.path, required this.onRemove});

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(3),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
