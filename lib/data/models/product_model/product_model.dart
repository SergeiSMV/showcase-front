


import 'package:freezed_annotation/freezed_annotation.dart';


part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();
  const factory ProductModel({
    required Map<String, dynamic> product,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  String get name => product['product_name'];
  int get id => product['product_id'];
  List get pictures => product['pictures'] ?? [];
  String get discription => product['product_description'];
  int get quantity => product['quantity'];
  double get basePrice => product['base_price'] ?? product['price'];
  double get clientPrice => product['client_price'];

}