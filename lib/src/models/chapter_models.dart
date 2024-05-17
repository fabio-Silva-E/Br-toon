// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brasiltoon/src/models/gallery_models.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:brasiltoon/src/models/pages_chapters_models.dart';

part 'chapter_models.g.dart';

@JsonSerializable()
class ChapterItemModel {
  String id;
  @JsonKey(name: 'cape')
  GalleryModel? chaptersUrls;
  @JsonKey(name: 'titlechapter')
  String nameChapter;
  String description;
  @JsonKey(defaultValue: [])
  List<PagesChapterItemModel> items;
  @JsonKey(defaultValue: 0)
  int pagination;
  ChapterItemModel({
    this.id = '',
    required this.chaptersUrls,
    required this.nameChapter,
    required this.description,
    required this.items, //trocar o nome para chamada correta no endpoint
    required this.pagination,
  });
  factory ChapterItemModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterItemModelToJson(this);

  @override
  String toString() {
    return 'ChapterItemModel(id: $id, chaptersUrls: $chaptersUrls, nameChapter: $nameChapter, description: $description, items: $items, pagination: $pagination)';
  }
}
