
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/fonts.dart';
import '../../data/models/category_model/category_data.dart';
import '../../data/models/goods_model/goods_model.dart';
import '../../data/providers.dart';
import '../../data/repositories/backend_implements.dart';
import '../categories/indicate_quantity.dart';
import '../widgets/scaffold_messenger.dart';

class GoodsViews extends ConsumerStatefulWidget {
  final GoodsModel currentGoods;
  const GoodsViews({super.key, required this.currentGoods});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoodsViewsState();
}

class _GoodsViewsState extends ConsumerState<GoodsViews> {

  final TextEditingController _quantityController = TextEditingController();
  final PageController _controller = PageController();

  List pictures = [
    {'product_id': 45, 'picture_url': '/get-picture/by_id/45-1', 'picture_position': 1},
    {'product_id': 43, 'picture_url': '/get-picture/by_id/43-1', 'picture_position': 1},
    {'product_id': 50, 'picture_url': '/get-picture/by_id/50-1', 'picture_position': 1}
  ];

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    _quantityController.dispose();
    _controller.dispose();
    super.dispose();
  }


  bool currentGoodsInCart(List cart){
    bool inCart = false;
    for (var product in cart) {
      if (product['product_id'] == widget.currentGoods.id) {
        inCart = true;
        break;
      }
    }
    return inCart;
  }

  Map currentGoodsCartData(List cart){
    Map data = {};
    for (var product in cart) {
      if (product['product_id'] == widget.currentGoods.id) {
        data = product;
        break;
      }
    }
    return data;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: (){ },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
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
                offset: const Offset(1, 3),
              ),
            ],
          ),
          child: Builder(
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  goodsImages(),
                  // widget.currentGoods.pictures.isEmpty ? const SizedBox.shrink() : 
                  const SizedBox(height: 5,),
                  widget.currentGoods.pictures.isEmpty ? const SizedBox(height: 8,) : imageIndicator(),
                  const SizedBox(height: 5,),
                  Expanded(child: Text(widget.currentGoods.name, style: darkGoods(16, FontWeight.w500), maxLines: 3, overflow: TextOverflow.fade,)),
                  const SizedBox(height: 10,),
                  Align(alignment: Alignment.centerLeft, child: getPrice(widget.currentGoods.basePrice, widget.currentGoods.clientPrice,)),
                  const SizedBox(height: 10,),
                  Consumer(
                    builder: (context, ref, child) {
                      final cart = ref.watch(cartProvider);
                      
                      return SizedBox(
                        width: double.infinity,
                        child: currentGoodsInCart(cart) ? 
                        Row(
                          children: [
                            quantityControlButton('minus', cart),
                            Expanded(
                              child: InkWell(
                                onTap: () => indicateQuantity(context, _quantityController, widget.currentGoods.name).then((_){
                                  putExact(cart);
                                }),
                                child: Center(
                                  child: Text('${currentGoodsCartData(cart)['quantity']}', style: darkGoods(20, FontWeight.w500),)
                                ),
                              )
                            ),
                            quantityControlButton('plus')
                          ],
                        )
                        : toCartButton(),
                      );
                    }
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  SizedBox quantityControlButton(String operation, [List<dynamic> cart = const []]) {
    return SizedBox(
      width: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: operation == 'plus' ? const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)) :
              const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
        ),
        onPressed: () async { 
          operation == 'plus' ? await putIncrement() : putDecrement(cart);
        }, 
        child: Center(
          child: operation == 'plus' ? Icon(MdiIcons.plus, color: Colors.black, size: 20,) : 
            Icon(MdiIcons.minus, color: Colors.black, size: 20,)
        )
      ),
    );
  }

  Future<void> putExact(List<dynamic> cart) async {
    int clientID = ref.read(clientIDProvider);
    int? quantityExact = int.parse(_quantityController.text);
    int? quantityIncr;
    Map putData = {
      "client_id": clientID,
      "product_id": widget.currentGoods.id,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    await BackendImplements().backendPutCart(putData).then((value) => ref.refresh(baseCartsProvider(clientID)));
    
  }

  Future<void> putDecrement(List<dynamic> cart) async {
    int clientID = ref.read(clientIDProvider);
    int? quantityExact;
    var quantityIncr = currentGoodsCartData(cart)['quantity'] == 1 ? quantityExact = 0 : -1;
    Map putData = {
      "client_id": clientID,
      "product_id": widget.currentGoods.id,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    await BackendImplements().backendPutCart(putData).then((value) => ref.refresh(baseCartsProvider(clientID)));
  }

  Future<void> putIncrement() async {
    int clientID = ref.read(clientIDProvider);
    Map putData = {
      "client_id": clientID,
      "product_id": widget.currentGoods.id,
      "quantity_incr": 1,
      "quantity_exact": null
    };
    await BackendImplements().backendPutCart(putData).then((value) => ref.refresh(baseCartsProvider(clientID)));
  }

  Widget toCartButton() {
    return Consumer(
      builder: (context, ref, child) {
        bool isAutgorized = ref.watch(isAutgorizedProvider);
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B737),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            isAutgorized ? 
              await putIncrement() 
            : GlobalScaffoldMessenger.instance.showSnackBar('Вы не авторизованы!', 'error');
          }, 
          child: Text('в корзину', style: white(16),)
        );
      }
    );
  }

  Container goodsImages() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: widget.currentGoods.pictures.isEmpty ? Image.asset(categoryImagePath['empty'], scale: 3,) : 
      PageView.builder(
        controller: _controller,
        // itemCount: widget.currentGoods.pictures.length,
        itemCount: pictures.length,
        itemBuilder: (context, index) {
          // String picURL = widget.currentGoods.pictures[index]['picture_url'];
          String picURL = pictures[index]['picture_url'];
          return FutureBuilder<Image>(
            future: BackendImplements().backendPicture(picURL),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Image.asset(categoryImagePath['empty'], scale: 3,);
              } else {
                return snapshot.data!;
              }
            },
          );
        },
      ),
    );
  }

  SmoothPageIndicator imageIndicator() {
    return SmoothPageIndicator(
      controller: _controller,
      count: pictures.length,
      effect: WormEffect(
        dotHeight: 8,
        dotWidth: 8,
        type: WormType.thin,
        activeDotColor: Colors.green,
        dotColor: Colors.grey.shade300
      ),
    );
  }

  Widget getPrice(double basePrice, double clientPrice){
    if (basePrice > clientPrice){
      return Row(
        children: [
          Text('$clientPrice', style: darkGoods(24, FontWeight.normal), overflow: TextOverflow.fade,),
          Text('₽', style: grey(20, FontWeight.normal), overflow: TextOverflow.fade,),
          const SizedBox(width: 10,),
          Text('$basePrice', style: throughPrice(20, FontWeight.normal)),
        ],
      );
    } else {
      return Row(
        children: [
          Text('$clientPrice', style: darkGoods(24, FontWeight.normal)),
          Text('₽', style: grey(20, FontWeight.normal), overflow: TextOverflow.fade,),
        ],
      );
    }
  }


}