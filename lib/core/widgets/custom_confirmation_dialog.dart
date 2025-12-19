import 'package:flutter/material.dart';

Future<void> customConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required Future<bool> Function() onConfirm,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await onConfirm();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
