import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/models/distribution.dart';
import '../providers/distribution_providers.dart';
import 'distribution_footer.dart';
import 'distribution_handle.dart';
import 'distribution_header.dart';
import 'distribution_line_tile.dart';

class DistributionSheet extends ConsumerStatefulWidget {
  const DistributionSheet({
    super.key,
    required this.sourceTransactionId,
    required this.income,
  });

  final String sourceTransactionId;
  final double income;

  static Future<void> show(
    BuildContext context, {
    required String sourceTransactionId,
    required double income,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DistributionSheet(
        sourceTransactionId: sourceTransactionId,
        income: income,
      ),
    );
  }

  @override
  ConsumerState<DistributionSheet> createState() => _DistributionSheetState();
}

class _DistributionSheetState extends ConsumerState<DistributionSheet> {
  late Distribution _distribution;

  @override
  void initState() {
    super.initState();
    _distribution = ref
        .read(distributionControllerProvider.notifier)
        .computeForIncome(
          sourceTransactionId: widget.sourceTransactionId,
          income: widget.income,
        );
  }

  String _formatAmount(double value) {
    return NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
        .format(value);
  }

  Future<void> _accept() async {
    await ref
        .read(distributionControllerProvider.notifier)
        .saveDistribution(_distribution);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            DistributionHandle(isDark: isDark),
            DistributionHeader(
                income: widget.income,
                formatAmount: _formatAmount),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  ..._distribution.lines.map(
                    (l) => DistributionLineTile(
                      line: l,
                      formatAmount: _formatAmount,
                      total: widget.income,
                    ),
                  ),
                ],
              ),
            ),
            DistributionFooter(onAccept: _accept, isDark: isDark),
          ],
        ),
      ),
    );
  }
}
