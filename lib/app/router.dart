import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/transactions/presentation/pages/transactions_page.dart';
import '../features/goals/presentation/pages/goal_detail_page.dart';
import '../features/goals/presentation/pages/goals_page.dart';
import '../features/budget/presentation/pages/budget_page.dart';
import '../features/accounts/presentation/pages/accounts_page.dart';
import '../features/bills/presentation/pages/bill_calendar_page.dart';
import '../features/insights/presentation/pages/analytics_page.dart';
import '../features/net_worth/presentation/pages/net_worth_page.dart';
import '../features/wishlist/presentation/pages/wish_list_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/tax/presentation/pages/tax_page.dart';
import '../features/monthly_obligations/presentation/pages/obligations_page.dart';
import '../features/transactions/presentation/pages/categories_page.dart';
import 'shell_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authUserProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isLoading = authState.isLoading;
      final onLoginPage = state.matchedLocation == '/login';

      if (isLoading) return null;
      if (!isLoggedIn && !onLoginPage) return '/login';
      if (isLoggedIn && onLoginPage) return '/dashboard';
      return null;
    },
    refreshListenable: _AuthStateListenable(ref),
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => ShellPage(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/transactions',
            name: 'transactions',
            builder: (context, state) => const TransactionsPage(),
          ),
          GoRoute(
            path: '/goals',
            name: 'goals',
            builder: (context, state) => const GoalsPage(),
            routes: [
              GoRoute(
                path: ':goalId',
                name: 'goal-detail',
                builder: (context, state) {
                  final goal = state.extra;
                  return GoalDetailPage(
                    goalId: state.pathParameters['goalId']!,
                    initialGoal: goal,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/budget',
            name: 'budget',
            builder: (context, state) => const BudgetPage(),
          ),
          GoRoute(
            path: '/accounts',
            name: 'accounts',
            builder: (context, state) => const AccountsPage(),
          ),
          GoRoute(
            path: '/bills',
            name: 'bills',
            builder: (context, state) => const BillCalendarPage(),
          ),
          GoRoute(
            path: '/obligations',
            name: 'obligations',
            builder: (context, state) => const ObligationsPage(),
          ),
          GoRoute(
            path: '/net-worth',
            name: 'net-worth',
            builder: (context, state) => const NetWorthPage(),
          ),
          GoRoute(
            path: '/analytics',
            name: 'analytics',
            builder: (context, state) => const AnalyticsPage(),
          ),
          GoRoute(
            path: '/wishlist',
            name: 'wishlist',
            builder: (context, state) => const WishListPage(),
          ),
          GoRoute(
            path: '/tax',
            name: 'tax',
            builder: (context, state) => const TaxPage(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/categories',
            name: 'categories',
            builder: (context, state) => const CategoriesPage(),
          ),
        ],
      ),
    ],
  );
});

class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(Ref<dynamic> ref) {
    ref.listen(authUserProvider, (prev, next) => notifyListeners());
  }
}
