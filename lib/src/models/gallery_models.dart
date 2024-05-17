// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'gallery_models.g.dart';

@JsonSerializable()
class GalleryModel {
  String id;
  @JsonKey(name: 'image')
  String file;

  GalleryModel({
    this.id = '',
    this.file = '',
  });
  factory GalleryModel.fromJson(Map<String, dynamic> json) =>
      _$GalleryModelFromJson(json);
  Map<String, dynamic> toJson() => _$GalleryModelToJson(this);

  @override
  String toString() => 'GalleryModel(id: $id, file: $file)';
}
