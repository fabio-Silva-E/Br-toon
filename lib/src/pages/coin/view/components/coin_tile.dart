import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/models/coin_models.dart';
import 'package:brasiltoon/src/pages/cart/controller/cart_controller.dart';

import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoinTile extends StatefulWidget {
  final CoinModel coin;
  final void Function(GlobalKey) cartAnimationMethod;
  const CoinTile({
    Key? key,
    required this.coin,
    required this.cartAnimationMethod,
  }) : super(key: key);

  @override
  State<CoinTile> createState() => _CoinTileState();
}

class _CoinTileState extends State<CoinTile> {
  final GlobalKey imageGk = GlobalKey();
  final UtilsServices utilsServices = UtilsServices();
  IconData tileIcon = Icons.add_shopping_cart_outlined;
  final cartController = Get.find<CartController>();

  Future<void> switchIcon() async {
    setState(() => tileIcon = Icons.check);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => tileIcon = Icons.add_shopping_cart_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        // Imagem
        leading: Image.network(
          widget.coin.imgUrl,
          key: imageGk,
          height: 60,
          width: 60,
        ),
        // Titulo
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              FittedBox(
                child: Text(
                  widget.coin.itemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Espaçamento entre os elementos
              Text(
                ' =  ${widget.coin.unitiQuantity}  moedas',
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Total
        subtitle: Text(
          utilsServices.priceToCurrency(widget.coin.price),
          style: TextStyle(
            color: CustomColors.customSwatchColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Quantidade

        trailing: Material(
          child: InkWell(
            onTap: () {
              switchIcon();

              cartController.addCoinToCart(coin: widget.coin);
              widget.cartAnimationMethod(imageGk);
            },
            child: Ink(
              height: 40,
              width: 35,
              decoration: BoxDecoration(
                color: CustomColors.customSwatchColor,
              ),
              child: Icon(
                tileIcon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
