





import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import 'bottom_nav_bar.dart';

class ShellRouteScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const ShellRouteScaffold({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShellRouteScaffoldState();
}

class _ShellRouteScaffoldState extends ConsumerState<ShellRouteScaffold> {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        bool bottomVisible = ref.watch(bottomNavVisibleProvider);
        return Scaffold(
          body: widget.child,
          bottomNavigationBar: bottomVisible ? const BottomNavBar() : null,
        );
      }
    );
  }
}