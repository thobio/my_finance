import 'package:flutter/material.dart';

class CsvColumnDropdown extends StatelessWidget {
  const CsvColumnDropdown({
    super.key,
    required this.label,
    required this.headers,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final List<String> headers;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: value,
      decoration: InputDecoration(labelText: label),
      items: [
        const DropdownMenuItem(child: Text('— select —')),
        ...headers.map(
          (h) => DropdownMenuItem(value: h, child: Text(h)),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
