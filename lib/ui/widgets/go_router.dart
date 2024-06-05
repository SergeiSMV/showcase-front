
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/string_routers.dart';
import '../account/account_screen.dart';
import '../cart/cart_screen.dart';
import '../categories/subcategories_screen.dart';
import '../categories/categories_screen.dart';
import '../goods/goods_screen.dart';
import '../home/home_screen.dart';
import 'bottom_nav_bar.dart';

final GoRouter router = GoRouter(
  initialLocation: home,
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        body: child,
        bottomNavigationBar: const BottomNavBar(),
      ),
      routes: [
        GoRoute(
          path: home,
          builder: (context, state) => const HomeScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: HomeScreen()),
        ),
        GoRoute(
          path: categories,
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
          path: '/goods',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final mainCategory = extra['mainCategory'] as String;
            final categoryID = extra['categoryID'] as int;
            return NoTransitionPage<void>(child: GoodsScreen(categoryID: categoryID, mainCategory: mainCategory,));
          },
        ),
        GoRoute(
          path: cart,
          builder: (context, state) => const CartScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: CartScreen()),
        ),
        GoRoute(
          path: account,
          builder: (context, state) => const AccountScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: AccountScreen()),
        ),
      ],
    ),
  ],
);
