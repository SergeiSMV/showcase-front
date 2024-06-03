





import 'package:flutter/material.dart';
import 'package:showcase_front/constants/fonts.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Cart Screen', style: black(18),),
      ),
    );
  }
}