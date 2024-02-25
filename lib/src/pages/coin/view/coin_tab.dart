import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';

import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/models/coin_of_user_models.dart';
import 'package:brasiltoon/src/pages/base/controller/navigation_controller.dart';
import 'package:brasiltoon/src/pages/cart/controller/cart_controller.dart';
import 'package:brasiltoon/src/pages/cart/view/cart_tab.dart';

import 'package:brasiltoon/src/pages/coin/controller/coin_controller.dart';
import 'package:brasiltoon/src/pages/coin/view/components/coin_tile.dart';
import 'package:brasiltoon/src/pages/coin/view/components/coin_to_user.dart';
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
  GlobalKey<CartIconKey> globalKeyCartCoins = GlobalKey<CartIconKey>();
  final navigationController = Get.find<NavigationController>();
  late Function(GlobalKey) runAddToCardAnimation;

  void itemSelectedCartAnimations(GlobalKey gkImage) {
    runAddToCardAnimation(gkImage);
  }

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      gkCart: globalKeyCartCoins,
      previewDuration: const Duration(milliseconds: 100),
      previewCurve: Curves.ease,
      receiveCreateAddToCardAnimationMethod: (addToCardAnimationMethod) {
        runAddToCardAnimation = addToCardAnimationMethod;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Coins',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                right: 15,
              ),
              child: GetBuilder<CartController>(
                builder: (controller) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => const CartTab());
                    },
                    child: Badge(
                      backgroundColor: CustomColors.customContrastColor,
                      label: Text(
                        controller.getCartTotalCoins().toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      child: AddToCartIcon(
                        key: globalKeyCartCoins,
                        icon: Icon(
                          Icons.shopping_cart,
                          color: CustomColors.customSwatchColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(160.0), // Ajuste conforme necessário
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.vertical(
                    // top: Radius.circular(30),
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
                  const Text(
                    'minhas moedas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GetBuilder<CoinController>(
                    builder: (controller) {
                      if (controller.coinsUser.isNotEmpty) {
                        return CoinOfUserTile(
                          coin: controller.coinsUser.first,
                        );
                      } else {
                        return CoinOfUserTile(
                          coin: CoinOfUserModel(
                              coins: 0), // Crie um modelo com valor zero
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 10), // Espaçamento entre os elementos
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'loja de moedas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.black,
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
                        cartAnimationMethod: itemSelectedCartAnimations);
                  },
                );
              }),
            ),

            // Total e botão de concluir o pedido
            /*  Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                /*   boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 3,
                    spreadRadius: 2,
                  ),
                ],*/
              ),
            ),*/
            //botão do carrinho
            SizedBox(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
