import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';

class TransactionDateDivider extends StatelessWidget {
  const TransactionDateDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 0, 8),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
