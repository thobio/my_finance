import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/debt_type.dart';

class CreditUtilizationCard extends StatelessWidget {
  const CreditUtilizationCard({
    super.key,
    required this.debts,
    required this.isDark,
  });

  final List<Debt> debts;
  final bool isDark;

  String _fmt(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);

  Color _utilizationColor(double pct) {
    if (pct < 30) return const Color(0xFF4CAF50);
    if (pct < 70) return AppColors.gold;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cards = debts
        .where((d) => d.type == DebtType.creditCard && d.creditLimit != null && d.creditLimit! > 0)
        .toList();

    if (cards.isEmpty) return const SizedBox.shrink();

    final totalOutstanding = cards.fold(0.0, (s, d) => s + d.outstanding);
    final totalLimit =
        cards.fold(0.0, (s, d) => s + (d.creditLimit ?? 0.0));
    final overallPct = totalLimit > 0 ? totalOutstanding / totalLimit * 100 : 0.0;

    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.credit_score_outlined,
                  size: 18, color: AppColors.electricBlue),
              const SizedBox(width: 8),
              Text(
                'Credit Utilization',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${overallPct.toStringAsFixed(1)}%',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _utilizationColor(overallPct),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Overall bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (overallPct / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: border,
              valueColor: AlwaysStoppedAnimation(
                  _utilizationColor(overallPct)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_fmt(totalOutstanding)} used of ${_fmt(totalLimit)} limit',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          if (cards.length > 1) ...[
            const SizedBox(height: 12),
            ...cards.map((d) {
              final pct = d.creditLimit! > 0
                  ? d.outstanding / d.creditLimit! * 100
                  : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        d.label,
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: (pct / 100).clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: border,
                          valueColor: AlwaysStoppedAnimation(
                              _utilizationColor(pct)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${pct.toStringAsFixed(0)}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _utilizationColor(pct),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 4),
          Text(
            'Keep utilization below 30% for a healthy credit score',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
