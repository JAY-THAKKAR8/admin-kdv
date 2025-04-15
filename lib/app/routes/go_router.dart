import 'dart:async';

import 'package:admin_kdv/app/routes/app_route.dart';
import 'package:admin_kdv/expenses/view/add_expanses_page.dart';
import 'package:admin_kdv/expenses/view/expenses_page.dart';
import 'package:admin_kdv/home/view/home_page.dart';
import 'package:admin_kdv/login/views/login_page.dart';
import 'package:admin_kdv/maintenance/view/maintenance_page.dart';
import 'package:admin_kdv/master/master_page.dart';
import 'package:admin_kdv/splash/splash_page.dart';
import 'package:admin_kdv/user/view/add_user_page.dart';
import 'package:admin_kdv/user/view/user_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorUserKey = GlobalKey<NavigatorState>(debugLabel: 'user');
final _shellNavigatorExpenseKey = GlobalKey<NavigatorState>(debugLabel: 'expense');
final _shellNavigatorMaintenanceKey = GlobalKey<NavigatorState>(debugLabel: 'maintenance');

final goRouter = GoRouter(
  debugLogDiagnostics: kDebugMode,
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.login.route,
  routes: [
    GoRoute(
      path: AppRoutes.splash.route,
      name: AppRoutes.splash.name,
      pageBuilder: (c, s) => const NoTransitionPage(child: SplashPage()),
    ),
    GoRoute(
      path: AppRoutes.login.route,
      name: AppRoutes.login.name,
      pageBuilder: (c, s) => const NoTransitionPage(child: LoginPage()),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: AppRoutes.home.route,
              name: AppRoutes.home.name,
              builder: (c, s) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorUserKey,
          routes: [
            GoRoute(
                path: AppRoutes.user.route,
                name: AppRoutes.user.name,
                builder: (c, s) => const UsersPage(),
                routes: [
                  GoRoute(
                    path: AppRoutes.addUser.route,
                    name: AppRoutes.addUser.name,
                    builder: (c, s) => const AddUserPage(),
                  ),
                  GoRoute(
                    path: AppRoutes.editUser.route,
                    name: AppRoutes.editUser.name,
                    builder: (c, s) => AddUserPage(userId: s.uri.queryParameters['userId']),
                  ),
                ]),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorExpenseKey,
          routes: [
            GoRoute(
                path: AppRoutes.expanses.route,
                name: AppRoutes.expanses.name,
                builder: (c, s) => const ExpansePage(),
                routes: [
                  GoRoute(
                    path: AppRoutes.addExpanses.route,
                    name: AppRoutes.addExpanses.name,
                    builder: (c, s) => const AddExpansePage(),
                  ),
                  GoRoute(
                    path: AppRoutes.editExpanses.route,
                    name: AppRoutes.editExpanses.name,
                    builder: (c, s) => AddExpansePage(expanseId: s.uri.queryParameters['expenseId']),
                  ),
                ]),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorMaintenanceKey,
          routes: [
            GoRoute(
              path: AppRoutes.maintenance.route,
              name: AppRoutes.maintenance.name,
              builder: (c, s) => const MaintenancePage(),
            ),
          ],
        ),
      ],
      builder: (context, state, navigationShell) => MasterPage(navigationShell: navigationShell),
    ),
  ],
);
