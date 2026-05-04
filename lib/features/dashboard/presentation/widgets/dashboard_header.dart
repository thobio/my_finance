import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/domain/models/auth_user.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.user,
    required this.selectedMonth,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final AuthUser? user;
  final DateTime selectedMonth;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final isCurrentMonth =
        selectedMonth.year == now.year && selectedMonth.month == now.month;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      user?.displayName?.split(' ').first ?? 'there',
                      style: AppTextStyles.headlineMedium
                          .copyWith(color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
              if (user?.photoURL != null)
                ClipOval(
                  child: Image.network(
                    user!.photoURL!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context2, e, trace) => _fallbackAvatar(),
                  ),
                )
              else
                _fallbackAvatar(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: onPrevMonth,
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Text(
                DateFormat('MMMM yyyy').format(selectedMonth),
                style: AppTextStyles.titleMedium
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: isCurrentMonth
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.2)
                      : theme.colorScheme.onSurface,
                ),
                onPressed: isCurrentMonth ? null : onNextMonth,
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fallbackAvatar() => CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.electricBlue.withValues(alpha: 0.2),
        child: const Icon(
          Icons.person_outline,
          color: AppColors.electricBlue,
          size: 20,
        ),
      );

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 17) return 'Good afternoon,';
    return 'Good evening,';
  }
}
