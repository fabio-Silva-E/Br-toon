// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_count_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeCountModel _$LikeCountModelFromJson(Map<String, dynamic> json) =>
    LikeCountModel(
      postId: json['postId'] == null
          ? null
          : ProductModel.fromJson(json['postId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LikeCountModelToJson(LikeCountModel instance) =>
    <String, dynamic>{
      'postId': instance.postId,
    };
