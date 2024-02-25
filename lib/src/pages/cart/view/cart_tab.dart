import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/pages/cart/controller/cart_controller.dart';
import 'package:brasiltoon/src/pages/cart/view/components/cart_tile.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartTab extends StatefulWidget {
  const CartTab({Key? key}) : super(key: key);

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final UtilsServices utilsServices = UtilsServices();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Carrinho',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Lista de itens do carrinho
          Expanded(
            child: GetBuilder<CartController>(builder: (controller) {
              if (controller.cartCoins.isEmpty) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_shopping_cart,
                        size: 40,
                        color: CustomColors.customSwatchColor,
                      ),
                      const Text(
                        'Não há moedas no carrinho',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ]);
              }
              return ListView.builder(
                itemCount: controller.cartCoins.length,
                itemBuilder: (_, index) {
                  return CartTile(
                    cartCoin: controller.cartCoins[index],
                  );
                },
              );
            }),
          ),

          // Total e botão de concluir o pedido
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total geral',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      GetBuilder<CartController>(
                        builder: (controller) {
                          return Text(
                            utilsServices
                                .priceToCurrency(controller.cartTotalPrice()),
                            style: TextStyle(
                              fontSize: 23,
                              color: CustomColors.customSwatchColor,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: GetBuilder<CartController>(
                    builder: (controller) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.customSwatchColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: (controller.isCheckoutLoading ||
                                controller.cartCoins.isEmpty)
                            ? null
                            : () async {
                                bool? result = await ShowOrderConfirmation
                                    .showOrderConfirmation(
                                        context,
                                        'Deseja realmente concluir a compra no app?',
                                        'sim',
                                        'não');

                                if (result ?? false) {
                                  cartController.checkoutCart();
                                } else {
                                  utilsServices.showToast(
                                    message: 'Pedido não confirmado',
                                  );
                                }
                              },
                        child: controller.isCheckoutLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Concluir pedido',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
