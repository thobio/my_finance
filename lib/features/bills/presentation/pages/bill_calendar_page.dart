import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recurrence_providers.dart';
import '../widgets/add_edit_recurrence_sheet.dart';
import '../widgets/bill_calendar_body.dart';

class BillCalendarPage extends ConsumerStatefulWidget {
  const BillCalendarPage({super.key});

  @override
  ConsumerState<BillCalendarPage> createState() => _BillCalendarPageState();
}

class _BillCalendarPageState extends ConsumerState<BillCalendarPage> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final recurrencesAsync = ref.watch(recurrencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => AddEditRecurrenceSheet.show(context),
            tooltip: 'Add bill',
          ),
        ],
      ),
      body: recurrencesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (recurrences) => BillCalendarBody(
          recurrences: recurrences,
          focusedMonth: _focusedMonth,
          selectedDay: _selectedDay,
          isDark: isDark,
          onMonthChanged: (m) => setState(() {
            _focusedMonth = m;
            _selectedDay = null;
          }),
          onDaySelected: (d) => setState(() => _selectedDay = d),
        ),
      ),
    );
  }
}
