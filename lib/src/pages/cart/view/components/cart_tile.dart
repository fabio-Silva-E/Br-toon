import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/models/cart_coin_models.dart';
import 'package:brasiltoon/src/pages/cart/controller/cart_controller.dart';
import 'package:brasiltoon/src/pages/common_widgets/quantity_widgest.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartTile extends StatefulWidget {
  final CartCoinModel cartCoin;

  const CartTile({
    Key? key,
    required this.cartCoin,
  }) : super(key: key);

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final UtilsServices utilsServices = UtilsServices();
  final controller = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    String unit = widget.cartCoin.coin.unitiQuantity.toString();
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        // Imagem
        leading: Image.network(
          widget.cartCoin.coin.imgUrl,
          height: 60,
          width: 60,
        ),

        // Titulo
        title: Text(
          widget.cartCoin.coin.itemName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        // Total
        subtitle: Text(
          utilsServices.priceToCurrency(widget.cartCoin.totalPrice()),
          style: TextStyle(
            color: CustomColors.customSwatchColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Quantidade

        trailing: QuantityWidget(
          suffixText: ' x $unit moedas',
          value: widget.cartCoin.quantity,
          result: (quantity) {
            controller.changeCoinQuantity(
              coin: widget.cartCoin,
              quantity: quantity,
            );
          },
          isRemovable: true,
        ),
      ),
    );
  }
}
