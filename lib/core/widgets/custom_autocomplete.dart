import 'package:flutter/material.dart';

class CustomAutocomplete extends StatelessWidget {
  CustomAutocomplete({super.key, required this.listofData});
  List<String> listofData = [];
  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty)
          return const Iterable<String>.empty();
        return listofData.where(
          (String option) => option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          ),
        );
      },

      // ⭐ CUSTOM TEXT FIELD
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onSubmitted: (value) => onFieldSubmitted(),
          decoration: InputDecoration(
            labelText: "Search No Doc",
            labelStyle: TextStyle(
              color: Color(0xFF655F5B),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: Color(0xFFF0ECE9),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },

      // ⭐ CUSTOM DROPDOWN STYLE
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },

      onSelected: (String selection) {
        debugPrint('You selected: $selection');
      },
    );
  }
}
