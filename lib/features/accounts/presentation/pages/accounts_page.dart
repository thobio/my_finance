import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../debts/presentation/pages/debts_page.dart';
import '../../domain/models/account.dart';
import '../providers/account_providers.dart';
import '../widgets/account_card.dart';
import '../widgets/add_edit_account_sheet.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  String _fmt(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
          .format(value);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final totalBalance = ref.watch(totalBalanceProvider);
    final hideBalances = ref.watch(hideBalancesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: Icon(
              hideBalances ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            ),
            tooltip: hideBalances ? 'Show balances' : 'Hide balances',
            onPressed: () => ref
                .read(hideBalancesProvider.notifier)
                .update((s) => !s),
          ),
        ],
      ),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (accounts) => _buildBody(
          context,
          ref,
          accounts,
          totalBalance,
          hideBalances,
          isDark,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddEditAccountSheet.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    List<Account> accounts,
    double totalBalance,
    bool hideBalances,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final activeAccounts = accounts.where((a) => a.isActive).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      children: [
        // Total balance summary header
        _TotalBalanceBanner(
          totalBalance: totalBalance,
          accountCount: activeAccounts.length,
          hide: hideBalances,
          formatAmount: _fmt,
          isDark: isDark,
        ),
        const SizedBox(height: 20),

        if (activeAccounts.isEmpty)
          _EmptyState(isDark: isDark)
        else ...[
          Text(
            'My Accounts',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...activeAccounts.map(
            (account) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AccountCard(
                account: account,
                onTap: () => AddEditAccountSheet.show(context, account: account),
              ),
            ),
          ),
        ],

        const SizedBox(height: 8),
        _DebtsSectionHeader(isDark: isDark),
        const SizedBox(height: 4),
        _DebtsPreview(isDark: isDark),
      ],
    );
  }
}

// ── Total balance banner ──────────────────────────────────────────────────────

class _TotalBalanceBanner extends StatelessWidget {
  const _TotalBalanceBanner({
    required this.totalBalance,
    required this.accountCount,
    required this.hide,
    required this.formatAmount,
    required this.isDark,
  });

  final double totalBalance;
  final int accountCount;
  final bool hide;
  final String Function(double) formatAmount;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface =
        isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Total Balance',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hide ? '₹ ••••••' : formatAmount(totalBalance),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: totalBalance >= 0 ? AppColors.success : AppColors.danger,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$accountCount active account${accountCount == 1 ? '' : 's'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Debts section header + preview ───────────────────────────────────────────

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

class _DebtsSectionHeader extends StatelessWidget {
  const _DebtsSectionHeader({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Debts & Loans',
          style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () => _showDebtsSheet(context),
          child: const Text('Manage'),
        ),
      ],
    );
  }
}

class _DebtsPreview extends ConsumerWidget {
  const _DebtsPreview({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GestureDetector(
      onTap: () => _showDebtsSheet(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.credit_card_outlined,
                  color: AppColors.danger, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Track loans & credit card debt',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Payoff planner with avalanche & snowball',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No accounts yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a savings, current, or credit card account',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
