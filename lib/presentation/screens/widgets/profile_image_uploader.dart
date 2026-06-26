import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageUploader extends StatefulWidget {
  final Function(String filePath) onImageSelected;

  const ProfileImageUploader({super.key, required this.onImageSelected});

  @override
  State<ProfileImageUploader> createState() => _ProfileImageUploaderState();
}

class _ProfileImageUploaderState extends State<ProfileImageUploader> {
  File? _previewFile;

  static const _allowedExtensions = ['jpeg', 'jpg', 'png', 'webp'];
  static const _maxBytes = 5 * 1024 * 1024;

  String? _validateFile(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (!_allowedExtensions.contains(ext)) {
      return 'Invalid file type. Allowed: ${_allowedExtensions.join(", ")}';
    }
    final file = File(path);
    if (!file.existsSync()) {
      return 'File not found';
    }
    if (file.lengthSync() > _maxBytes) {
      return 'File exceeds 5 MB limit';
    }
    return null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    final error = _validateFile(picked.path);
    if (error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
      return;
    }

    setState(() => _previewFile = File(picked.path));
  }

  void _showSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        if (_previewFile != null) ...[
          CircleAvatar(
            radius: 60,
            backgroundImage: FileImage(_previewFile!),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => widget.onImageSelected(_previewFile!.path),
                icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                label: const Text('Upload'),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () => setState(() => _previewFile = null),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ] else ...[
          CircleAvatar(
            radius: 60,
            backgroundColor: cs.surfaceContainerLow,
            child: Icon(Icons.camera_alt, size: 36, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showSourcePicker,
            icon: const Icon(Icons.add_a_photo_outlined, size: 18),
            label: const Text('Select image'),
          ),
        ],
      ],
    );
  }
}
