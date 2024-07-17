
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcase_front/constants/fonts.dart';
import 'package:showcase_front/data/repositories/hive_implements.dart';

import '../../data/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  TextEditingController controller = TextEditingController(text: 'http://');
  HiveImplements hive = HiveImplements();

  @override
  void initState(){
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (result){
        int lastIndex = ref.read(lastIndexProvider);
        int currenIndex = ref.read(bottomNavIndexProvider);
        result ?
        lastIndex == currenIndex ? null : ref.read(bottomNavIndexProvider.notifier).state = lastIndex : null;
      },
      child: Center(
        child: Text('Home Screen', style: black(18),)
        /*
        InkWell(
          onTap: (){
            ref.read(bottomNavVisibleProvider.notifier).state = false;
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Storis()));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text('promo storis', style: white(18),)
          )
        )
        */
      ),
    );
  }
}