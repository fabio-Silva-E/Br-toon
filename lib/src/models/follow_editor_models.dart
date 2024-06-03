// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:brasiltoon/src/models/user_models.dart';

part 'follow_editor_models.g.dart';

@JsonSerializable()
class FollowEditorModel {
  @JsonKey(name: 'followeditorId')
  String id;
  @JsonKey(name: 'user')
  UserModel? userId;
  @JsonKey(name: 'userId')
  UserModel? userIdEditor;
  @JsonKey(name: 'editorName')
  String? editorName;
  FollowEditorModel({
    this.userId,
    this.id = '',
    this.userIdEditor,
    this.editorName,
  });
  factory FollowEditorModel.fromJson(Map<String, dynamic> json) =>
      _$FollowEditorModelFromJson(json);
  Map<String, dynamic> toJson() => _$FollowEditorModelToJson(this);

  @override
  String toString() {
    return 'FollowEditorModel(id: $id, userId: $userId, userIdEditor: $userIdEditor, editorName: $editorName)';
  }
}
