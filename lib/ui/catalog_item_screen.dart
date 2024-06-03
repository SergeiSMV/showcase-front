


import 'package:flutter/material.dart';

import '../constants/fonts.dart';

class CatalogItemScreen extends StatelessWidget {
  const CatalogItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('CatalogItem Screen', style: black(18),),
      ),
    );
  }
}