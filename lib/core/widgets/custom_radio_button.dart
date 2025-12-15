import 'package:flutter/material.dart';

enum SingingCharacter { lafayette, jefferson }

class CustomRadioButton extends StatefulWidget {
  const CustomRadioButton({super.key});

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  SingingCharacter? _character;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFF0ECE9),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          spacing: 16,
          runSpacing: 8,
          children: <Widget>[
            Padding(
              padding:  const EdgeInsets.all(12.0),
              child: Icon(
                Icons.info,
                size: 20,
                color: Colors.black54,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Status"),
                Radio<SingingCharacter>(
                  value: SingingCharacter.lafayette,
                  groupValue: _character,
                  onChanged: (value) {
                    setState(() => _character = value);
                  },
                ),
                const Text('A'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<SingingCharacter>(
                  value: SingingCharacter.jefferson,
                  groupValue: _character,
                  onChanged: (value) {
                    setState(() => _character = value);
                  },
                ),
                const Text('B'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
