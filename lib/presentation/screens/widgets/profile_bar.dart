import 'dart:typed_data';
import 'package:flutter/material.dart';

class ProfileBar extends StatelessWidget {
  final String name;
  final String gretting;
  final Uint8List? imageBytes;

  const ProfileBar({
    super.key,
    required this.name,
    required this.gretting,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: cs.primaryFixedDim,
          backgroundImage: imageBytes != null ? MemoryImage(imageBytes!) : null,
          child: imageBytes == null
              ? Text(
                  name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
                  style: tt.labelSmall?.copyWith(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gretting,
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            Text(name, style: tt.headlineMedium?.copyWith(color: cs.onSurface)),
          ],
        ),
      ],
    );
  }
}
