import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/pages/cart/view/cart_tab.dart';

import 'package:brasiltoon/src/pages/coin/controller/coin_controller.dart';
import 'package:brasiltoon/src/pages/coin/view/components/coin_tile.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoinTab extends StatefulWidget {
  const CoinTab({Key? key}) : super(key: key);

  @override
  State<CoinTab> createState() => _CoinTabState();
}

class _CoinTabState extends State<CoinTab> {
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coins'),
      ),
      body: Column(
        children: [
          // Lista de itens do carrinho
          Expanded(
            child: GetBuilder<CoinController>(builder: (controller) {
              return ListView.builder(
                itemCount: controller.coins.length,
                itemBuilder: (_, index) {
                  return CoinTile(
                    coin: controller.coins[index],
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
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.customSwatchColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () async {
                Get.to(() => const CartTab());
              },
              child: const Text(
                'Carrinho',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
