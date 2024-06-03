
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/account_screen.dart';
import 'ui/cart_screen.dart';
import 'ui/catalog_item_screen.dart';
import 'ui/catalog_screen.dart';
import 'ui/home_screen.dart';
import 'ui/navigation_bar.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        body: child,
        bottomNavigationBar: const MyNavigationBar(),
      ),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: HomeScreen()),
        ),
        GoRoute(
          path: '/catalog',
          builder: (context, state) => const CatalogScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: CatalogScreen()),
          routes: [
            GoRoute(
              path: 'catalog_id', // Это будет вложенным путем, например '/catalog/42'
              builder: (context, state) {
                return const CatalogItemScreen();
              },
              pageBuilder: (context, state) {
                return const NoTransitionPage<void>(child: CatalogItemScreen());
              }
            ),
          ],
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: CartScreen()),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: AccountScreen()),
        ),
      ],
    ),
  ],
  /*
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/catalog',
      builder: (context, state) => const CatalogScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountScreen(),
    ),
  ],
  */
);
