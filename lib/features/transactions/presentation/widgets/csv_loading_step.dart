import 'package:flutter/material.dart';

class CsvLoadingStep extends StatelessWidget {
  const CsvLoadingStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 24),
          Text('Importing transactions…'),
        ],
      ),
    );
  }
}
