// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterItemModel _$ChapterItemModelFromJson(Map<String, dynamic> json) =>
    ChapterItemModel(
      id: json['id'] as String? ?? '',
      chaptersUrls: json['cape'] == null
          ? null
          : GalleryModel.fromJson(json['cape'] as Map<String, dynamic>),
      nameChapter: json['titlechapter'] as String,
      description: json['description'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) =>
                  PagesChapterItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: json['pagination'] as int? ?? 0,
    );

Map<String, dynamic> _$ChapterItemModelToJson(ChapterItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cape': instance.chaptersUrls,
      'titlechapter': instance.nameChapter,
      'description': instance.description,
      'items': instance.items,
      'pagination': instance.pagination,
    };
