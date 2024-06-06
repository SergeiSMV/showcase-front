





import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showcase_front/constants/fonts.dart';

import '../../data/providers.dart';
import '../widgets/loading.dart';



class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {

  @override
  Widget build(BuildContext context) {

    final int clientID = ref.watch(clientIDProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            clientID == 0 ? 
            ElevatedButton(
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
            ) :
        
            Consumer(
              builder: (context, ref, child){
                return ref.watch(baseCartsProvider(clientID)).when(
                  loading: () => const Loading(),
                  error: (error, _) => Center(child: Text(error.toString())),
                  data: (_){
                    final ordersGoods = ref.watch(cartProvider);
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ordersGoods.length,
                      itemBuilder: (BuildContext context, int index){
                        
                        return InkWell(
                          onTap: (){ },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Container(
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
                              child: ListTile(
                                title: Text('${ordersGoods[index]['product_name']}', style: darkCategory(18, FontWeight.w500), overflow: TextOverflow.clip,),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${ordersGoods[index]['quantity']} шт.', style: black(18, FontWeight.w500), overflow: TextOverflow.clip,),
                                    Row(
                                      children: [
                                        Text('${ordersGoods[index]['total']}', style: black(20, FontWeight.w500), overflow: TextOverflow.clip,),
                                        Text('₽', style: grey(20, FontWeight.normal), overflow: TextOverflow.fade,),
                                      ],
                                    ),
                                  ],
                                ),
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
          ],
        ),
      ),
    );
  }
}
