import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../debts/domain/models/debt.dart';
import '../../../debts/presentation/pages/debts_page.dart';

void _showDebtsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, controller) => const ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        child: DebtsPage(),
      ),
    ),
  );
}

class LiabilitiesSection extends StatelessWidget {
  const LiabilitiesSection({
    super.key,
    required this.debts,
    required this.totalLiabilities,
    required this.isDark,
  });

  final List<Debt> debts;
  final double totalLiabilities;
  final bool isDark;

  String _fmt(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
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
              const Icon(Icons.trending_down, size: 18, color: AppColors.danger),
              const SizedBox(width: 8),
              Text(
                'Liabilities',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                _fmt(totalLiabilities),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (debts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No debts tracked. Great work!',
                style: theme.textTheme.bodySmall?.copyWith(color: secondary),
              ),
            ),
          ...debts.map((d) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.credit_card_outlined, size: 16, color: secondary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        d.label,
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _fmt(d.outstanding),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              )),
          if (debts.isNotEmpty) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showDebtsSheet(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Manage debts',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.electricBlue,
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      size: 16, color: AppColors.electricBlue),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
