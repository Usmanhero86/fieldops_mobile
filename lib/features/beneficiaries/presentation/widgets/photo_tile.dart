import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class PhotoTile extends StatelessWidget {
  const PhotoTile({super.key,
    required this.hasPhoto,
    required this.onAdd,
    required this.onRemove,
    this.photoPath,
  });

  final bool hasPhoto;
  final String? photoPath;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: hasPhoto
          ? Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: photoPath != null
                  ? Image.file(
                File(photoPath!),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 56,
                height: 56,
                color: AppColors.primary.withValues(alpha: 0.12),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Photo added',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Tap × to remove and retake',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: AppColors.textSecondary,
                size: 18,
              ),
              onPressed: onRemove,
            ),
          ],
        ),
      )
          : SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(
            Icons.add_a_photo_outlined,
            color: AppColors.primary,
          ),
          label: const Text(
            '  Add Photo',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

