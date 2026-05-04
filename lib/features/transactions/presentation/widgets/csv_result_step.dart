import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/services/csv_import_service.dart';
import 'csv_import_stat.dart';

class CsvResultStep extends StatelessWidget {
  const CsvResultStep({
    super.key,
    required this.result,
    required this.onDone,
  });

  final CsvImportResult result;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Import Complete',
          style: AppTextStyles.titleLarge
              .copyWith(color: theme.colorScheme.onSurface),
        ),
        const SizedBox(height: 24),
        CsvImportStat(
          icon: Icons.check_circle_outline,
          color: AppColors.success,
          label: 'Imported',
          count: result.imported.length,
        ),
        const SizedBox(height: 8),
        CsvImportStat(
          icon: Icons.copy_outlined,
          color: AppColors.warning,
          label: 'Duplicates skipped',
          count: result.duplicates.length,
        ),
        const SizedBox(height: 8),
        CsvImportStat(
          icon: Icons.error_outline,
          color: AppColors.danger,
          label: 'Failed to parse',
          count: result.failed.length,
        ),
        if (result.failed.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Parse errors:',
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          ...result.failed.map(
            (e) => Text(
              'Row ${e.rowIndex}: ${e.reason}',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
            ),
          ),
        ],
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onDone,
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }
}
