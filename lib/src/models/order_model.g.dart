// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      createdDateTime: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      overdueDateTime: DateTime.parse(json['endDate'] as String),
      paymentUrl: json['paymentUrl'] as String,
      coins: (json['coins'] as List<dynamic>?)
              ?.map((e) => CartCoinModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      status: json['status'] as String,
      preferenceId: json['preferenceId'] as String,
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.createdDateTime?.toIso8601String(),
      'endDate': instance.overdueDateTime.toIso8601String(),
      'coins': instance.coins,
      'status': instance.status,
      'paymentUrl': instance.paymentUrl,
      'preferenceId': instance.preferenceId,
      'total': instance.total,
    };
