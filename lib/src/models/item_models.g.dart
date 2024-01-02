// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      id: json['id'] as String? ?? '',
      description: json['description'] as String,
      imgUrl: json['cape'] as String,
      itemName: json['title'] as String,
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((e) => ChapterItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: json['pagination'] as int? ?? 0,
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.itemName,
      'cape': instance.imgUrl,
      'description': instance.description,
      'chapters': instance.chapters,
      'pagination': instance.pagination,
    };
