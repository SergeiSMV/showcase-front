
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_front/constants/fonts.dart';

import '../../data/models/cart_model/cart_model.dart';
import '../../data/models/request_model/request_model.dart';

requestDetail(BuildContext mainContext, RequestModel request){
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40,),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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
                          // const SizedBox(height: 5,),
                          Row(
                            children: [
                              Icon(MdiIcons.truckFast, size: 18, color: Colors.grey,),
                              const SizedBox(width: 10,),
                              Text('заявка: ${request.productsDetails[index]['wanted_quantity']}', style: darkProduct(16, FontWeight.normal), overflow: TextOverflow.clip,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Icon(MdiIcons.arrowRight, size: 15, color: Colors.black,),
                                // Text('>', style: darkProduct(16, FontWeight.normal), overflow: TextOverflow.clip,),
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
                    /*
                    Container(
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
                    */
                  }
                ),
              ),
              totalPrice(request.productsDetails),
              const SizedBox(height: 5,)
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
          Icon(MdiIcons.bookmark, size: 20, color: Colors.grey,),
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


