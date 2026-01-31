import 'package:flutter/material.dart';

Future<bool?> selectProductionDataDialog(BuildContext context) {
  return showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Konfirmasi Pilihan"),
        content: const Text("Apakah Anda Ingin Memilih Data Production Ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Returns false
            child: const Text("Tidak", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // Returns true
            child: const Text("Ya"),
          ),
        ],
      );
    },
  );
}