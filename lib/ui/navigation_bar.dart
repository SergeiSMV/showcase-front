

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants/fonts.dart';
import '../data/providers.dart';

class MyNavigationBar extends ConsumerWidget {
  const MyNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return GNav(
      selectedIndex: currentIndex,
      backgroundColor: Colors.white,
      textStyle: black(14),
      tabMargin: const EdgeInsets.symmetric(vertical: 10),
      activeColor: Colors.black,
      color: Colors.grey,
      iconSize: 27,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      duration: const Duration(milliseconds: 400),
      tabBackgroundColor: Colors.transparent,
      tabs: [
        GButton(
          icon: MdiIcons.home,
        ),
        GButton(
          icon: MdiIcons.magnify,
        ),
        GButton(
          icon: MdiIcons.cart,
        ),
        GButton(
          icon: MdiIcons.account,
        ),
      ],
      onTabChange: (index) {
        ref.read(bottomNavIndexProvider.notifier).state = index;
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/catalog');
            break;
          case 2:
            context.go('/cart');
            break;
          case 3:
            context.go('/account');
            break;
        }
      },
    );
  }
}
