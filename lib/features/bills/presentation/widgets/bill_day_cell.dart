import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class BillDayCell extends StatelessWidget {
  const BillDayCell({
    super.key,
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.hasBill,
    required this.isDark,
    required this.onTap,
  });

  final int day;
  final bool isToday;
  final bool isSelected;
  final bool hasBill;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color? bgColor;
    Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    if (isSelected) {
      bgColor = AppColors.electricBlue;
      textColor = Colors.white;
    } else if (isToday) {
      bgColor = AppColors.electricBlue.withValues(alpha: 0.2);
      textColor = AppColors.electricBlue;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$day',
              style: theme.textTheme.bodySmall?.copyWith(
                color: textColor,
                fontWeight:
                    isToday || isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (hasBill)
              Positioned(
                bottom: 3,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
