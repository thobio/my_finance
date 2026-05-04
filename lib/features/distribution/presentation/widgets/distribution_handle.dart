import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class DistributionHandle extends StatelessWidget {
  const DistributionHandle({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
