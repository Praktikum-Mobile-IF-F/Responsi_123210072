import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsi072/screens/favorite_screen.dart';
import 'package:responsi072/screens/home_screen.dart';
import 'package:responsi072/screens/main_wrapper.dart';
import 'package:responsi072/screens/profile_screen.dart';
import 'package:responsi072/screens/sign_in_screen.dart';
import 'package:responsi072/screens/sign_up_screen.dart';

class AppNavigation {
  AppNavigation._();

  static String initial = "/signin";

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorFavorite = GlobalKey<NavigatorState>(debugLabel: 'shellFavorite');
  static final _shellNavigatorProfile = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      /// SignUp
      GoRoute(
        path: "/signup",
        name: "signup",
        builder: (BuildContext context, GoRouterState state) => const SignUpScreen(),
      ),

      /// SignIn
      GoRoute(
        path: "/signin",
        name: "signin",
        builder: (BuildContext context, GoRouterState state) => const SignInScreen(),
      ),

      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          /// Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: "/home",
                name: "home",
                builder: (BuildContext context, GoRouterState state) =>
                HomeScreen(),
              ),
            ],
          ),

          /// Favorite
          StatefulShellBranch(
            navigatorKey: _shellNavigatorFavorite,
            routes: <RouteBase>[
              GoRoute(
                path: "/favorite",
                name: "favorite",
                builder: (BuildContext context, GoRouterState state) =>
                const FavoriteScreen(),
              ),
            ],
          ),



          /// Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: <RouteBase>[
              GoRoute(
                path: "/profile",
                name: "profile",
                builder: (BuildContext context, GoRouterState state) =>
                const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
