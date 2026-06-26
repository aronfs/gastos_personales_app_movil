import 'package:flutter/material.dart';

class DeactivateAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeactivateAccountDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Deactivate account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 48, color: cs.error),
          const SizedBox(height: 16),
          const Text(
            'This action will deactivate your account. '
            'You will not be able to log in until an administrator reactivates it.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.error,
            foregroundColor: cs.onError,
          ),
          child: const Text('Deactivate'),
        ),
      ],
    );
  }
}
