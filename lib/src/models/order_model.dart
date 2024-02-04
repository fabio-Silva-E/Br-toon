// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:brasiltoon/src/models/cart_coin_models.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  String id;

  @JsonKey(name: 'startDate')
  DateTime? createdDateTime;

  @JsonKey(name: 'endDate')
  DateTime overdueDateTime;

  @JsonKey(defaultValue: [])
  List<CartCoinModel> coins;
  String status;
  String paymentUrl;
  String preferenceId;

  double total;

  bool get isOverDue => overdueDateTime.isBefore(DateTime.now());

  OrderModel({
    required this.id,
    this.createdDateTime,
    required this.overdueDateTime,
    required this.paymentUrl,
    required this.coins,
    required this.status,
    required this.preferenceId,
    required this.total,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  @override
  String toString() {
    return 'OrderModel(id: $id, createdDateTime: $createdDateTime, overdueDateTime: $overdueDateTime, coins: $coins, status: $status, paymentUrl: $paymentUrl, preferenceId: $preferenceId, total: $total)';
  }
}
