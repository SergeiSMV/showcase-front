
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle black(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.black, fontSize: size, fontWeight: weight);
TextStyle white(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.white, fontSize: size, fontWeight: weight);
TextStyle grey(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.grey, fontSize: size, fontWeight: weight);
TextStyle red(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.red, fontSize: size, fontWeight: weight);

TextStyle whiteBanner(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.white, fontSize: size, fontWeight: weight, height: 0.9);

TextStyle darkCategory(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.black87, fontSize: size, fontWeight: weight, height: 0.9);

TextStyle darkGoods(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.black87, fontSize: size, fontWeight: weight, height: 1);

TextStyle throughPrice(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(
  color: Colors.black87, 
  fontSize: size, 
  fontWeight: weight, 
  height: 1,
  decoration: TextDecoration.lineThrough,
  decorationColor: Colors.red,
  decorationThickness: 2.0,
);