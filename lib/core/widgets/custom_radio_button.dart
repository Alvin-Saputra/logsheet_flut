import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? title;

  const CustomRadioButton({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF0ECE9),
      ),
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          if (title != null)
            Text(title!, style: const TextStyle(fontWeight: FontWeight.bold)),

          ...options.map((option) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: option,
                  groupValue: value,
                  onChanged: onChanged,
                ),
                Text(option),
              ],
            );
          }),
        ],
      ),
    );
  }
}
