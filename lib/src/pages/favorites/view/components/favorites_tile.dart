import 'package:brasiltoon/src/constants/border_radius.dart';
import 'package:brasiltoon/src/pages/common_widgets/card_widgest.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/models/favorites_models.dart';
import 'package:brasiltoon/src/pages/favorites/controller/favorietes_controller.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/product_chapter.dart';
import 'package:brasiltoon/src/services/util_services.dart';

class FavoritesTile extends StatefulWidget {
  final FavoritesItemModel favoritesItem;

  const FavoritesTile({
    super.key,
    required this.favoritesItem,
  });

  @override
  State<FavoritesTile> createState() => _FavoritesTileState();
}

class _FavoritesTileState extends State<FavoritesTile> {
  final UtilsServices ultilsServices = UtilsServices();
  final controller = Get.find<FavoritesController>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => ProductChapter(
                  productId:
                      widget.favoritesItem.item.id, // Passa o ID do produto
                  item: widget.favoritesItem.item,
                ));
          },
          child: CustomCardWidget(
            imageUrl: widget.favoritesItem.item.imgUrl!.file,
            itemName: widget.favoritesItem.item.itemName,
          ),
/* Card(
            elevation: 3,
            shadowColor: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //capat
                  GetBuilder<FavoritesController>(builder: (controller) {
                    return Expanded(
                      child: Image.network(
                        widget.favoritesItem.item.imgUrl,
                      ),
                    );
                  }),
                  //Nome
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.favoritesItem.item.itemName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //categoria
                ],
              ),
            ),
          ),*/
        ),
        //botão desfavoritar
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () async {
              // Mostra a caixa de diálogo de confirmação
              bool? confirmation =
                  await ShowOrderConfirmation.showOrderConfirmation(
                      context,
                      'Deseja realmente desfavoritar este conteudo',
                      'sim',
                      'não');
              if (confirmation == true) {
                // Chama a função remove apenas se a confirmação for verdadeira
                setState(() {
                  controller.removeItemTofavorites(item: widget.favoritesItem);
                });
              }
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: CustomColors.customSwatchColor,
                borderRadius: BorderRadius.circular(Border_Radius.circular),
              ),
              child: const Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
