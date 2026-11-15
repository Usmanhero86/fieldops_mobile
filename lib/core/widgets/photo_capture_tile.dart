import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../themes/app_colors.dart';

/// A single-photo capture widget — tapping opens a bottom sheet that lets the
/// officer choose between the camera and the gallery.
///
/// Displays a thumbnail preview once a photo has been selected, with a
/// remove button.
class PhotoCaptureTile extends StatefulWidget {
  const PhotoCaptureTile({
    super.key,
    this.label = 'Photo',
    this.onPhotoSelected,
    this.initialPath,
  });

  final String label;

  /// Called with the absolute file path of the selected image, or `null` when
  /// the user removes the photo.
  final void Function(String? path)? onPhotoSelected;

  /// Pre-populate with an existing photo path (e.g. on edit).
  final String? initialPath;

  @override
  State<PhotoCaptureTile> createState() => _PhotoCaptureTileState();
}

class _PhotoCaptureTileState extends State<PhotoCaptureTile> {
  final _picker = ImagePicker();
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _photoPath = widget.initialPath;
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop(); // close bottom sheet
    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1280,
    );
    if (file == null) return;
    setState(() => _photoPath = file.path);
    widget.onPhotoSelected?.call(file.path);
  }

  void _remove() {
    setState(() => _photoPath = null);
    widget.onPhotoSelected?.call(null);
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
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          if (_photoPath != null)
            _PreviewCard(path: _photoPath!, onRemove: _remove)
          else
            _PickerButton(onTap: _showSourceSheet),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _PickerButton extends StatelessWidget {
  const _PickerButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.border,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, color: AppColors.primary, size: 28),
            SizedBox(height: 6),
            Text(
              'Tap to add photo',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.path, required this.onRemove});

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(path),
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
