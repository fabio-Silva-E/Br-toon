// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinModel _$CoinModelFromJson(Map<String, dynamic> json) => CoinModel(
      id: json['id'] as String? ?? '',
      imgUrl: json['picture'] as String,
      itemName: json['title'] as String,
      unitiQuantity: json['unitiQuantity'] as int,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$CoinModelToJson(CoinModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.itemName,
      'picture': instance.imgUrl,
      'price': instance.price,
      'unitiQuantity': instance.unitiQuantity,
    };
