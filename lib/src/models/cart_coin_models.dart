// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:brasiltoon/src/models/coin_models.dart';

part 'cart_coin_models.g.dart';

@JsonSerializable()
class CartCoinModel {
  String id;
  CoinModel coin;
  int quantity;

  CartCoinModel({
    this.id = '',
    required this.coin,
    required this.quantity, //trocar o nome para chamada correta no endpoint
  });
  factory CartCoinModel.fromJson(Map<String, dynamic> json) =>
      _$CartCoinModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartCoinModelToJson(this);

  double totalPrice() => coin.price * quantity;
  @override
  String toString() {
    return 'CartCoinModel(id: $id, coin: $coin, quantity: $quantity)';
  }
}
