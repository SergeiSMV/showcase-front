
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_front/constants/fonts.dart';

import '../../data/models/cart_model/cart_model.dart';
import '../../data/providers.dart';
import '../widgets/loading.dart';

requestDetail(BuildContext mainContext, int requestID, List products){
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: mainContext, 
    builder: (context){
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
            children: [
              const SizedBox(height: 40,),
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      GoRouter.of(context).pop();
                    }, 
                    child: Icon(MdiIcons.chevronLeft, size: 30,)
                  ),
                  const SizedBox(width: 10,),
                  Align(alignment: Alignment.centerLeft, child: Text('заказ $requestID', style: darkCategory(22, FontWeight.normal),)),
                ],
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index){
                    CartModel product = CartModel(cart: products[index]);
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(product.name, style: darkCategory(16, FontWeight.w500), overflow: TextOverflow.clip,),
                            ),
                            const SizedBox(height: 5,),
                            getPrice(product.basePrice, product.price),
                            Text('товара в заявке: ${products[index]['wanted_quantity']}', style: darkProduct(16, FontWeight.normal), overflow: TextOverflow.clip,),
                            Text('товара к отгрузке: ${product.quantity}', style: darkProduct(16, FontWeight.normal), overflow: TextOverflow.clip,),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                Text('итого: ${products[index]['total']}₽', style: black(16, FontWeight.w500), overflow: TextOverflow.clip,),
                              ],
                            ),
                          ],
                        ),
                      )
                    );
                  }
                ),
              )
            ],
          ),
        ),
      );
    }
  );
}



Widget getPrice(double basePrice, double clientPrice){
    if (basePrice > clientPrice){
      return Row(
        children: [
          Text('цена: $clientPrice', style: darkCategory(16), overflow: TextOverflow.fade,),
          Text('₽', style: grey(14), overflow: TextOverflow.fade,),
          const SizedBox(width: 10,),
          Text('$basePrice', style: blackThroughPrice(16)),
          Text('₽', style: grey(14), overflow: TextOverflow.fade,),
        ],
      );
    } else {
      return Row(
        children: [
          Text('цена: $clientPrice', style: darkCategory(16)),
          Text('₽', style: grey(14, FontWeight.normal), overflow: TextOverflow.fade,),
        ],
      );
    }
  }


