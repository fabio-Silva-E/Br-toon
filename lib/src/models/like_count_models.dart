// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:brasiltoon/src/models/favoritecount_models.dart';

part 'like_count_models.g.dart';

@JsonSerializable()
class LikeCountModel {
  ProductModel? postId;
  LikeCountModel({
    this.postId,
  });
  factory LikeCountModel.fromJson(Map<String, dynamic> json) =>
      _$LikeCountModelFromJson(json);
  Map<String, dynamic> toJson() => _$LikeCountModelToJson(this);

  @override
  String toString() => 'LikeCountModel(postId: $postId)';
}
