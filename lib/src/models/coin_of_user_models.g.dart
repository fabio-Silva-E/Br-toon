// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_of_user_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinOfUserModel _$CoinOfUserModelFromJson(Map<String, dynamic> json) =>
    CoinOfUserModel(
      id: json['id'] as String? ?? '',
      coins: json['coins'] as int,
    );

Map<String, dynamic> _$CoinOfUserModelToJson(CoinOfUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coins': instance.coins,
    };
