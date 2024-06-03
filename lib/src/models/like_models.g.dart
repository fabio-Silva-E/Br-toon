// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeModel _$LikeModelFromJson(Map<String, dynamic> json) => LikeModel(
      userId: json['userId'] == null
          ? null
          : UserModel.fromJson(json['userId'] as Map<String, dynamic>),
      postId: json['postId'] == null
          ? null
          : ItemModel.fromJson(json['postId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LikeModelToJson(LikeModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'postId': instance.postId,
    };
