// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:brasiltoon/src/models/favorites_models.dart';

part 'category_favorite_model.g.dart';

@JsonSerializable()
class CategoryModelFavorite {
  String title;
  String id;
  @JsonKey(defaultValue: [])
  List<FavoritesItemModel> favorites;
  @JsonKey(defaultValue: 0)
  int pagination;

  CategoryModelFavorite({
    required this.title,
    required this.id,
    required this.favorites,
    required this.pagination,
  });
  factory CategoryModelFavorite.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFavoriteFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelFavoriteToJson(this);

  @override
  String toString() {
    return 'CategoryModelFavorite(title: $title, id: $id, favorites: $favorites, pagination: $pagination)';
  }
}
