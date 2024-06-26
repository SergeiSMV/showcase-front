import 'dart:async';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:showcase_front/constants/secret_jwt.dart';
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

class _AppState extends ConsumerState<App> {

  Timer? connectMonitoring;

  @override
  void initState(){
    super.initState();
    isAutgorized();
    scheduleUpdater();
  }

  @override
  void dispose() {
    connectMonitoring?.cancel();
    super.dispose();
  }

  Future<void> isAutgorized() async {
    HiveImplements hive = HiveImplements();
    String token = await hive.getToken();
    if (token.isNotEmpty) {
      final jwt = JWT.verify(token, SecretKey(secretJWT));
      final payload = jwt.payload;
      ref.read(isAutgorizedProvider.notifier).state = true;
      ref.read(clientIDProvider.notifier).state = payload['client_id'];
      return ref.refresh(baseCartsProvider);
    }
    
  }

  void scheduleUpdater() {
    if (connectMonitoring != null) {
      connectMonitoring!.cancel();
    }
    connectMonitoring = Timer.periodic(const Duration(seconds: 10), (timer) {
      final int clientID = ref.read(clientIDProvider);
      if (clientID != 0){
        print('обновление разделов!');
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



/*
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    isAutgorized(ref);

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
*/



