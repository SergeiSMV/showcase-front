
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../account/account_screen.dart';
import '../auth/auth.dart';
import '../cart/cart_screen.dart';
import '../categories/subcategories_screen.dart';
import '../categories/categories_screen.dart';
import '../products/products_screen.dart';
import '../home/home_screen.dart';
import '../search/serch_screen.dart';
import 'bottom_nav_bar.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        body: child,
        bottomNavigationBar: const BottomNavBar(),
      ),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: HomeScreen()),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const Auth(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: Auth()),
        ),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: CategoriesScreen()),
        ),
        GoRoute(
          path: '/categories/:categoryId',
          pageBuilder: (context, state) {
            int.parse(state.pathParameters['categoryId']!);
            final extra = state.extra as Map<String, dynamic>;
            final mainCategory = extra['mainCategory'] as String;
            final subCategories = extra['subCategories'] as List<dynamic>;
            final mainCategoryID = extra['mainCategoryID'] as int;
            return NoTransitionPage<void>(child: SubCategoriesScreen(subCategories: subCategories, mainCategory: mainCategory, mainCategoryID: mainCategoryID,));
          },
        ),
        GoRoute(
          path: '/products',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final mainCategory = extra['mainCategory'] as String;
            final categoryID = extra['categoryID'] as int;
            return NoTransitionPage<void>(child: ProductsScreen(categoryID: categoryID, mainCategory: mainCategory,));
          },
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
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: SearchScreen()),
        ),
      ],
    ),
  ],
);
