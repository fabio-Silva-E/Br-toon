// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritesItemModel _$FavoritesItemModelFromJson(Map<String, dynamic> json) =>
    FavoritesItemModel(
      id: json['id'] as String,
      item: ItemModel.fromJson(json['product'] as Map<String, dynamic>),
      pagination: json['pagination'] as int? ?? 0,
    );

Map<String, dynamic> _$FavoritesItemModelToJson(FavoritesItemModel instance) =>
    <String, dynamic>{
      'product': instance.item,
      'id': instance.id,
      'pagination': instance.pagination,
    };
