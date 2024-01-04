import 'package:brasiltoon/src/pages/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/favorites/controller/favorietes_controller.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/product_chapter.dart';
import 'package:brasiltoon/src/services/util_services.dart';

class ItemTile extends StatefulWidget {
  final ItemModel item;
  final void Function(GlobalKey) favoritesAnimationMethod;

  const ItemTile({
    super.key,
    required this.item,
    required this.favoritesAnimationMethod,
  });

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final GlobalKey imageGk = GlobalKey();
  late bool isFavorite;
  bool isCheckingFavorite =
      true; // Adiciona uma variável para rastrear o estado de checagem
  bool showFavoriteButton =
      false; // Adiciona uma variável para determinar se o botão deve ser exibido

  final UtilsServices utilServices = UtilsServices();
  final favoritesController = Get.find<FavoritesController>();
  IconData tileIcon = Icons.library_add;
  final homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    _checkIsFavorite();
  }

  Future<void> _checkIsFavorite() async {
    // Define o estado para mostrar o indicador de carregamento
    setState(() {
      isCheckingFavorite = true;
    });

    isFavorite = await homeController.isItemFavorite(widget.item);

    // Atualiza o estado após a conclusão da verificação
    setState(() {
      isCheckingFavorite = false;
      // Define o estado para mostrar ou ocultar o botão favorito com base no resultado da verificação
      showFavoriteButton = !isFavorite;
    });
  }

  Future<void> switchIcon() async {
    setState(() => tileIcon = isFavorite ? Icons.library_add : Icons.check);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => tileIcon = Icons.library_add);
  }

  Future<void> _addToFavorites(ItemModel item) async {
    // Define o estado para mostrar o indicador de carregamento
    setState(() {
      isCheckingFavorite = true;
    });

    await favoritesController.addItemToFavorites(item: item);

    // Atualiza o estado após a conclusão da operação de adição aos favoritos
    setState(() {
      isFavorite = true;
      isCheckingFavorite = false;
      // Define o estado para ocultar o botão favorito após a adição bem-sucedida
      showFavoriteButton = false;
    });

    widget.favoritesAnimationMethod(imageGk);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => ProductChapter(
                  productId: widget.item.id,
                  item: widget.item,
                ));
          },
          child: Card(
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
                  Expanded(
                    child: Image.asset(
                      widget.item.imgUrl,
                      key: imageGk,
                    ),
                  ),
                  Text(
                    widget.item.itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (showFavoriteButton) // Verifica se o botão deve ser exibido
          Positioned(
            top: 4,
            right: 4,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(20),
                  ),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        switchIcon();
                        // Executa a função de adição aos favoritos
                        _addToFavorites(widget.item);
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
                if (isCheckingFavorite)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

// ...
      ],
    );
  }
}
