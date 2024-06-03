import 'package:brasiltoon/src/constants/border_radius.dart';
import 'package:brasiltoon/src/models/follow_editor_models.dart';
import 'package:brasiltoon/src/models/user_models.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/common_widgets/card_widgest.dart';
import 'package:brasiltoon/src/pages/common_widgets/like_button.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brasiltoon/src/pages/editor_perfil/controller/perfil_controller.dart';
import 'package:brasiltoon/src/pages/home/controller/home_controller.dart';
import 'package:brasiltoon/src/pages/likes/controller/like_controller.dart';
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
  final void Function(GlobalKey) favoritesAnimationMethod;
  // final bool follow;
  const ItemTile({
    Key? key,
    required this.item,
    required this.favoritesAnimationMethod,
    // required this.follow,
  }) : super(key: key);

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final GlobalKey imageGk = GlobalKey();
  late void Function(GlobalKey) favoritesAnimationMethod;
  late bool isFavorite;

  final authController = Get.find<AuthController>();
  bool isCheckingFavorite = true;
  bool showFavoriteButton = false;
  final LikeController likeController =
      Get.put(LikeController()); // Mova o controlador aqui

  final UtilsServices utilServices = UtilsServices();
  final favoritesController = Get.find<FavoritesController>();
  IconData tileIcon = Icons.library_add;
  final homeController = Get.find<HomeController>();
  final PerfilController perfilController = Get.put(PerfilController());
  @override
  void initState() {
    super.initState();
    _checkIsFavorite();

    // _initializeLikeController(); // Inicializa o controlador de like
  }

  Future<void> _initializeLikeController() async {
    await likeController.checkLikeStatus(
        widget.item.id, authController.user.id!);
    await likeController.getLikeCount(widget.item.id);
  }

  @override
  void didUpdateWidget(ItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item != oldWidget.item) {
      _checkIsFavorite();
      //   _initializeLikeController(); // Atualiza o controlador de like
    }
  }

  Future<void> _checkIsFavorite() async {
    setState(() {
      isCheckingFavorite = true;
    });

    bool isItemFavorite = await favoritesController.isItemFavorite(widget.item);

    setState(() {
      isCheckingFavorite = false;
      showFavoriteButton = !isItemFavorite;
    });
  }

  Future<void> switchIcon() async {
    setState(() => tileIcon = isFavorite ? Icons.library_add : Icons.check);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => tileIcon = Icons.library_add);
  }

  Future<void> _addToFavorites(ItemModel item) async {
    setState(() {
      isCheckingFavorite = true;
    });

    await favoritesController.addItemToFavorites(item: item);

    setState(() {
      isFavorite = true;
      isCheckingFavorite = false;
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
        //likes da historia
        Positioned(
          bottom: 35,
          right: 4,
          child: Container(
            height: 35,
            constraints: const BoxConstraints(maxWidth: 200), // Max width
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: CustomColors.customSwatchColor,
              borderRadius: BorderRadius.circular(Border_Radius.circular),
            ),
            child: LikeButton(
              post: widget.item.id,
              userId: authController.user.id!,
            ),
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
                    // follow: widget.follow,
                  ));
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
                'Todos os capítulos e páginas desta história serão selecionados. Confirmar download?',
                'Sim',
                'Não',
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
