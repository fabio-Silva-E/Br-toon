// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pages_chapters_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagesChapterItemModel _$PagesChapterItemModelFromJson(
        Map<String, dynamic> json) =>
    PagesChapterItemModel(
      id: json['id'] as String? ?? '',
      page: json['page'] == null
          ? null
          : GalleryModel.fromJson(json['page'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PagesChapterItemModelToJson(
        PagesChapterItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'page': instance.page,
    };
