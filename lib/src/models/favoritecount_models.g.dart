// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoritecount_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritesCountItemModel _$FavoritesCountItemModelFromJson(
        Map<String, dynamic> json) =>
    FavoritesCountItemModel(
      id: json['id'] as String,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoritesCountItemModelToJson(
        FavoritesCountItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
    };

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
