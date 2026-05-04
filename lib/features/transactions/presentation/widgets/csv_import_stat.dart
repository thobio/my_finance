import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';

class CsvImportStat extends StatelessWidget {
  const CsvImportStat({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Text(
          count.toString(),
          style: AppTextStyles.titleMedium.copyWith(color: color),
        ),
      ],
    );
  }
}
