// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_coin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartCoinModel _$CartCoinModelFromJson(Map<String, dynamic> json) =>
    CartCoinModel(
      id: json['id'] as String? ?? '',
      coin: CoinModel.fromJson(json['coin'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );

Map<String, dynamic> _$CartCoinModelToJson(CartCoinModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coin': instance.coin,
      'quantity': instance.quantity,
    };
