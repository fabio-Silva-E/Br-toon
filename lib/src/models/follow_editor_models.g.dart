// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_editor_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowEditorModel _$FollowEditorModelFromJson(Map<String, dynamic> json) =>
    FollowEditorModel(
      userId: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      id: json['followeditorId'] as String? ?? '',
      userIdEditor: json['userId'] == null
          ? null
          : UserModel.fromJson(json['userId'] as Map<String, dynamic>),
      editorName: json['editorName'] as String?,
    );

Map<String, dynamic> _$FollowEditorModelToJson(FollowEditorModel instance) =>
    <String, dynamic>{
      'followeditorId': instance.id,
      'user': instance.userId,
      'userId': instance.userIdEditor,
      'editorName': instance.editorName,
    };
