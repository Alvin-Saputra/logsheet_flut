import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class CustomSectionCardData extends StatelessWidget {
  final String label;
  final String value;

  CustomSectionCardData(this.label, this.value);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF655F5B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(), // <-- ini kuncinya
          Text(value, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
