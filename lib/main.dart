// ignore_for_file: unused_result

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:showcase_front/data/repositories/hive_implements.dart';

import 'data/providers.dart';
import 'ui/widgets/go_router.dart';
import 'ui/widgets/scaffold_messenger.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  await Hive.openBox('mainStorage');
  runApp(const ProviderScope(child: App())
  );
}



class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {

  Timer? connectMonitoring;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isAutgorized();
    scheduleUpdater();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    connectMonitoring?.cancel();
    super.dispose();
  }

  Future<void> isAutgorized() async {
    HiveImplements hive = HiveImplements();
    String token = await hive.getToken();
    if (token.isNotEmpty) {
      ref.read(tokenProvider.notifier).state = token;
      return ref.refresh(baseCartsProvider);
    }
    
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      connectMonitoring?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      scheduleUpdater();
    }
  }

  void scheduleUpdater() {
    if (connectMonitoring != null) {
      connectMonitoring!.cancel();
    }
    connectMonitoring = Timer.periodic(const Duration(seconds: 10), (timer) {
      final String clientID = ref.read(tokenProvider);
      if (clientID.isNotEmpty){
        ref.refresh(baseRequestsProvider);
        ref.refresh(baseCartsProvider);
        ref.refresh(baseResponsesProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: GlobalScaffoldMessenger.scaffoldMessengerKey,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
    );
  }
}



