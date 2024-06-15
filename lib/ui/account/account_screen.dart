
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_front/constants/fonts.dart';
import 'package:showcase_front/data/repositories/hive_implements.dart';

import '../../data/models/request_model/request_model.dart';
import '../../data/providers.dart';
import '../widgets/loading.dart';
import '../widgets/scaffold_messenger.dart';
import 'request_deteils.dart';




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
        clientID == 0 ? authButton(context) :
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              header(),
              const SizedBox(height: 10,),
              Align(alignment: Alignment.centerLeft, child: Text('Заказы:', style: darkCategory(24, FontWeight.bold),)),
              const Divider(color: Colors.grey, indent: 0, endIndent: 5,),
              requestsViews()
            ],
          ),
        )
      ),
    );
  }

  Expanded requestsViews() {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child){
          return ref.watch(baseRequestsProvider).when(
            loading: () => const Loading(),
            error: (error, _) => Center(child: Text(error.toString())),
            data: (_){
              final allRequests = ref.watch(requestsProvider);
              return allRequests.isEmpty ? Container() :
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: allRequests.length,
                itemBuilder: (BuildContext context, int index){
                  RequestModel request = RequestModel(request: allRequests[index]);
                  return InkWell(
                    onTap: (){
                      requestDetail(context, request.id, request.productsDetails);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 3,
                            color: Colors.transparent,
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('заказ ${request.id}', style: darkCategory(18, FontWeight.w500), overflow: TextOverflow.clip,),
                            const SizedBox(height: 3,),
                            Text(request.created, style: darkCategory(16, FontWeight.normal), overflow: TextOverflow.clip,),
                            const SizedBox(height: 5,),
                            Text('товаров: ${request.products}', style: darkCategory(16, FontWeight.normal), overflow: TextOverflow.clip,),
                            Text('сумма: ${request.total}', style: darkCategory(16, FontWeight.normal), overflow: TextOverflow.clip,),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              );
            },  
          );
        },
      ),
    );
  }

  Widget header(){
    return Align(
      alignment: Alignment.centerLeft, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Клиент', style: darkCategory(30, FontWeight.bold), overflow: TextOverflow.clip,),
              const Expanded(child: SizedBox(width: 10,)),
              IconButton(
                onPressed: () {
                  PaintingBinding.instance.imageCache.clear();
                  PaintingBinding.instance.imageCache.clearLiveImages();
                  GlobalScaffoldMessenger.instance.showSnackBar("кэш приложения очищен");
                }, 
                icon: Icon(MdiIcons.sprayBottle, size: 25,)
              ),
              IconButton(
                onPressed: () async {
                  await HiveImplements().saveToken('').then((_) {
                    ref.invalidate(baseProductsProvider);
                    ref.invalidate(baseCartsProvider);
                    ref.read(isAutgorizedProvider.notifier).state = false;
                    ref.read(clientIDProvider.notifier).state = 0;
                    ref.read(cartBadgesProvider.notifier).state = 0;
                  });
                }, 
                icon: Icon(MdiIcons.exitToApp, size: 25,)
              ),
            ],
          ),
          // Text('id клиента:', style: darkCategory(16, FontWeight.normal), overflow: TextOverflow.clip,),
        ],
      )
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