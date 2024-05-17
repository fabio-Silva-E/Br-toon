import 'package:brasiltoon/src/constants/border_radius.dart';
import 'package:brasiltoon/src/pages/common_widgets/card_widgest.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brasiltoon/src/pages/home/controller/home_controller.dart';
import 'package:brasiltoon/src/pages/profile/editor_profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/favorites/controller/favorietes_controller.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/product_chapter.dart';
import 'package:brasiltoon/src/services/util_services.dart';

class ItemTile extends StatefulWidget {
  final ItemModel item;
  //final List<ItemModel> categoryItems;
  final void Function(GlobalKey) favoritesAnimationMethod;

  // final CategoryModel category;
  const ItemTile({
    Key? key,
    required this.item,
    required this.favoritesAnimationMethod,
  }) : super(key: key);

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final GlobalKey imageGk = GlobalKey();
  late void Function(GlobalKey) favoritesAnimationMethod;
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

  @override
  void didUpdateWidget(ItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item != oldWidget.item) {
      _checkIsFavorite();
    }
  }

  Future<void> _checkIsFavorite() async {
    // Define o estado para mostrar o indicador de carregamento
    setState(() {
      isCheckingFavorite = true;
    });

    bool isItemFavorite = await favoritesController.isItemFavorite(widget.item);

    // Atualiza o estado após a conclusão da verificação
    setState(() {
      isCheckingFavorite = false;
      // Define o estado para mostrar ou ocultar o botão favorito com base no resultado da verificação
      showFavoriteButton =
          !isItemFavorite; // Exibe o botão se o item não for favorito
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
    // await favoritesController.updateFavoritesCount();
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
          child: CustomCardWidget(
            imageUrl: widget.item.imgUrl!.file,
            itemName: widget.item.itemName,
            imageGk: imageGk,
          ),
        ),
        if (showFavoriteButton)

          // Verifica se o botão deve ser exibido
          Positioned(
            top: 4,
            right: 4,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Border_Radius.circular),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        switchIcon();
                        // Executa a função de adição aos favoritos
                        _addToFavorites(widget.item);
                      },
                      child: Ink(
                        height: 35,
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
                          bottomLeft: Radius.circular(Border_Radius.bottomLeft),
                          topRight: Radius.circular(Border_Radius.topRight),
                        ),
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
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
        //perfil do editor
        Positioned(
          bottom: 34,
          left: 4,
          child: GestureDetector(
            onTap: () async {
              Get.to(() => PerfilTab(
                    userId: widget.item.userId!.id!,
                  ));
              // print('file ${widget.item.imgUrl.file}');
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: CustomColors.customSwatchColor,
                borderRadius: BorderRadius.circular(Border_Radius.circular),
              ),
              child: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: GestureDetector(
            onTap: () async {
              bool? result = await ShowOrderConfirmation.showOrderConfirmation(
                context,
                ' todos os capitulos e paginas desta historia serão selecionados comfirmar download ?',
                'sim',
                'não',
              );
              if (result ?? false) {
                homeController.downloadAllChaptersAndPages(item: widget.item);
              }
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(Border_Radius.circular),
              ),
              child: const Icon(
                Icons.file_download,
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
