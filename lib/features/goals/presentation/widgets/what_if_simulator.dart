import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/goal.dart';

class WhatIfSimulator extends StatefulWidget {
  const WhatIfSimulator({
    super.key,
    required this.goal,
    required this.accentColor,
  });

  final Goal goal;
  final Color accentColor;

  @override
  State<WhatIfSimulator> createState() => _WhatIfSimulatorState();
}

class _WhatIfSimulatorState extends State<WhatIfSimulator> {
  late double _monthlyAmount;

  double get _remaining =>
      (widget.goal.targetAmount - widget.goal.currentSaved)
          .clamp(0.0, widget.goal.targetAmount);

  double get _defaultMonthly {
    final months = _monthsUntil(widget.goal.targetDate);
    if (months <= 0 || _remaining <= 0) return 0.0;
    return (_remaining / months).ceilToDouble();
  }

  int _monthsUntil(DateTime date) {
    final now = DateTime.now();
    return math.max(
        0, (date.year - now.year) * 12 + date.month - now.month);
  }

  double get _sliderMax {
    final base = math.max(_defaultMonthly, _remaining);
    return (base * 3.0).ceilToDouble().clamp(1000.0, 500000.0);
  }

  DateTime _projectedDate(double monthlyAmount) {
    if (monthlyAmount <= 0 || _remaining <= 0) return DateTime.now();
    final months = (_remaining / monthlyAmount).ceil();
    final now = DateTime.now();
    return DateTime(now.year, now.month + months);
  }

  @override
  void initState() {
    super.initState();
    _monthlyAmount = _defaultMonthly.toDouble().clamp(0, _sliderMax);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projected = _projectedDate(_monthlyAmount);
    final onTime = !projected.isAfter(widget.goal.targetDate);
    final statusColor = onTime ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate_outlined, size: 16),
              const SizedBox(width: 6),
              Text(
                'What-If Simulator',
                style: AppTextStyles.labelMedium.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'If I save ₹${_fmt(_monthlyAmount)}/month…',
            style: AppTextStyles.bodyMedium
                .copyWith(color: theme.colorScheme.onSurface),
          ),
          Slider(
            value: _monthlyAmount,
            max: _sliderMax,
            divisions: 200,
            activeColor: widget.accentColor,
            onChanged: (v) => setState(() => _monthlyAmount = v),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: statusColor.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Icon(
                  onTime
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_outlined,
                  color: statusColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        onTime ? 'Goal reached on time' : 'Goal delayed',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Projected: ${DateFormat('MMMM yyyy').format(projected)}  '
                        '(target: ${DateFormat('MMM yyyy').format(widget.goal.targetDate)})',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_defaultMonthly > 0) ...[
            const SizedBox(height: 10),
            Text(
              'Need ₹${_fmt(_defaultMonthly)}/mo to hit your target date.',
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _fmt(double v) => NumberFormat('#,##,##0').format(v);
}
