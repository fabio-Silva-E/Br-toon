// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'favoritecount_models.g.dart';

@JsonSerializable()
class FavoritesCountItemModel {
  String id;
  ProductModel product;

  FavoritesCountItemModel({
    required this.id,
    required this.product,
  });

  factory FavoritesCountItemModel.fromJson(Map<String, dynamic> json) =>
      _$FavoritesCountItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoritesCountItemModelToJson(this);

  @override
  String toString() => 'FavoritesCountItemModel(id: $id, product: $product)';
}

@JsonSerializable()
class ProductModel {
  String id;

  ProductModel({required this.id});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @override
  String toString() => 'ProductModel(id: $id)';
}
