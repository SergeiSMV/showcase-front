
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/fonts.dart';
import '../../data/models/goods_model/goods_model.dart';
import '../../data/providers.dart';
import '../widgets/loading.dart';
import 'goods_views.dart';

class GoodsScreen extends ConsumerStatefulWidget {
  final int categoryID;
  final String mainCategory;
  const GoodsScreen({super.key, required this.categoryID, required this.mainCategory});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoodsScreenState();
}

class _GoodsScreenState extends ConsumerState<GoodsScreen> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20,),
            header(context),
            authorizedBanner(),
            const SizedBox(height: 10,),
            goodsViews()
            
          ],
        ),
      ),
    );
  }

  Consumer authorizedBanner() {
    return Consumer(
      builder: (context, ref, child){
        bool isAutgorized = ref.watch(isAutgorizedProvider);
        return isAutgorized ? const SizedBox.shrink() :
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: InkWell(
            onTap: (){
              GoRouter.of(context).push('/auth').then((clientID) {
                  return {ref.refresh(baseProductsProvider(widget.categoryID)),
                    ref.refresh(baseCartsProvider(clientID as int))};
                }
              );
            },
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  width: 3,
                  color: Colors.transparent,
                ),
                color: Colors.red,
              ),
              child: Align(
                alignment: Alignment.center, 
                child: Text(
                  'Необходимо авторизоваться,\nдля получения персональных цен и возможности добавления товаров в корзину', 
                  style: whiteBanner(16), 
                  textAlign: TextAlign.left,
                )
              ),
            ),
          ),
        );
      },
    );
  }

  Row header(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: (){
            GoRouter.of(context).pop();
          }, 
          child: Icon(MdiIcons.chevronLeft, size: 35,)
        ),
        const SizedBox(width: 5,),
        Expanded(child: Text(widget.mainCategory, style: darkCategory(26, FontWeight.bold), overflow: TextOverflow.clip,)),
      ],
    );
  }

  Expanded goodsViews() {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child){
          return ref.watch(baseProductsProvider(widget.categoryID)).when(
            loading: () => const Loading(),
            error: (error, _) => Center(child: Text(error.toString())),
            data: (_){
              final allGoods = ref.watch(productsProvider);
              return allGoods.isEmpty ? update(ref) : goods(ref, allGoods);
            },  
          );
        },
      ),
    );
  }


  RefreshIndicator goods(WidgetRef ref, List<dynamic> goods) {
    return RefreshIndicator(
      color: Colors.green,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 3), () {
          if (mounted){
            // return ref.refresh(baseCategoriesProvider);
          }
        });
      },
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: goods.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 10,
          childAspectRatio: 0.55
        ),
        itemBuilder: (BuildContext context, int index) {
          GoodsModel currentGoods = GoodsModel(goods: goods[index]);
          return GoodsViews(currentGoods: currentGoods,);
        },
      ),
    );
  }

  Column update(WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('lib/images/sold.png', scale: 6),
        const SizedBox(height: 10,),
        Text('товара нет', style: black(20, FontWeight.w500),),
        const SizedBox(height: 10,),
        /*
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B737),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async { 
            Future.delayed(const Duration(seconds: 1), () {
              return ref.refresh(baseProductsProvider(widget.categoryID));
            });
          }, 
          child: Text('обновить', style: white(16),)
        ),
        */
      ],
    );
  }


}