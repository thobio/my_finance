import 'package:flutter/material.dart';

import 'insight_severity.dart';
import 'insight_type.dart';

class AppInsight {
  const AppInsight({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.body,
  });

  final String id;
  final InsightType type;
  final InsightSeverity severity;
  final String title;
  final String body;

  Color get severityColor => switch (severity) {
        InsightSeverity.info => const Color(0xFF4F8EFF),
        InsightSeverity.warning => const Color(0xFFFF9800),
        InsightSeverity.critical => const Color(0xFFEF5350),
      };

  IconData get icon => switch (type) {
        InsightType.overspending => Icons.trending_up,
        InsightType.goalBehind => Icons.flag_outlined,
        InsightType.lowSavings => Icons.savings_outlined,
        InsightType.highDebt => Icons.credit_card_outlined,
        InsightType.creditWarning => Icons.warning_amber_outlined,
        InsightType.billOverdue => Icons.calendar_today_outlined,
      };
}
