
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showcase_front/constants/fonts.dart';

import '../../data/providers.dart';
import 'cabinet/cabinet.dart';


class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {

  @override
  Widget build(BuildContext context) {

    final int clientID = ref.watch(clientIDProvider);

    return PopScope(
      onPopInvoked: (result){
        int lastIndex = ref.read(lastIndexProvider);
        int currenIndex = ref.read(bottomNavIndexProvider);
        result ?
        lastIndex == currenIndex ? null : ref.read(bottomNavIndexProvider.notifier).state = lastIndex : null;
      },
      child: SafeArea(
        child: clientID == 0 ? authButton(context) : const Cabinet()
      ),
    );
  }

  Padding authButton(BuildContext context) {
    return Padding(
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
    );
  }



}