


import 'package:freezed_annotation/freezed_annotation.dart';


part 'goods_model.freezed.dart';
part 'goods_model.g.dart';

@freezed
class GoodsModel with _$GoodsModel {
  const GoodsModel._();
  const factory GoodsModel({
    required Map<String, dynamic> goods,
  }) = _GoodsModel;

  factory GoodsModel.fromJson(Map<String, dynamic> json) => _$GoodsModelFromJson(json);

  String get name => goods['product_name'];
  int get id => goods['product_id'];
  List get pictures => goods['pictures'] ?? [];
  String get discription => goods['product_description'];
  int get quantity => goods['quantity'];
  double get basePrice => goods['base_price'] ?? goods['price'];
  double get clientPrice => goods['client_price'];

}