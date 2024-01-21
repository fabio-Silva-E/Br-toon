// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'coin_models.g.dart';

@JsonSerializable()
class CoinModel {
  String id;
  @JsonKey(name: 'title')
  String itemName;
  @JsonKey(name: 'picture')
  String imgUrl;
  double price;

  CoinModel({
    this.id = '',
    required this.imgUrl,
    required this.itemName,
    required this.price, //trocar o nome para chamada correta no endpoint
  });
  factory CoinModel.fromJson(Map<String, dynamic> json) =>
      _$CoinModelFromJson(json);
  Map<String, dynamic> toJson() => _$CoinModelToJson(this);
}
