import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../domain/models/account.dart';
import '../providers/account_providers.dart';

class AccountCard extends ConsumerWidget {
  const AccountCard({
    super.key,
    required this.account,
    required this.onTap,
  });

  final Account account;
  final VoidCallback onTap;

  static const double cardWidth = double.infinity;
  static const double cardHeight = 190.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(accountBalanceProvider(account));
    final hideBalances = ref.watch(hideBalancesProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _gradientColors.first.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle chip pattern overlay
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              right: 40,
              top: 60,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            // Card content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: institution + type chip
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (account.institution != null)
                              Text(
                                account.institution!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            Text(
                              account.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      _typeChip,
                    ],
                  ),
                  const Spacer(),
                  // Card number (last 4 digits)
                  if (account.lastFourDigits != null)
                    Text(
                      '•••• •••• •••• ${account.lastFourDigits}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        letterSpacing: 2,
                        fontFamily: 'monospace',
                      ),
                    ),
                  const SizedBox(height: 12),
                  // Bottom row: balance + credit utilization
                  if (account.type == AccountType.creditCard &&
                      account.creditLimit != null)
                    _CreditCardBottom(
                      account: account,
                      balance: balance,
                      hide: hideBalances,
                    )
                  else
                    _BalanceBottom(balance: balance, hide: hideBalances),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> get _gradientColors => switch (account.type) {
        AccountType.savings => AppColors.savingsGradient,
        AccountType.current => AppColors.savingsGradient,
        AccountType.creditCard => AppColors.creditGradient,
        AccountType.cash => AppColors.cashGradient,
        AccountType.loan => AppColors.loanGradient,
      };

  Widget get _typeChip => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          account.type.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}

// ── Balance bottom for non-credit accounts ────────────────────────────────────

class _BalanceBottom extends StatelessWidget {
  const _BalanceBottom({required this.balance, required this.hide});

  final double balance;
  final bool hide;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Balance',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
            const SizedBox(height: 2),
            Text(
              hide ? '₹ ••••••' : _fmt(balance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _fmt(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);
}

// ── Credit card bottom with utilization bar ───────────────────────────────────

class _CreditCardBottom extends StatelessWidget {
  const _CreditCardBottom({
    required this.account,
    required this.balance,
    required this.hide,
  });

  final Account account;
  final double balance;
  final bool hide;

  String _fmt(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);

  @override
  Widget build(BuildContext context) {
    final limit = account.creditLimit!;
    final used = balance.clamp(0.0, limit);
    final available = (limit - used).clamp(0.0, limit);
    final pct = limit > 0 ? used / limit : 0.0;

    final barColor = pct < 0.3
        ? AppColors.success
        : pct < 0.7
            ? AppColors.warning
            : AppColors.danger;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                Text(
                  hide ? '₹ ••••••' : _fmt(available),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              hide ? '••%' : '${(pct * 100).toStringAsFixed(0)}% used',
              style: TextStyle(color: barColor, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: pct.clamp(0.0, 1.0),
            minHeight: 4,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation(barColor),
          ),
        ),
      ],
    );
  }
}
