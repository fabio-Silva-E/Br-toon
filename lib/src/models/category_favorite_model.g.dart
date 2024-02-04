// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModelFavorite _$CategoryModelFavoriteFromJson(
        Map<String, dynamic> json) =>
    CategoryModelFavorite(
      title: json['title'] as String,
      id: json['id'] as String,
      favorites: (json['favorites'] as List<dynamic>?)
              ?.map(
                  (e) => FavoritesItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: json['pagination'] as int? ?? 0,
    );

Map<String, dynamic> _$CategoryModelFavoriteToJson(
        CategoryModelFavorite instance) =>
    <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      'favorites': instance.favorites,
      'pagination': instance.pagination,
    };
