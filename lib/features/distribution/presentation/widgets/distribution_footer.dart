import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class DistributionFooter extends StatelessWidget {
  const DistributionFooter({
    super.key,
    required this.onAccept,
    required this.isDark,
  });

  final VoidCallback onAccept;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onAccept,
          icon: const Icon(Icons.check_rounded),
          label: const Text('Accept Distribution'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.success,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
