import 'package:flutter/material.dart';

import '../../domain/models/year_type.dart';
import 'year_type_tab.dart';

class YearTypeToggle extends StatelessWidget {
  const YearTypeToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final YearType value;
  final ValueChanged<YearType> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.outline.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          YearTypeTab(
            label: 'FY',
            selected: value == YearType.financial,
            onTap: () => onChanged(YearType.financial),
          ),
          YearTypeTab(
            label: 'CY',
            selected: value == YearType.calendar,
            onTap: () => onChanged(YearType.calendar),
          ),
        ],
      ),
    );
  }
}
