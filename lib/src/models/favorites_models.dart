// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:brasiltoon/src/models/item_models.dart';

part 'favorites_models.g.dart';

@JsonSerializable()
class FavoritesItemModel {
  @JsonKey(name: 'product')
  ItemModel item;
  String id;
  //@JsonKey(name: 'category')
  // String genere;
  //int itemCount;
  @JsonKey(defaultValue: 0)
  int pagination;

  FavoritesItemModel({
    required this.id,
    required this.item,
    //  required this.genere,
    required this.pagination,
  });
  factory FavoritesItemModel.fromJson(Map<String, dynamic> json) =>
      _$FavoritesItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoritesItemModelToJson(this);

  @override
  String toString() =>
      'FavoritesItemModel(item: $item, id: $id, pagination: $pagination)';
}
