
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../widgets/auth_required.dart';
import 'cabinet/cabinet.dart';


class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {

  @override
  Widget build(BuildContext context) {

    final String clientID = ref.watch(tokenProvider);

    return PopScope(
      onPopInvoked: (result){
        int lastIndex = ref.read(lastIndexProvider);
        int currenIndex = ref.read(bottomNavIndexProvider);
        result ?
        lastIndex == currenIndex ? null : ref.read(bottomNavIndexProvider.notifier).state = lastIndex : null;
      },
      child: SafeArea(
        child: clientID.isEmpty ? authRequired(context) : const Cabinet()
      ),
    );
  }
}