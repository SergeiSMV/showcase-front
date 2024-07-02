



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../constants/fonts.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/hive_implements.dart';
import '../../widgets/scaffold_messenger.dart';
import '../responses_view.dart';
import 'requests_view.dart';

class Cabinet extends ConsumerStatefulWidget {
  const Cabinet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CabinetState();
}

class _CabinetState extends ConsumerState<Cabinet> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            header(),
            const SizedBox(height: 15,),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: const [
                  ResponsesView(),
                  SizedBox(height: 5,),
                  RequestsView(),
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header(){
    return Align(
      alignment: Alignment.centerLeft, 
      child: Row(
        children: [
          Expanded(child: Text('Клиент', style: darkCategory(30, FontWeight.bold), overflow: TextOverflow.clip,)),
          InkWell(
            onTap: (){
              GoRouter.of(context).push('/addresses');
            },
            child: Column(
              children: [
                Icon(MdiIcons.mapMarker, size: 25, color: Colors.green,),
                Align(alignment: Alignment.bottomCenter, child: Text('адреса', style: green(12),))
              ],
            ),
          ),
          const SizedBox(width: 15,),
          InkWell(
            onTap: (){
              PaintingBinding.instance.imageCache.clear();
              PaintingBinding.instance.imageCache.clearLiveImages();
              GlobalScaffoldMessenger.instance.showSnackBar("кэш приложения очищен");
            },
            child: Column(
              children: [
                Icon(MdiIcons.sprayBottle, size: 25,),
                Align(alignment: Alignment.bottomCenter, child: Text('кэш', style: black(12),))
              ],
            ),
          ),
          const SizedBox(width: 15,),
          InkWell(
            onTap: () async {
              ref.read(tokenProvider.notifier).state = '';
              ref.read(cartBadgesProvider.notifier).state = 0;
              ref.read(cartProvider.notifier).state = [];
              await HiveImplements().saveToken('');
            },
            child: Column(
              children: [
                Icon(MdiIcons.exitToApp, size: 25,),
                Text('выход', style: black(12),)
              ],
            ),
          ),
          const SizedBox(width: 10,),
        ],
      )
    );
  }


}