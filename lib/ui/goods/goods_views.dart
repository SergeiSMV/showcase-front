
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/fonts.dart';
import '../../data/models/category_model/category_data.dart';
import '../../data/models/goods_model/goods_model.dart';
import '../../data/repositories/backend_implements.dart';

class GoodsViews extends ConsumerStatefulWidget {
  final GoodsModel currentGoods;
  const GoodsViews({super.key, required this.currentGoods});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoodsViewsState();
}

class _GoodsViewsState extends ConsumerState<GoodsViews> {
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
    _controller.dispose();
    super.dispose();
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
          child: Column(
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B737),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async { 
                
                  }, 
                  child: Text('в корзину', style: white(16),)
                ),
              ),
            ],
          ),
        ),
      ),
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
    if (basePrice == clientPrice){
      return Row(
        children: [
          Text('$basePrice', style: darkGoods(24, FontWeight.normal), overflow: TextOverflow.fade,),
          Text('₽', style: grey(20, FontWeight.normal), overflow: TextOverflow.fade,),
        ],
      );
    } else {
      return Row(
        children: [
          Text('$clientPrice₽', style: darkGoods(24, FontWeight.normal)),
          const SizedBox(width: 10,),
          Text('$basePrice', style: throughPrice(18, FontWeight.normal)),
        ],
      );
    }
  }


}