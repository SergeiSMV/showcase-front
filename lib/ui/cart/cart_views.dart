



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/fonts.dart';
import '../../data/models/cart_model/cart_model.dart';
import '../../data/models/category_model/category_data.dart';
import '../../data/providers.dart';
import '../../data/repositories/backend_implements.dart';
import '../categories/indicate_quantity.dart';

class CartViews extends ConsumerStatefulWidget {
  final CartModel cartProduct;
  const CartViews({super.key, required this.cartProduct,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartViewsState();
}

class _CartViewsState extends ConsumerState<CartViews> {

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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        child: Row(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: widget.cartProduct.pictures.isEmpty ? Image.asset(categoryImagePath['empty'], scale: 4,) : 
                      PageView.builder(
                        controller: _controller,
                        itemCount: widget.cartProduct.pictures.length,
                        itemBuilder: (context, picIndex) {
                          String picURL = widget.cartProduct.pictures[picIndex]['picture_url'];
                          return FutureBuilder<Image>(
                            future: BackendImplements().backendPicture(picURL),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Image.asset(categoryImagePath['empty'], scale: 4,);
                              } else {
                                return snapshot.data!;
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                widget.cartProduct.pictures.isEmpty || widget.cartProduct.pictures.length == 1 ? const SizedBox.shrink() : imageIndicator(widget.cartProduct.pictures.length),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(widget.cartProduct.name, style: darkCategory(16, FontWeight.w500), overflow: TextOverflow.clip,),
                    ),
                    const SizedBox(height: 5,),
                    getPrice(widget.cartProduct.basePrice, widget.cartProduct.price),
                    Row(
                      children: [
                        Text('итого: ${widget.cartProduct.totalPrice}', style: black(20, FontWeight.w500), overflow: TextOverflow.clip,),
                        Text('₽', style: grey(20, FontWeight.normal), overflow: TextOverflow.clip,),
                      ],
                    ),
                    Row(
                      children: [
                        quantityControlButton('minus'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () => indicateQuantity(context, _quantityController, widget.cartProduct.name).then((_){
                              putExact();
                            }),
                            child: Center(
                              child: Text('${widget.cartProduct.quantity} шт.', style: darkGoods(20, FontWeight.w500),)
                            ),
                          ),
                        ),
                        quantityControlButton('plus'),
                        const Spacer(),
                        IconButton(
                          onPressed: (){ delete(); }, 
                          icon: Icon(MdiIcons.delete, color: Colors.red, size: 25,)
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  SizedBox quantityControlButton(String operation) {
    return SizedBox(
      width: 40,
      child: IconButton(
        onPressed: () async {
          operation == 'plus' ? await putIncrement() : putDecrement();
        }, 
        icon: operation == 'plus' ? Icon(MdiIcons.plus, color: Colors.black, size: 20,) : 
            Icon(MdiIcons.minus, color: Colors.black, size: 20,)
      )
      
      
      /*
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
          backgroundColor: Colors.transparent, //const Color(0xFF00B737),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: operation == 'plus' ? const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)) :
              const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
        ),
        onPressed: () async { 
          operation == 'plus' ? await putIncrement() : putDecrement();
        }, 
        child: Center(
          child: operation == 'plus' ? Icon(MdiIcons.plus, color: Colors.black, size: 20,) : 
            Icon(MdiIcons.minus, color: Colors.black, size: 20,)
        )
      ),
      */

    );
  }

  Future<void> putExact() async {
    int clientID = ref.read(clientIDProvider);
    int? quantityExact = int.parse(_quantityController.text);
    int? quantityIncr;
    Map putData = {
      "client_id": clientID,
      "product_id": widget.cartProduct.id,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    await BackendImplements().backendPutCart(putData).then((value) => ref.refresh(baseCartsProvider(clientID)));
    
  }

  Future<void> putDecrement() async {
    int clientID = ref.read(clientIDProvider);
    int? quantityExact;
    var quantityIncr = widget.cartProduct.quantity == 1 ? quantityExact = 0 : -1;
    Map putData = {
      "client_id": clientID,
      "product_id": widget.cartProduct.id,
      "quantity_incr": quantityIncr,
      "quantity_exact": quantityExact
    };
    await BackendImplements().backendPutCart(putData).then((value) => ref.refresh(baseCartsProvider(clientID)));
  }

  Future<void> putIncrement() async {
    int clientID = ref.read(clientIDProvider);
    Map putData = {
      "client_id": clientID,
      "product_id": widget.cartProduct.id,
      "quantity_incr": 1,
      "quantity_exact": null
    };
    await BackendImplements().backendPutCart(putData).then((value) => ref.refresh(baseCartsProvider(clientID)));
  }

  Future<void> delete() async {
    int clientID = ref.read(clientIDProvider);
    int? quantityIncr;
    Map putData = {
      "client_id": clientID,
      "product_id": widget.cartProduct.id,
      "quantity_incr": quantityIncr,
      "quantity_exact": 0
    };
    await BackendImplements().backendPutCart(putData).then((value) => ref.refresh(baseCartsProvider(clientID)));
    
  }


  Widget imageIndicator(int picturesCount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SmoothPageIndicator(
        controller: _controller,
        count: picturesCount,
        effect: WormEffect(
          dotHeight: 8,
          dotWidth: 8,
          type: WormType.thin,
          activeDotColor: Colors.green,
          dotColor: Colors.grey.shade300
        ),
      ),
    );
  }

  Widget getPrice(double basePrice, double clientPrice){
    if (basePrice > clientPrice){
      return Row(
        children: [
          Text('цена: $clientPrice', style: darkCategory(16), overflow: TextOverflow.fade,),
          Text('₽', style: grey(16), overflow: TextOverflow.fade,),
          const SizedBox(width: 10,),
          Text('$basePrice₽', style: throughPrice(16, FontWeight.normal)),
        ],
      );
    } else {
      return Row(
        children: [
          Text('цена: $clientPrice', style: darkCategory(16)),
          Text('₽', style: grey(16, FontWeight.normal), overflow: TextOverflow.fade,),
        ],
      );
    }
  }

}