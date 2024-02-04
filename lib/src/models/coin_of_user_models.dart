// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'coin_of_user_models.g.dart';

@JsonSerializable()
class CoinOfUserModel {
  String id;
  int coins;

  CoinOfUserModel({
    this.id = '',
    required this.coins,
  });
  factory CoinOfUserModel.fromJson(Map<String, dynamic> json) =>
      _$CoinOfUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$CoinOfUserModelToJson(this);

  @override
  String toString() => 'CoinOfUserModel(id: $id, coins: $coins)';
}
