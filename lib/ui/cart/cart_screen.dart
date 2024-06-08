





import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:showcase_front/constants/fonts.dart';
import 'package:showcase_front/data/models/cart_model/cart_model.dart';

import '../../data/providers.dart';
import '../widgets/loading.dart';
import 'cart_views.dart';



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
        child: 
        
        clientID == 0 ?
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
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
        
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, child){
                  return ref.watch(baseCartsProvider(clientID)).when(
                    loading: () => const Loading(),
                    error: (error, _) => Center(child: Text(error.toString())),
                    data: (_){
                      final ordersGoods = ref.watch(cartProvider);
                      
                      return ordersGoods.isEmpty ? 
                      emptyCart():
                      
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ordersGoods.length,
                        itemBuilder: (BuildContext context, int index){
                          CartModel cartProduct = CartModel(cart: ordersGoods[index]);
                          return CartViews(cartProduct: cartProduct);
                        }
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget emptyCart(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('lib/images/empty_cart.png', scale: 3),
        const SizedBox(height: 15,),
        Text('корзина пуста', style: black(18),)
      ],
    );
  }

}
