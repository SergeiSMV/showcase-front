
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/fonts.dart';
import '../../constants/server_config.dart';
import '../../data/models/category_model/category_data.dart';
import '../../data/models/category_model/category_model.dart';

class SubCategoriesScreen extends ConsumerStatefulWidget {
  final List subCategories;
  final String mainCategory;
  final int mainCategoryID;
  const SubCategoriesScreen({super.key, required this.subCategories, required this.mainCategory, required this.mainCategoryID});

  @override
  ConsumerState<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends ConsumerState<SubCategoriesScreen> {

  @override
  void initState() {
    print(widget.mainCategoryID);
    super.initState();
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final GoRouter route = GoRouter.of(context);
      final RouteMatch lastMatch = route.routerDelegate.currentConfiguration.last;
      final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : route.routerDelegate.currentConfiguration;
      final String path = matchList.uri.toString();
      final extra = matchList.extra as Map<String, dynamic>?;
      ref.read(categoryGoRouterProvider.notifier).state = {'path': path, 'extra': extra};
    });
    */
  }


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
              categoryMenu(context),
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
        Expanded(child: Text(widget.mainCategory, style: darkCategory(26, FontWeight.bold), overflow: TextOverflow.clip,)),
      ],
    );
  }

  Expanded subCategoriesViews() {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.subCategories.length,
        itemBuilder: (BuildContext context, int index){
          CategoryModel category = CategoryModel(categories: widget.subCategories[index]);
          return InkWell(
            onTap: (){ 
              category.children.isEmpty ?
              GoRouter.of(context).push(
                '/categories/${category.id}/products',
                extra: {
                  'mainCategory': category.name,
                  'categoryID': category.id
                },
              ) :
              {
                GoRouter.of(context).push(
                '/categories/${category.id}',
                extra: {
                  'mainCategory': category.name,
                  'subCategories': category.children,
                  'mainCategoryID': category.id
                })
              };
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
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: category.thumbnail == categoryImagePath['empty'] ? Image.asset(categoryImagePath['empty'], scale: 3) :
                          CachedNetworkImage(
                            imageUrl: '$apiURL${category.thumbnail}',
                            errorWidget: (context, url, error) => SizedBox(
                              width: 120,
                              height: 120,
                              child: Align(
                                alignment: Alignment.center, 
                                child: Image.asset(categoryImagePath['empty'], scale: 3)
                              ),
                            ),
                          ),
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

  Widget categoryMenu(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: InkWell(
            onTap: (){
              GoRouter.of(context).push(
                '/categories/${widget.mainCategoryID}/products',
                extra: {
                  'mainCategory': widget.mainCategory,
                  'categoryID': widget.mainCategoryID
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 3,
                  color: Colors.transparent,
                ),
                color: Colors.green.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 0.3,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 5,),
                  Image.asset('lib/images/get_all.png', scale: 7,),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Text('товары в категории', style: black(14, FontWeight.w500), overflow: TextOverflow.clip,)
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 5,),
        Flexible(
          child: InkWell(
            onTap: (){
              GoRouter.of(context).push(
                '/search_by_id',
                extra: {
                  'mainCategory': widget.mainCategory,
                  'categoryID': widget.mainCategoryID
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 3,
                  color: Colors.transparent,
                ),
                color: Colors.green.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 0.3,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset('lib/images/glass.png', scale: 6,),
                  const SizedBox(width: 5,),
                  Expanded(
                    child: Text('поиск по категории', style: black(14, FontWeight.w500), overflow: TextOverflow.clip,)
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}