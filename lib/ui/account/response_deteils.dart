
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcase_front/constants/fonts.dart';

import '../../data/models/response_model/response_model.dart';
import '../../data/models/response_product_model/response_product_model.dart';





responseDetail(BuildContext mainContext, ResponseModel response){
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
                    Text('отгрузка ${response.responseID} от ${response.updated}', style: darkCategory(18, FontWeight.normal),),
                    const SizedBox(height: 3,),
                    Text('к заявке: ${response.requestID} от ${response.created}', style: darkCategory(14, FontWeight.normal), overflow: TextOverflow.clip,),
                    const SizedBox(height: 3,),
                    Text('доставка: ${response.shipAddress}', style: darkCategory(14, FontWeight.normal), overflow: TextOverflow.clip,),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: response.productsDetails.length,
                  itemBuilder: (BuildContext context, int index){
                    ResponseProductModel product = ResponseProductModel(product: response.productsDetails[index]);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          product.comment == null && product.replaceName == null && product.replaceQuantity == null ? 
                            const SizedBox.shrink() :
                            InkWell(
                              onTap: (){
                                changeDetails(context, response, product);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.transparent,
                                  ),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.amber,
                                      Colors.white
                                    ]
                                  )
                                ),
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.commentAlert, size: 18, color: Colors.black,),
                                    const SizedBox(width: 10,),
                                    Text('доп. информация', style: darkCategory(16, FontWeight.w500), overflow: TextOverflow.clip,),
                                  ],
                                ),
                              ),
                            ),
                          product.comment == null && product.replaceName == null && product.replaceQuantity == null ? 
                            const SizedBox.shrink() : const SizedBox(height: 5,),
                          Text(product.name, style: darkCategory(16, FontWeight.w500), overflow: TextOverflow.clip,),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Icon(MdiIcons.bookmark, size: 18, color: Colors.grey,),
                              const SizedBox(width: 10,),
                              Text('${product.price}₽', style: black(16)),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(MdiIcons.packageVariantClosed, size: 18, color: Colors.grey,),
                              const SizedBox(width: 10,),
                              Text('${product.quantity}', style: black(16)),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Text('итого: ${product.total}₽', style: black(16, FontWeight.w500), overflow: TextOverflow.clip,),
                          const Divider(),
                        ],
                      ),
                    );
                  }
                ),
              ),
              const SizedBox(height: 5,),
              totalPrice(response.productsDetails),
              const SizedBox(height: 5,)
            ],
          ),
        ),
      );
    }
  );
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


Future changeDetails(BuildContext context, ResponseModel response, ResponseProductModel product) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        actionsPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('доп. информация к отгрузке ${response.responseID} от ${response.updated}', style: darkCategory(18),),
            const SizedBox(height: 3,),
            Text('позиция: ${product.name}', style: darkCategory(16),),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            product.replaceName == null ? const SizedBox.shrink() :
            Row(
              children: [
                Icon(MdiIcons.arrowURightBottom, size: 30, color: Colors.green,),
                Expanded(
                  child: Column(
                    children: [
                      Text(product.replaceName!, style: grey(16), overflow: TextOverflow.clip,),
                      const SizedBox(height: 3,),
                      Text(product.name, style: darkCategory(16), overflow: TextOverflow.clip,),
                    ],
                  ),
                )
              ],
            ),
            product.replaceQuantity == null ? const SizedBox.shrink() :
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(MdiIcons.arrowURightBottom, size: 30, color: Colors.green,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${product.replaceQuantity!.toString()} шт.', style: grey(16), overflow: TextOverflow.clip,),
                        const SizedBox(height: 3,),
                        Text('${product.quantity.toString()} шт.', style: darkCategory(16), overflow: TextOverflow.clip,),
                      ],
                    ),
                  )
                ],
              ),
            ),
            product.comment == null ? const SizedBox.shrink() :
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(alignment: Alignment.centerLeft, child: Text('комментарий:\n${product.comment!}', maxLines: 5, style: darkCategory(16), overflow: TextOverflow.clip,)),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () { Navigator.of(context).pop(); },
            child: Text('понятно', style: black(18),),
          ),
        ],
      );
    },
  );
}

