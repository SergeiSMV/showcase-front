
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_front/constants/fonts.dart';
import 'package:showcase_front/data/repositories/backend_implements.dart';

import '../../data/models/cart_model/cart_model.dart';
import '../../data/models/request_model/request_model.dart';
import '../../data/providers.dart';
import '../widgets/scaffold_messenger.dart';




class RequestDetail extends ConsumerStatefulWidget {
  final RequestModel request;
  const RequestDetail({super.key, required this.request});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RequestDetailState();
}

class _RequestDetailState extends ConsumerState<RequestDetail> {

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      barrierColor: Colors.white.withOpacity(0.7),
      padding: const EdgeInsets.all(20.0),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.5),
                            Colors.white
                          ]
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('заказ ${widget.request.id} от ${widget.request.created}', style: darkCategory(18, FontWeight.normal),),
                          const SizedBox(height: 3,),
                          Text('доставка: ${widget.request.shipAddress}', style: darkCategory(16, FontWeight.normal),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.request.productsDetails.length,
                        itemBuilder: (BuildContext context, int index){
                          CartModel product = CartModel(cart: widget.request.productsDetails[index]);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(product.name, style: darkCategory(16, FontWeight.w500), overflow: TextOverflow.clip,),
                                const SizedBox(height: 5,),
                                getPrice(product.basePrice, product.price),
                                Row(
                                  children: [
                                    Icon(MdiIcons.packageVariantClosed, size: 18, color: Colors.grey,),
                                    const SizedBox(width: 10,),
                                    Text('заявка: ${widget.request.productsDetails[index]['wanted_quantity']}', style: darkProduct(16, FontWeight.normal), overflow: TextOverflow.clip,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Icon(MdiIcons.arrowRight, size: 15, color: Colors.black,),
                                    ),
                                    Text('отгрузка: ${product.quantity}', style: darkProduct(16, FontWeight.normal), overflow: TextOverflow.clip,),
                                  ],
                                ),
                                
                                const SizedBox(height: 10,),
                                Text('итого: ${widget.request.productsDetails[index]['total']}₽', style: black(16, FontWeight.w500), overflow: TextOverflow.clip,),
                        
                                const Divider(),
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                    totalPrice(widget.request.productsDetails),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async { 
                            Map data;
                            final cart = ref.read(cartProvider);
                            final progress = ProgressHUD.of(context);
                            progress?.showWithText('повторяем');
                            if (cart.isEmpty){
                              data = {
                                "clean_cart": false,
                                "request_id": widget.request.id.toString()
                              };
                              await BackendImplements().repeatOrder(data, ref).then((_){
                                progress?.dismiss();
                              });
                            } else {
                              await combine(context).then((result) async {
                                result == null ? 
                                {
                                  progress?.dismiss(),
                                  GlobalScaffoldMessenger.instance.showSnackBar("Товары не были добавлены в корзину!", 'error')
                                } :
                                {
                                  data = {
                                    "clean_cart": result,
                                    "request_id": widget.request.id.toString()
                                  },
                                  await BackendImplements().repeatOrder(data, ref).then((_){
                                    progress?.dismiss();
                                  })
                                };
                              });
                            }
                          }, 
                          child: Text('повторить заказ', style: white(16),)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget getPrice(double basePrice, double clientPrice){
    if (basePrice > clientPrice){
      return Row(
        children: [
          Icon(MdiIcons.bookmark, size: 18, color: Colors.grey,),
          const SizedBox(width: 10,),
          Text('$clientPrice₽', style: darkCategory(16), overflow: TextOverflow.fade,),
          const SizedBox(width: 10,),
          Text('$basePrice₽', style: blackThroughPrice(16)),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(MdiIcons.bookmark, size: 18, color: Colors.grey,),
          const SizedBox(width: 10,),
          Text('$clientPrice₽', style: black(16)),
        ],
      );
    }
  }

  Widget totalPrice(List ordersProduct){
    int sum = 0;
    for (var product in ordersProduct) {
      int productTotal = (product['total'] * 100).round();
      sum += productTotal;
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text('итого: ${sum / 100} ₽', style: darkProduct(24, FontWeight.w500),),
      ),
    );
  }

  Future<bool?> combine(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          actionsPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          title: Text('В корзине есть товары!', style: darkCategory(18),),
          content: Text('Вы хотите очистить корзину или добавить к имеющимся товарам?', style: black(16),),
          actions: [
            TextButton(
              onPressed: () { Navigator.of(context).pop(true); },
              child: Text('очистить', style: black(18),),
            ),
            TextButton(
              onPressed: () { Navigator.of(context).pop(false); },
              child: Text('добавить', style: black(18),),
            ),
          ],
        );
      },
    );
  }

}





/*
requestDetail(BuildContext mainContext, RequestModel request){
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: mainContext, 
    builder: (context){
      return ProgressHUD(
        barrierColor: Colors.white.withOpacity(0.7),
        padding: const EdgeInsets.all(20.0),
        child: Builder(
          builder: (context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40,),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.5),
                            Colors.white
                          ]
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('заказ ${request.id} от ${request.created}', style: darkCategory(18, FontWeight.normal),),
                          const SizedBox(height: 3,),
                          Text('доставка: ${request.shipAddress}', style: darkCategory(16, FontWeight.normal),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: request.productsDetails.length,
                        itemBuilder: (BuildContext context, int index){
                          CartModel product = CartModel(cart: request.productsDetails[index]);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(product.name, style: darkCategory(16, FontWeight.w500), overflow: TextOverflow.clip,),
                                const SizedBox(height: 5,),
                                getPrice(product.basePrice, product.price),
                                Row(
                                  children: [
                                    Icon(MdiIcons.packageVariantClosed, size: 18, color: Colors.grey,),
                                    const SizedBox(width: 10,),
                                    Text('заявка: ${request.productsDetails[index]['wanted_quantity']}', style: darkProduct(16, FontWeight.normal), overflow: TextOverflow.clip,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Icon(MdiIcons.arrowRight, size: 15, color: Colors.black,),
                                    ),
                                    Text('отгрузка: ${product.quantity}', style: darkProduct(16, FontWeight.normal), overflow: TextOverflow.clip,),
                                  ],
                                ),
                                
                                const SizedBox(height: 10,),
                                Text('итого: ${request.productsDetails[index]['total']}₽', style: black(16, FontWeight.w500), overflow: TextOverflow.clip,),
            
                                const Divider(),
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                    totalPrice(request.productsDetails),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async { 
                            final progress = ProgressHUD.of(context);
                            progress?.showWithText('повторяем');
                            Future.delayed(const Duration(seconds: 5)).then((_){
                              progress?.dismiss();
                              GlobalScaffoldMessenger.instance.showSnackBar("Товары успешно добавлены в корзину!");
                            });
                          }, 
                          child: Text('повторить заказ', style: white(16),)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      );


    }
  );
}
*/

