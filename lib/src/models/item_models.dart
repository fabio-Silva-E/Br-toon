// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'dart:io';

import 'package:brasiltoon/src/models/gallery_models.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/user_models.dart';

part 'item_models.g.dart';

@JsonSerializable()
class ItemModel {
  String id;
  @JsonKey(name: 'title')
  String itemName;
  @JsonKey(name: 'cape')
  // String imgUrl;
  GalleryModel? imgUrl;
  @JsonKey(name: 'user')
  UserModel? userId;
  String description;
  @JsonKey(defaultValue: [])
  List<ChapterItemModel> chapters; // Lista de URLs de imagens
  @JsonKey(defaultValue: 0)
  int pagination;

  ItemModel({
    this.id = '',
    this.userId,
    required this.description,
    required this.imgUrl,
    required this.itemName,
    required this.chapters,
    required this.pagination,
  });
  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ItemModelToJson(this);
  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModel && runtimeType == other.runtimeType && id == other.id;
  @override
  String toString() {
    return 'ItemModel(id: $id, itemName: $itemName, imgUrl: $imgUrl, userId: $userId, description: $description, chapters: $chapters, pagination: $pagination)';
  }
}
