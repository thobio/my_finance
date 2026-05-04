import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../core/providers/notification_provider.dart';
import '../core/providers/theme_provider.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/bills/presentation/providers/recurrence_providers.dart';
import '../features/transactions/presentation/providers/transaction_providers.dart';

// Breakpoint at which the sidebar replaces the bottom nav
const _kWideBreakpoint = 700.0;

// Max content width on wide screens
const _kMaxContentWidth = 1200.0;

// Mobile bottom nav (6 core destinations)
const _mobileDestinations = [
  (path: '/dashboard', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Home'),
  (path: '/transactions', icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'Transactions'),
  (path: '/goals', icon: Icons.flag_outlined, activeIcon: Icons.flag, label: 'Goals'),
  (path: '/accounts', icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet, label: 'Accounts'),
  (path: '/wishlist', icon: Icons.favorite_border, activeIcon: Icons.favorite, label: 'Wishes'),
  (path: '/settings', icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings'),
];

// Web sidebar — all pages exposed
const _webMainNav = [
  (path: '/dashboard', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard'),
  (path: '/transactions', icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'Transactions'),
  (path: '/budget', icon: Icons.pie_chart_outline, activeIcon: Icons.pie_chart, label: 'Budget'),
  (path: '/goals', icon: Icons.flag_outlined, activeIcon: Icons.flag, label: 'Goals'),
  (path: '/accounts', icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet, label: 'Accounts'),
  (path: '/net-worth', icon: Icons.trending_up_outlined, activeIcon: Icons.trending_up, label: 'Net Worth'),
  (path: '/bills', icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month, label: 'Bills'),
  (path: '/obligations', icon: Icons.checklist_outlined, activeIcon: Icons.checklist, label: 'Obligations'),
  (path: '/analytics', icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Analytics'),
  (path: '/wishlist', icon: Icons.favorite_border, activeIcon: Icons.favorite, label: 'Wishlist'),
];

const _webToolsNav = [
  (path: '/categories', icon: Icons.category_outlined, activeIcon: Icons.category, label: 'Categories'),
  (path: '/tax', icon: Icons.calculate_outlined, activeIcon: Icons.calculate, label: 'Tax Estimator'),
];

class ShellPage extends ConsumerWidget {
  const ShellPage({super.key, required this.child});

  final Widget child;

  int _selectedMobileIndex(String location) {
    for (var i = 0; i < _mobileDestinations.length; i++) {
      if (location.startsWith(_mobileDestinations[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(recurrencesProvider, (_, next) {
      next.whenData((recurrences) {
        ref.read(notificationServiceProvider).checkUpcomingBills(recurrences);
      });
    });

    ref.listen(authUserProvider, (_, next) {
      next.whenData((user) {
        if (user != null) {
          ref.read(categorySeederProvider).seedForUser(user.uid);
        }
      });
    });

    final location = GoRouterState.of(context).uri.toString();
    final width = MediaQuery.sizeOf(context).width;

    if (width >= _kWideBreakpoint) {
      return _WideShell(location: location, child: child);
    }

    final selectedIndex = _selectedMobileIndex(location);
    return _NarrowShell(selectedIndex: selectedIndex, child: child);
  }
}

// ── Wide shell (web / desktop) ────────────────────────────────────────────────

class _WideShell extends ConsumerWidget {
  const _WideShell({required this.location, required this.child});

  final String location;
  final Widget child;

  bool _isActive(String path) =>
      location == path || (path != '/dashboard' && location.startsWith(path));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final user = ref.watch(authUserProvider).valueOrNull;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: Row(
        children: [
          // ── Sidebar ──────────────────────────────────────────────────────
          Container(
            width: 220,
            decoration: BoxDecoration(
              color: surface,
              border: Border(right: BorderSide(color: border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Brand
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.electricBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.account_balance_wallet,
                            color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'My Finance',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.electricBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: border),
                const SizedBox(height: 8),

                // Main navigation
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          child: Text(
                            'MAIN',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        for (final d in _webMainNav)
                          _SideNavItem(
                            icon: d.icon,
                            activeIcon: d.activeIcon,
                            label: d.label,
                            path: d.path,
                            isActive: _isActive(d.path),
                            isDark: isDark,
                          ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          child: Text(
                            'TOOLS',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        for (final d in _webToolsNav)
                          _SideNavItem(
                            icon: d.icon,
                            activeIcon: d.activeIcon,
                            label: d.label,
                            path: d.path,
                            isActive: _isActive(d.path),
                            isDark: isDark,
                          ),
                      ],
                    ),
                  ),
                ),

                // Bottom: theme toggle + user + settings
                Divider(height: 1, color: border),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Tooltip(
                        message: 'Toggle theme',
                        child: IconButton(
                          iconSize: 18,
                          icon: Icon(
                            themeMode == ThemeMode.dark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          onPressed: () {
                            final next = themeMode == ThemeMode.dark
                                ? ThemeMode.light
                                : ThemeMode.dark;
                            ref.read(themeModeProvider.notifier).setTheme(next);
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (user != null) ...[
                        if (user.photoURL != null)
                          ClipOval(
                            child: Image.network(
                              user.photoURL!,
                              width: 28,
                              height: 28,
                              fit: BoxFit.cover,
                              errorBuilder: (context, e, st) =>
                                  _avatarFallback(user.displayName, 14),
                            ),
                          )
                        else
                          _avatarFallback(user.displayName, 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user.displayName?.split(' ').first ??
                                user.email?.split('@').first ??
                                '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      IconButton(
                        iconSize: 18,
                        icon: Icon(
                          Icons.settings_outlined,
                          color: _isActive('/settings')
                              ? AppColors.electricBlue
                              : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                        ),
                        tooltip: 'Settings',
                        onPressed: () => context.go('/settings'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Main content area ─────────────────────────────────────────────
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback(String? displayName, double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.electricBlue,
      child: Text(
        displayName?.isNotEmpty == true
            ? displayName![0].toUpperCase()
            : '?',
        style: TextStyle(
          fontSize: radius * 0.9,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
    required this.isActive,
    required this.isDark,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;
  final bool isActive;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? AppColors.electricBlue : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: InkWell(
        onTap: () => context.go(path),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.electricBlue.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(isActive ? activeIcon : icon, size: 18, color: color),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
              ),
              if (isActive) ...[
                const Spacer(),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.electricBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Narrow shell (mobile) ─────────────────────────────────────────────────────

class _NarrowShell extends StatelessWidget {
  const _NarrowShell({required this.child, required this.selectedIndex});

  final Widget child;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: surface,
          border: Border(top: BorderSide(color: border)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final d in _mobileDestinations)
                  _NavItem(
                    icon: d.icon,
                    activeIcon: d.activeIcon,
                    label: d.label,
                    path: d.path,
                    isActive: selectedIndex == _mobileDestinations.indexOf(d),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
    required this.isActive,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.electricBlue : AppColors.darkTextSecondary;

    return GestureDetector(
      onTap: () => context.go(path),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
