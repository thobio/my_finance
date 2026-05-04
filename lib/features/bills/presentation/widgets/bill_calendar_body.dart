import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/recurrence.dart';
import 'bill_calendar_grid.dart';
import 'bill_list.dart';
import 'bill_month_header.dart';

class BillCalendarBody extends StatelessWidget {
  const BillCalendarBody({
    super.key,
    required this.recurrences,
    required this.focusedMonth,
    required this.selectedDay,
    required this.isDark,
    required this.onMonthChanged,
    required this.onDaySelected,
  });

  final List<Recurrence> recurrences;
  final DateTime focusedMonth;
  final DateTime? selectedDay;
  final bool isDark;
  final void Function(DateTime) onMonthChanged;
  final void Function(DateTime) onDaySelected;

  List<Recurrence> _billsForDay(DateTime day) {
    return recurrences.where((r) {
      final due = r.nextDueDate;
      return due.year == day.year &&
          due.month == day.month &&
          due.day == day.day;
    }).toList();
  }

  List<Recurrence> _billsForMonth(DateTime month) {
    return recurrences.where((r) {
      final due = r.nextDueDate;
      return due.year == month.year && due.month == month.month;
    }).toList();
  }

  double _totalForMonth(DateTime month) =>
      _billsForMonth(month).fold(0.0, (s, r) => s + r.amount);

  @override
  Widget build(BuildContext context) {
    final selectedBills = selectedDay != null
        ? _billsForDay(selectedDay!)
        : _billsForMonth(focusedMonth);

    final monthTotal = _totalForMonth(focusedMonth);

    return Column(
      children: [
        BillMonthHeader(
          month: focusedMonth,
          total: monthTotal,
          isDark: isDark,
          onPrev: () => onMonthChanged(
              DateTime(focusedMonth.year, focusedMonth.month - 1)),
          onNext: () => onMonthChanged(
              DateTime(focusedMonth.year, focusedMonth.month + 1)),
        ),
        BillCalendarGrid(
          month: focusedMonth,
          recurrences: recurrences,
          selectedDay: selectedDay,
          isDark: isDark,
          onDaySelected: onDaySelected,
        ),
        const Divider(height: 1),
        Expanded(
          child: BillList(
            bills: selectedBills,
            title: selectedDay != null
                ? DateFormat('d MMMM').format(selectedDay!)
                : 'This month',
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}
