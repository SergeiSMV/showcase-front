




import 'dart:async';

import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/fonts.dart';
import '../../data/models/product_model/product_model.dart';
import '../../data/repositories/backend_implements.dart';
import '../products/products_views.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final BackendImplements backend = BackendImplements();
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  Widget content = Container();

  @override
  void dispose(){
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      searchController.text.isEmpty ? 
        setState(() { content = Container(); }) 
        : 
        {
          setState(() { content = searchAnimation(); }),
          await backend.searchProduct(searchController.text).then((value){
            value.isEmpty ? setState(() { content = Center(child: Text('товар не найден', style: black(18),),); }) : setState(() { content = products(value); }) ;
          }),
        };
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10,),
            header(),
            const SizedBox(height: 5,),
            searchField(),
            const SizedBox(height: 10,),
            Expanded(child: content)
          ],
        ),
      ),
    );
  }

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.transparent
          ),
          color: Colors.white,
        ),
        height: 45,
        child: TextField(
          autofocus: true,
          controller: searchController,
          style: black(20),
          minLines: 1,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            focusedBorder:OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            hintStyle: grey(18),
            hintText: 'название товара',
            prefixIcon: Icon(MdiIcons.magnify, color: Colors.grey,),
            isCollapsed: true
          ),
          onChanged: (text) => _onSearchChanged(),
        ),
      ),
    );
  }


  Widget header(){
    return Align(
      alignment: Alignment.centerLeft, 
      child: Padding(
        padding: const EdgeInsets.only(left: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Поиск товара', style: black(30, FontWeight.bold), overflow: TextOverflow.clip,),
            Text('введите название товара в окно поиска:', style: black(16, FontWeight.normal), overflow: TextOverflow.clip,),
          ],
        ),
      )
    );
  }


  Widget searchAnimation(){
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: DotLottieLoader.fromAsset('lib/images/lottie/search.lottie',
          frameBuilder: (ctx, dotlottie) {
            return dotlottie != null ? Lottie.memory(dotlottie.animations.values.single) : Container();
        }),
      ),
    );
  }

  
  Widget products(List<dynamic> allProducts) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: allProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 10,
        childAspectRatio: 0.55
      ),
      itemBuilder: (BuildContext context, int index) {
        ProductModel currentGoods = ProductModel(product: allProducts[index]);
        return ProductsViews(currentProduct: currentGoods,);
      },
    );
  }
  

}