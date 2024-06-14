
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showcase_front/constants/fonts.dart';
import 'package:showcase_front/data/models/cart_model/cart_model.dart';

import '../../data/providers.dart';
import '../../data/repositories/backend_implements.dart';
import '../widgets/loading.dart';
import 'cart_views.dart';



class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final BackendImplements backend = BackendImplements();

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
        
        Consumer(
          builder: (context, ref, child) {
            return ref.watch(baseCartsProvider(clientID)).when(
              loading: () => const Loading(),
              error: (error, _) => Center(child: Text(error.toString())),
              data: (_){

                final ordersProduct = ref.watch(cartProvider);
                
                return ordersProduct.isEmpty ? emptyCart():
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft, 
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text('Корзина', style: black(30, FontWeight.bold), overflow: TextOverflow.clip,),
                      )
                    ),
                    Expanded(
                      child: ordersProduct.isEmpty ? emptyCart():
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ordersProduct.length,
                        itemBuilder: (BuildContext context, int index){
                          CartModel cartProduct = CartModel(cart: ordersProduct[index]);
                          return CartViews(cartProduct: cartProduct, clientID: clientID,);
                        }
                      ),
                    ),
                    const Divider(indent: 10, endIndent: 10,),
                    totalPrice(ordersProduct),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00B737),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            await backend.newRequests().then(
                              (_) => ref.refresh(baseCartsProvider(clientID))
                            );
                          }, 
                          child: Text('заказать', style: white(18),)
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
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

  Widget totalPrice(List ordersProduct){
    int sum = 0;
    for (var product in ordersProduct) {
      int productTotal = (product['total'] * 100).round();
      sum += productTotal;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text('итого:', style: darkProduct(20),),
          const SizedBox(width: 8,),
          Text('${sum / 100}', style: darkProduct(24, FontWeight.bold),),
          const SizedBox(width: 1,),
          Text('₽', style: grey(20, FontWeight.normal), overflow: TextOverflow.fade,),
        ],
      ),
    );
  }

}
