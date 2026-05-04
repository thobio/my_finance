import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/payoff_result.dart';
import '../../domain/models/payoff_strategy.dart';
import '../../domain/services/payoff_calculator.dart';

class PayoffPlannerSheet extends StatefulWidget {
  const PayoffPlannerSheet({super.key, required this.debts});

  final List<Debt> debts;

  static Future<void> show(BuildContext context, {required List<Debt> debts}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PayoffPlannerSheet(debts: debts),
    );
  }

  @override
  State<PayoffPlannerSheet> createState() => _PayoffPlannerSheetState();
}

class _PayoffPlannerSheetState extends State<PayoffPlannerSheet> {
  final _budgetCtrl = TextEditingController();
  PayoffResult? _avalanche;
  PayoffResult? _snowball;

  @override
  void dispose() {
    _budgetCtrl.dispose();
    super.dispose();
  }

  void _compute() {
    final budget = double.tryParse(_budgetCtrl.text.trim()) ?? 0.0;
    if (budget <= 0) return;
    setState(() {
      _avalanche = PayoffCalculator.compute(
        debts: widget.debts,
        monthlyBudget: budget,
        strategy: PayoffStrategy.avalanche,
      );
      _snowball = PayoffCalculator.compute(
        debts: widget.debts,
        monthlyBudget: budget,
        strategy: PayoffStrategy.snowball,
      );
    });
  }

  String _fmt(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    final totalOutstanding = widget.debts.fold(0.0, (s, d) => s + d.outstanding);
    final totalMin = widget.debts.fold(0.0, (s, d) => s + d.minimumPayment);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _handle(isDark),
                const SizedBox(height: 8),
                Text(
                  'Debt Payoff Planner',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.debts.length} debt${widget.debts.length == 1 ? '' : 's'} · '
                  'Total: ${_fmt(totalOutstanding)} · '
                  'Min payments: ${_fmt(totalMin)}/mo',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _budgetCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Monthly repayment budget (₹)',
                          prefixText: '₹ ',
                          helperText: 'Enter total amount you can pay each month',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => _compute(),
                      ),
                    ),
                  ],
                ),
                if (_avalanche != null && _snowball != null) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _StrategyCard(
                          strategy: PayoffStrategy.avalanche,
                          result: _avalanche!,
                          formatAmount: _fmt,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StrategyCard(
                          strategy: PayoffStrategy.snowball,
                          result: _snowball!,
                          formatAmount: _fmt,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                  if (_avalanche!.totalInterest < _snowball!.totalInterest)
                    _savingsHint(
                      'Avalanche saves you ${_fmt(_snowball!.totalInterest - _avalanche!.totalInterest)} in interest',
                      isDark,
                      theme,
                    )
                  else if (_snowball!.months < _avalanche!.months)
                    _savingsHint(
                      'Snowball pays off ${_avalanche!.months - _snowball!.months} month${_avalanche!.months - _snowball!.months == 1 ? '' : 's'} sooner',
                      isDark,
                      theme,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _savingsHint(String text, bool isDark, ThemeData theme) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.electricBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline,
                  size: 16, color: AppColors.electricBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.electricBlue),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _handle(bool isDark) => Center(
        child: Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}

// ── Strategy Result Card ──────────────────────────────────────────────────────

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.strategy,
    required this.result,
    required this.formatAmount,
    required this.isDark,
  });

  final PayoffStrategy strategy;
  final PayoffResult result;
  final String Function(double) formatAmount;
  final bool isDark;

  Color get _accent => strategy == PayoffStrategy.avalanche
      ? AppColors.electricBlue
      : AppColors.gold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: _accent.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                strategy.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: _accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            strategy.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const Divider(height: 16),
          _row(theme, 'Payoff time', result.monthsLabel),
          const SizedBox(height: 6),
          _row(theme, 'Total interest', formatAmount(result.totalInterest),
              valueColor: AppColors.danger),
          if (result.payoffOrder.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Payoff order:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                )),
            const SizedBox(height: 4),
            ...result.payoffOrder.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      '${e.key + 1}. ${e.value}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value,
      {Color? valueColor}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              )),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      );
}
