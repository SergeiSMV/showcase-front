
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showcase_front/constants/fonts.dart';
import 'package:showcase_front/data/models/cart_model/cart_model.dart';

import '../../data/providers.dart';
import '../../data/repositories/backend_implements.dart';
import '../widgets/auth_required.dart';
import '../widgets/loading.dart';
import 'cart_views.dart';



class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final BackendImplements backend = BackendImplements();

  TextEditingController commentController = TextEditingController();

  @override
  void dispose(){
    commentController.dispose();
    super.dispose();
  }

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: 
          
          clientID.isEmpty ? authRequired(context) :
          Consumer(
            builder: (context, ref, child) {
              return ref.watch(baseCartsProvider).when(
                loading: () => const Loading(),
                error: (error, _) => Center(child: Text(error.toString())),
                data: (_){
                  final ordersProduct = ref.watch(cartProvider);
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft, 
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text('Корзина', style: black(30, FontWeight.bold), overflow: TextOverflow.clip,),
                        )
                      ),
                      const SizedBox(height: 5,),
                      Expanded(
                        child: ordersProduct.isEmpty ? emptyCart():
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ordersProduct.length,
                          itemBuilder: (BuildContext context, int index){
                            CartModel cartProduct = CartModel(cart: ordersProduct[index]);
                            return CartViews(cartProduct: cartProduct);
                          }
                        ),
                      ),
                      const Divider(indent: 10, endIndent: 10,),
                      totalPrice(ordersProduct),
                      ordersProduct.isEmpty ? const SizedBox.shrink() :
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
                              await GoRouter.of(context).push('/additinal_info',).then((_){
                                return {
                                  ref.refresh(baseCartsProvider), 
                                  ref.refresh(baseRequestsProvider)
                                };
                              });
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
      )
    );
  }


  Widget emptyCart(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(opacity: 0.7, child: Image.asset('lib/images/empty_cart.png', scale: 5)),
        const SizedBox(height: 10,),
        Text('в корзине пока\nпусто', style: black(14), textAlign: TextAlign.center,)
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
          Text('итого:', style: darkProduct(18),),
          const SizedBox(width: 8,),
          Text('${(sum / 100).toStringAsFixed(2)}₽', style: darkProduct(24, FontWeight.bold),),
        ],
      ),
    );
  }

}
