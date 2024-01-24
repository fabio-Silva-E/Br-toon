import 'package:brasiltoon/src/models/coin_models.dart';
import 'package:json_annotation/json_annotation.dart';

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
    return 'CartCoinModel(coin: $coin, id: $id, quantity: $quantity)';
  }
}
