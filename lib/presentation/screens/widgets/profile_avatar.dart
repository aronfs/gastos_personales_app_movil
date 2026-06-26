import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:gastos_personales/presentation/providers/profile_provider.dart';

class ProfileAvatar extends StatefulWidget {
  final String initials;
  final double radius;
  final bool showLoadingOverlay;
  final ValueChanged<String>? onImageSelected;

  const ProfileAvatar({
    super.key,
    required this.initials,
    this.radius = 48,
    this.showLoadingOverlay = false,
    this.onImageSelected,
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _selectedFile;

  static const _allowedExtensions = ['jpeg', 'jpg', 'png', 'webp'];
  static const _maxBytes = 5 * 1024 * 1024;

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

    setState(() => _selectedFile = File(picked.path));
    widget.onImageSelected?.call(picked.path);
  }

  String? _validateFile(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (!_allowedExtensions.contains(ext)) {
      return 'Invalid file type. Allowed: ${_allowedExtensions.join(", ")}';
    }
    final file = File(path);
    if (!file.existsSync()) return 'File not found';
    if (file.lengthSync() > _maxBytes) return 'File exceeds 5 MB limit';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Consumer<ProfileImageProvider>(
      builder: (context, provider, _) {
        final hasUploadedImage = provider.imageBytes != null;
        final hasSelectedFile = _selectedFile != null;
        final showImage = hasUploadedImage || hasSelectedFile;

        return GestureDetector(
          onTap: _showSourcePicker,
          child: Stack(
            children: [
              CircleAvatar(
                radius: widget.radius,
                backgroundColor: cs.surface.withValues(alpha: 0.2),
                backgroundImage: hasSelectedFile
                    ? FileImage(_selectedFile!)
                    : (hasUploadedImage
                        ? MemoryImage(provider.imageBytes!)
                        : null),
                child: showImage
                    ? null
                    : Text(
                        widget.initials.isNotEmpty ? widget.initials : '?',
                        style: TextStyle(
                          color: cs.surface,
                          fontSize: widget.radius * 0.65,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              if (widget.showLoadingOverlay || provider.isLoading)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              // ── Edit button overlay ──────────────────────────────
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.surface, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: cs.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
