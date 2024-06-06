
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showcase_front/constants/fonts.dart';

import '../../data/models/category_model/category_model.dart';
import '../../data/providers.dart';
import '../widgets/loading.dart';



class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {

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
            header(),
            const SizedBox(height: 10,),
            categoryViews(),
          ],
        ),
      ),
    );
  }

  Align header() {
    return Align(
      alignment: Alignment.centerLeft, 
      child: Padding(
        padding: const EdgeInsets.only(left: 7),
        child: Text('Категории товаров', style: black(30, FontWeight.bold), overflow: TextOverflow.clip,),
      )
    );
  }

  Expanded categoryViews() {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child){
          return ref.watch(baseCategoriesProvider).when(
            loading: () => const Loading(),
            error: (error, _) => Center(child: Text(error.toString())),
            data: (_){
              final mainCategories = ref.watch(categoriesProvider);
              return mainCategories.isEmpty ? update(ref) : categories(ref, mainCategories);
            },  
          );
        },
      ),
    );
  }

  RefreshIndicator categories(WidgetRef ref, List<dynamic> mainCategories) {
    return RefreshIndicator(
      color: Colors.green,
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 3), () {
          if (mounted){
            return ref.refresh(baseCategoriesProvider);
          }
        });
      },
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: mainCategories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 10
        ),
        itemBuilder: (BuildContext context, int index) {
          CategoryModel category = CategoryModel(categories: mainCategories[index]);
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: InkWell(
              onTap: (){ 
                category.children.isEmpty ?
                GoRouter.of(context).push(
                  '/goods',
                  extra: {
                    'mainCategory': category.name,
                    'categoryID': category.id
                  },
                ) :
                GoRouter.of(context).push(
                  '/categories/${category.id}',
                  extra: {
                    'mainCategory': category.name,
                    'subCategories': category.children,
                    'mainCategoryID': category.id
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 3,
                    color: Colors.transparent,
                  ),
                  image: DecorationImage(
                    opacity: category.imagePath == 'lib/images/categories/empty.png' ? 0.2 : 0.9,
                    image: AssetImage(category.imagePath),
                    fit: BoxFit.contain,
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
                child: Text(category.name, style: darkCategory(18, FontWeight.w500),),
              ),
            ),
          );
        },
      ),
    );
  }

  Column update(WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('lib/images/no_data.png', scale: 3),
        Text('что-то пошло не так...', style: black(14),),
        const SizedBox(height: 10,),
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
              return ref.refresh(baseCategoriesProvider);
            });
          }, 
          child: Text('обновить', style: white(16),)
        ),
      ],
    );
  }
}