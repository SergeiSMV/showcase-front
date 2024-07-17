
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/request_model/request_model.dart';
import '../../data/models/response_model/response_model.dart';
import '../account/account_screen.dart';
import '../account/request_deteils.dart';
import '../account/response_deteils.dart';
import '../account/ships_view.dart';
import '../auth/auth.dart';
import '../cart/additional_info.dart';
import '../cart/cart_screen.dart';
import '../categories/subcategories_screen.dart';
import '../categories/categories_screen.dart';
import '../products/products_screen.dart';
import '../home/home_screen.dart';
import '../registration/registration.dart';
import '../search/search_by_category_screen.dart';
import '../search/serch_screen.dart';
import 'shell_route_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {        
        return ShellRouteScaffold(child: child);
        /*
        Scaffold(
          body: child,
          bottomNavigationBar: const BottomNavBar(),
        );
        */
      },
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
          path: '/registration',
          builder: (context, state) => const Registration(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: Registration()),
        ),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: CategoriesScreen()),
          routes: [
            GoRoute(
              path: ':categoryId',
              pageBuilder: (context, state) {
                int.parse(state.pathParameters['categoryId']!);
                final extra = state.extra as Map<String, dynamic>;
                final mainCategory = extra['mainCategory'] as String;
                final subCategories = extra['subCategories'] as List<dynamic>;
                final mainCategoryID = extra['mainCategoryID'] as int;
                return NoTransitionPage<void>(child: SubCategoriesScreen(subCategories: subCategories, mainCategory: mainCategory, mainCategoryID: mainCategoryID,));
              },
              routes: [
                GoRoute(
                  path: 'products',
                  pageBuilder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>;
                    final mainCategory = extra['mainCategory'] as String;
                    final categoryID = extra['categoryID'] as int;
                    return NoTransitionPage<void>(child: ProductsScreen(categoryID: categoryID, mainCategory: mainCategory,));
                  },
                ),
              ]
            ),
          ]
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
          path: '/request_detail',
          builder: (context, state) => const SearchScreen(),
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final request = extra['request'] as RequestModel;
            return NoTransitionPage<void>(child: RequestDetail(request: request));
          }
        ),
        GoRoute(
          path: '/response_detail',
          builder: (context, state) => const SearchScreen(),
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final response = extra['response'] as ResponseModel;
            return NoTransitionPage<void>(child: ResponseDetail(response: response,));
          }
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: SearchScreen()),
        ),
        GoRoute(
          path: '/search_by_id',
          builder: (context, state) => const SearchScreen(),
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final mainCategory = extra['mainCategory'] as String;
            final categoryID = extra['categoryID'] as int;
            return NoTransitionPage<void>(child: SearchByCategoryScreen(mainCategory: mainCategory, mainCategoryID: categoryID,));
          }
        ),
        GoRoute(
          path: '/addresses',
          builder: (context, state) => const ShipsView(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: ShipsView()),
        ),
        GoRoute(
          path: '/additinal_info',
          builder: (context, state) => const AdditionalInfo(),
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: AdditionalInfo()),
        ),
      ],
    ),
  ], 
);
