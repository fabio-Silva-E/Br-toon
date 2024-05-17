// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brasiltoon/src/models/gallery_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pages_chapters_models.g.dart';

@JsonSerializable()
class PagesChapterItemModel {
  String id;
  GalleryModel? page;

  PagesChapterItemModel({
    this.id = '',
    required this.page,
  });
  factory PagesChapterItemModel.fromJson(Map<String, dynamic> json) =>
      _$PagesChapterItemModelFromJson(json);

  get index => null;
  Map<String, dynamic> toJson() => _$PagesChapterItemModelToJson(this);

  @override
  String toString() => 'PagesChapterItemModel(id: $id, page: $page)';
}
