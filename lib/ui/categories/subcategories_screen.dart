


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/fonts.dart';
import '../../data/models/category_model/category_model.dart';

class SubCategoriesScreen extends StatelessWidget {
  final List subCategories;
  final String mainCategory;
  final int mainCategoryID;
  const SubCategoriesScreen({super.key, required this.subCategories, required this.mainCategory, required this.mainCategoryID});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     opacity: 0.3,
      //     image: AssetImage(categoryImagePath[mainCategoryID] ?? categoryImagePath['default_bg']),
      //     fit: BoxFit.contain,
      //     alignment: Alignment.bottomCenter,
      //   ),
      // ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20,),
              header(context),
              const SizedBox(height: 10,),
              getAllProducts(context),
              const SizedBox(height: 10,),
              subCategoriesViews()
            ],
          ),
        ),
      ),
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
        Expanded(child: Text(mainCategory, style: darkCategory(26, FontWeight.bold), overflow: TextOverflow.clip,)),
      ],
    );
  }

  Expanded subCategoriesViews() {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: subCategories.length,
        itemBuilder: (BuildContext context, int index){
          CategoryModel category = CategoryModel(categories: subCategories[index]);
          return InkWell(
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
            child: Padding(
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
                    Container(
                      height: 100,
                      width: 100,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          scale: 4,
                          opacity: 1,
                          image: AssetImage(category.imagePath),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Text(category.name, style: black(20, FontWeight.w500), overflow: TextOverflow.clip,)
                    )
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }

  InkWell getAllProducts(BuildContext context) {
    return InkWell(
      onTap: (){
        GoRouter.of(context).push(
          '/goods',
          extra: {
            'mainCategory': mainCategory,
            'categoryID': mainCategoryID
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 3,
            color: Colors.transparent,
          ),
          color: Colors.green.shade100,
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
            Container(
              height: 60,
              width: 100,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  scale: 4,
                  opacity: 1,
                  image: AssetImage('lib/images/get_all.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Text('Все товары в категории', style: black(20, FontWeight.w500), overflow: TextOverflow.clip,)
            )
          ],
        ),
      ),
    );
  }
}