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
  int unitiQuantity;
  CoinModel({
    this.id = '',
    required this.imgUrl,
    required this.itemName,
    required this.unitiQuantity,
    required this.price, //trocar o nome para chamada correta no endpoint
  });
  factory CoinModel.fromJson(Map<String, dynamic> json) =>
      _$CoinModelFromJson(json);
  Map<String, dynamic> toJson() => _$CoinModelToJson(this);
  @override
  String toString() {
    return 'CoinModel(id: $id, itemName: $itemName, imgUrl: $imgUrl, price: $price, unitiQuantity: $unitiQuantity)';
  }
}
