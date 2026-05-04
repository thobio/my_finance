import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/budget.dart';
import '../../domain/models/year_type.dart';
import '../providers/budget_providers.dart';
import '../widgets/add_edit_budget_sheet.dart';
import '../widgets/budget_content.dart';
import '../widgets/year_type_toggle.dart';

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final yearType = ref.watch(selectedYearTypeProvider);
    final year = ref.watch(selectedBudgetYearProvider);
    final budgetAsync = ref.watch(budgetProvider);
    final monthsAsync = ref.watch(budgetMonthsProvider);

    final yearLabel = yearType == YearType.financial
        ? 'FY $year-${(year + 1).toString().substring(2)}'
        : year.toString();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Text(
                      'Budget',
                      style: AppTextStyles.headlineMedium
                          .copyWith(color: theme.colorScheme.onSurface),
                    ),
                    const Spacer(),
                    YearTypeToggle(
                      value: yearType,
                      onChanged: (v) {
                        ref.read(selectedYearTypeProvider.notifier).state = v;
                        final now = DateTime.now();
                        ref.read(selectedBudgetYearProvider.notifier).state =
                            v == YearType.financial
                                ? (now.month >= 4 ? now.year : now.year - 1)
                                : now.year;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () =>
                          ref.read(selectedBudgetYearProvider.notifier).state--,
                    ),
                    Text(
                      yearLabel,
                      style: AppTextStyles.titleMedium
                          .copyWith(color: theme.colorScheme.onSurface),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () =>
                          ref.read(selectedBudgetYearProvider.notifier).state++,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  budgetAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                    data: (budget) => monthsAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data: (months) => BudgetContent(
                        budget: budget,
                        months: months,
                        year: year,
                        yearType: yearType,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _openBudgetSheet(context, ref, ref.read(budgetProvider).valueOrNull),
        tooltip: 'Set up budget',
        child: const Icon(Icons.edit_outlined),
      ),
    );
  }

  void _openBudgetSheet(BuildContext context, WidgetRef ref, Budget? budget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddEditBudgetSheet(budget: budget),
    );
  }
}
