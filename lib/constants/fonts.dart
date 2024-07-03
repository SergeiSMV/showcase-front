
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle black(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.black, fontSize: size, fontWeight: weight, height: 0.9);
TextStyle white(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.white, fontSize: size, fontWeight: weight, height: 0.9);
TextStyle grey(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.grey, fontSize: size, fontWeight: weight, height: 0.9);
TextStyle red(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.red, fontSize: size, fontWeight: weight);
TextStyle green(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.green, fontSize: size, fontWeight: weight, height: 0.9);
TextStyle blue(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.blue.shade700, fontSize: size, fontWeight: weight, height: 0.9);

TextStyle whiteBanner(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.white, fontSize: size, fontWeight: weight, height: 0.9);

TextStyle darkCategory(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.black87, fontSize: size, fontWeight: weight, height: 0.9);

TextStyle darkProduct(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(color: Colors.black87, fontSize: size, fontWeight: weight, height: 1);

TextStyle blackThroughPrice(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(
  color: Colors.black87, 
  fontSize: size, 
  fontWeight: weight, 
  height: 1,
  decoration: TextDecoration.lineThrough,
  decorationColor: Colors.red,
  decorationThickness: 2.0,
);


TextStyle greyThroughProduct(double size, [FontWeight weight = FontWeight.normal]) => GoogleFonts.sourceSans3(
  color: Colors.grey, 
  fontSize: size, 
  fontWeight: weight, 
  height: 1,
  decoration: TextDecoration.lineThrough,
  decorationColor: Colors.grey.shade300,
  decorationThickness: 2.0,
);