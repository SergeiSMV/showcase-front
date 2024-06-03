






import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showcase_front/constants/fonts.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Catalog Screen', style: black(18),),
            const SizedBox(height: 10,),
            TextButton(onPressed: (){ context.go('/catalog/catalog_id'); }, child: Text('внутрь каталога', style: black(14),))
          ],
        ),
      ),
    );
  }
}