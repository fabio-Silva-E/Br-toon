class OrderModel {
  String id;
  DateTime createdDateTime;
  DateTime overdueDateTime;
  //List<CartItemModel> items; //criar lista de moedas compraveis
  String status;
  String copyAndPaste;
  double total;

  OrderModel({
    required this.copyAndPaste,
    required this.createdDateTime,
    required this.id,
    //required this.items,
    required this.overdueDateTime,
    required this.status,
    required this.total,
  });
}
