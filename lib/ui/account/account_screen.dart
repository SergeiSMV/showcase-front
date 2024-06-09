
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showcase_front/constants/fonts.dart';
import 'package:showcase_front/data/repositories/hive_implements.dart';

import '../../data/providers.dart';




class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {

  @override
  Widget build(BuildContext context) {

    final int clientID = ref.watch(clientIDProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: 
        clientID == 0 ?

        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B737),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () { 
                  GoRouter.of(context).push('/auth');
                }, 
                child: Text('авторизоваться', style: white(16),)
              ),
            ),
          ),
        ) :
        
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B737),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async { 
                  await HiveImplements().saveToken('').then((_) {
                    ref.invalidate(baseProductsProvider);
                    ref.invalidate(baseCartsProvider);
                    ref.read(isAutgorizedProvider.notifier).state = false;
                    ref.read(clientIDProvider.notifier).state = 0;
                    // ref.read(bottomNavIndexProvider.notifier).state = 0;
                    ref.read(cartBadgesProvider.notifier).state = 0;
                    // GoRouter.of(context).pushReplacement('/');
                  });
                }, 
                child: Text('выйти', style: white(16),)
              ),
            ),
          ),
        ),
      ),
    );
  }
}





/*
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B737),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async { 
            Future.delayed(const Duration(seconds: 1), () {
              return ref.refresh(baseCategoriesProvider);
            });
          }, 
          child: Text('обновить', style: white(16),)
        ),,
      ),
    );
  }
}
*/