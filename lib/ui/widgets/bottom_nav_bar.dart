import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:badges/badges.dart' as badges;

import '../../constants/fonts.dart';
import '../../data/providers.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return GNav(
      selectedIndex: currentIndex,
      backgroundColor: Colors.white,
      textStyle: black(14),
      tabMargin: const EdgeInsets.only(bottom: 10),
      activeColor: Colors.black87,
      color: Colors.grey.shade400,
      iconSize: 27,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      duration: const Duration(milliseconds: 400),
      tabBackgroundColor: Colors.transparent,
      tabs: [
        GButton(
          icon: MdiIcons.home,
        ),
        GButton(
          icon: MdiIcons.clipboardText,
        ),
        GButton(
          icon: MdiIcons.cart,
          leading: Consumer(
            builder: (context, ref, child) {
              int count = ref.watch(cartBadgesProvider);
              int currenIndex = ref.watch(bottomNavIndexProvider);
              return badges.Badge(
                badgeAnimation: const badges.BadgeAnimation.scale(),
                showBadge: count == 0 ? false : true,
                badgeContent: Text(count.toString(), style: const TextStyle(color: Colors.white)),
                child: Icon(
                  MdiIcons.cart,
                  color: currenIndex == 2 ? Colors.black87 : Colors.grey.shade400,
                ),
              );
            }
          ),
        ),
        GButton(
          icon: MdiIcons.account,
        ),
      ],
      onTabChange: (index) {
        ref.read(bottomNavIndexProvider.notifier).state = index;
        switch (index) {
          case 0:
            GoRouter.of(context).pushReplacement('/');
            break;
          case 1:
            GoRouter.of(context).pushReplacement('/categories');
            break;
          case 2:
            GoRouter.of(context).pushReplacement('/cart');
            break;
          case 3:
            GoRouter.of(context).pushReplacement('/account');
            break;
        }
      },
    );
  }

}
