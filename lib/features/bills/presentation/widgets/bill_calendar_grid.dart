import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/models/recurrence.dart';
import 'bill_day_cell.dart';

class BillCalendarGrid extends StatelessWidget {
  const BillCalendarGrid({
    super.key,
    required this.month,
    required this.recurrences,
    required this.selectedDay,
    required this.isDark,
    required this.onDaySelected,
  });

  final DateTime month;
  final List<Recurrence> recurrences;
  final DateTime? selectedDay;
  final bool isDark;
  final void Function(DateTime) onDaySelected;

  bool _hasBill(int day) {
    return recurrences.any((r) =>
        r.nextDueDate.year == month.year &&
        r.nextDueDate.month == month.month &&
        r.nextDueDate.day == day);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstDay = DateTime(month.year, month.month);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final startWeekday = firstDay.weekday % 7;
    final today = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        children: [
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 4),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              mainAxisExtent: 44,
            ),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (_, index) {
              if (index < startWeekday) return const SizedBox.shrink();
              final day = index - startWeekday + 1;
              final date = DateTime(month.year, month.month, day);
              final isToday = date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;
              final isSelected = selectedDay?.day == day &&
                  selectedDay?.month == month.month &&
                  selectedDay?.year == month.year;

              return BillDayCell(
                day: day,
                isToday: isToday,
                isSelected: isSelected,
                hasBill: _hasBill(day),
                isDark: isDark,
                onTap: () => onDaySelected(date),
              );
            },
          ),
        ],
      ),
    );
  }
}
