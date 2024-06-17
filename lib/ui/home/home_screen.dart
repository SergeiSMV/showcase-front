
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcase_front/constants/fonts.dart';
import 'package:showcase_front/constants/server_config.dart';
import 'package:showcase_front/data/repositories/hive_implements.dart';

import '../../data/providers.dart';
import 'change_server.dart';

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
        child: Text('Home Screen', style: darkCategory(18),)
        
        
        /*
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer(
              builder: (context, ref, child) {
                String server = ref.watch(serverURLProvider);
                return Text('сервер: $server', style: black(18),);
              }
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B737),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => changeServer(context, controller).then((_) async {
                  await hive.saveServerURL(controller.text).then((value) => ref.read(serverURLProvider.notifier).state = controller.text.toString());
                }), 
                child: Text('изменить сервер', style: white(16),)
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await hive.saveServerURL(apiURL).then((_) => ref.read(serverURLProvider.notifier).state = apiURL.toString());
                }, 
                child: Text('по умолчанию', style: black(16),)
              ),
            )
          ],
        ),
        */
      ),
    );
  }
}