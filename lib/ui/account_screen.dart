





import 'package:flutter/material.dart';
import 'package:showcase_front/constants/fonts.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Account Screen', style: black(18),),
      ),
    );
  }
}