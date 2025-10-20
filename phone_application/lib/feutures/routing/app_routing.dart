/*final router = GoRouter(
  initialLocation: '/notes',
  routes: [
    // BottomNavigationBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          RootScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/views/login.dart',
              builder: (context, state) => const LoginScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/views/general_screen.dart',
              builder: (context, state) => const GeneralScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

 */