// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:brasiltoon/src/models/favoritecount_models.dart';
import 'package:brasiltoon/src/models/user_models.dart';

part 'like_models.g.dart';

@JsonSerializable()
class LikeModel {
  UserModel? userId;

  ItemModel? postId;
  LikeModel({
    this.userId,
    this.postId,
  });
  factory LikeModel.fromJson(Map<String, dynamic> json) =>
      _$LikeModelFromJson(json);
  Map<String, dynamic> toJson() => _$LikeModelToJson(this);

  @override
  String toString() => 'LikeModel(userId: $userId, postId: $postId)';
}
