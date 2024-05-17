// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryModel _$GalleryModelFromJson(Map<String, dynamic> json) => GalleryModel(
      id: json['id'] as String? ?? '',
      file: json['image'] as String? ?? '',
    );

Map<String, dynamic> _$GalleryModelToJson(GalleryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.file,
    };
