

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:showcase_front/constants/fonts.dart';
// import 'package:showcase_front/ui/account_screen.dart';
// import 'package:showcase_front/ui/cart_screen.dart';

// import '../data/providers.dart';
// import 'catalog_screen.dart';
// import 'home_screen.dart';

// class MainScreen extends ConsumerStatefulWidget {
//   const MainScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
// }

// class _MainScreenState extends ConsumerState<MainScreen> {

//   final List<Widget> screens = [const HomeScreen(), const CatalogScreen(), const CartScreen(), const AccountScreen()]; 

//   @override
//   void initState(){
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//     ));
//   }

//   Widget bottomNavBar(){
//     return GNav(
//       backgroundColor: Colors.white,
//       textStyle: black(14),
//       tabMargin: const EdgeInsets.symmetric(vertical: 10),
//       activeColor: Colors.black,
//       color: Colors.grey,
//       iconSize: 27,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       duration: const Duration(milliseconds: 400),
//       tabBackgroundColor: Colors.transparent,
//       tabs: [
//         GButton(
//           icon: MdiIcons.home,
//         ),
//         GButton(
//           icon: MdiIcons.magnify,
//         ),
//         GButton(
//           icon: MdiIcons.cart,
//         ),
//         GButton(
//           icon: MdiIcons.account,
//         ),
//       ],
//       onTabChange: (index) {
//         ref.read(bottomNavIndexProvider.notifier).state = index;
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Consumer(
//           builder: (context, ref, child) {
//             final selectedIndex = ref.watch(bottomNavIndexProvider);
//             return screens[selectedIndex];
//           }
//         ),
//       ),
//       bottomNavigationBar: bottomNavBar(),
//     );
//   }
// }