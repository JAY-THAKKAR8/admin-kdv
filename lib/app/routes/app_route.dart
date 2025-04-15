class _AppRoute {
  const _AppRoute({
    required this.route,
    required this.name,
  });

  final String route;
  final String name;
}

class AppRoutes {
  static const splash = _AppRoute(route: '/splash', name: 'splash');
  static const login = _AppRoute(route: '/login', name: 'login');
  static const home = _AppRoute(route: '/home', name: 'home');
  static const user = _AppRoute(route: '/user', name: 'user');
  static const addUser = _AppRoute(route: '/add-user', name: 'add-user');
  static const editUser = _AppRoute(route: '/edit-user', name: 'edit-user');
  static const expanses = _AppRoute(route: '/expanses', name: 'expanses');
  static const addExpanses = _AppRoute(route: '/add-expanses', name: 'add-expanses');
  static const editExpanses = _AppRoute(route: '/edit-expanses', name: 'edit-expanses');
  static const maintenance = _AppRoute(route: '/maintenance', name: 'maintenance');
  static const addMaintenance = _AppRoute(route: '/add-maintenance', name: 'add-maintenance');
  static const editMaintenance = _AppRoute(route: '/edit-maintenance', name: 'edit-maintenance');
}
