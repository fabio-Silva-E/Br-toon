import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:brasiltoon/src/pages/editor_perfil/controller/perfil_controller.dart';
import 'package:brasiltoon/src/pages/home/view/components/item_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/pages/base/controller/navigation_controller.dart';
import 'package:brasiltoon/src/pages/common_widgets/app_name_widget.dart';
import 'package:brasiltoon/src/pages/common_widgets/custom_shimmer.dart';
import 'package:brasiltoon/src/pages/favorites/controller/favorietes_controller.dart';
import 'package:brasiltoon/src/pages/common_widgets/category_tile.dart';
//import 'package:greengrocer/src/config/app_data.dart' as appData;
import 'package:brasiltoon/src/pages/home/controller/home_controller.dart';
import 'package:brasiltoon/src/services/util_services.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GlobalKey<CartIconKey> globalKeyFavoritesItems = GlobalKey<CartIconKey>();
  final searchController = TextEditingController();
  final navigationController = Get.find<NavigationController>();
  final favoritesController = Get.find<FavoritesController>();
  late Function(GlobalKey) runAddFavoritesAnimatios;

  void itemSelectedFavoritesAnimentinos(GlobalKey gkImage) {
    runAddFavoritesAnimatios(gkImage);

    ultilsServices.showToast(message: ' adicionado aos seus favoritos');
  }

  final PerfilController perfilController = Get.put(PerfilController());

  final UtilsServices ultilsServices = UtilsServices();
  /* @override
  void initState() {
    super.initState();
    // Chamada para obter o contador de favoritos
    _fetchFavoritesCount();
  }

// Função assíncrona para buscar o contador de favoritos
  void _fetchFavoritesCount() async {
    int count = await favoritesController.getTotalFavoritesCount();
    setState(() {
      favoritesCount = count.toString();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      gkCart: globalKeyFavoritesItems,
      previewDuration: const Duration(milliseconds: 100),
      previewCurve: Curves.ease,
      receiveCreateAddToCardAnimationMethod: (addToCardAnimationMethod) {
        runAddFavoritesAnimatios = addToCardAnimationMethod;
      },
      child: Scaffold(
        //app bar
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: const AppNameWidget(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                right: 15,
              ),
              child: GetBuilder<FavoritesController>(
                builder: (controller) {
                  return GestureDetector(
                    onTap: () {
                      navigationController
                          .navigatePageview(NavigationTabs.favorites);
                    },
                    child: Badge(
                      backgroundColor: CustomColors.redContrastColor,
                      label: Text(
                        controller.favoritesCount.length.toString(),
                        //favoritesCount,
                        //obs fazer uma função no backend para tentar sanar  erro
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      child: AddToCartIcon(
                        key: globalKeyFavoritesItems,
                        icon: Icon(
                          Icons.library_add,
                          color: CustomColors.customSwatchColor,
                        ),
                      ),
                    ),
                  );

                  //  }
                },
              ),
            )
          ],
        ),

        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              //campo de pesquisa
              GetBuilder<HomeController>(builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      controller.searchTitle.value = value;
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        hintText: 'pesquise aqui...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: CustomColors.redContrastColor,
                          size: 14,
                        ),
                        suffixIcon: controller.searchTitle.value.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  controller.searchTitle.value = '';
                                  FocusScope.of(context).unfocus();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: CustomColors.redContrastColor,
                                  size: 14,
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ))),
                  ),
                );
              }),

              //categorias
              GetBuilder<HomeController>(
                builder: (controller) {
                  return Container(
                    padding: const EdgeInsets.only(left: 25),
                    height: 40,
                    child: !controller.isCategoryLoading
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              return CategoryTile(
                                onPressed: () {
                                  controller.selectCategory(
                                      controller.allCategories[index]);
                                },
                                category: controller.allCategories[index].title,
                                isSelected: controller.allCategories[index] ==
                                    controller.currentCategory,
                              );
                            },
                            separatorBuilder: (_, index) =>
                                const SizedBox(width: 10),
                            itemCount: controller.allCategories.length,
                          )
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                              10,
                              (index) => Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 12),
                                child: CustomShimmer(
                                  height: 20,
                                  width: 80,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
              //grid
              GetBuilder<HomeController>(
                builder: (controller) {
                  return Expanded(
                    child: !controller.isProductLoading
                        ? Visibility(
                            visible: (controller.currentCategory?.items ?? [])
                                .isNotEmpty,
                            replacement: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 40,
                                  color: CustomColors.customSwatchColor,
                                ),
                                const Text(
                                  'Não a historias com esse titulo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 9 / 11.5,
                              ),
                              itemCount: controller.allProducts.length,
                              itemBuilder: (_, index) {
                                if ((index + 1) ==
                                    controller.allProducts.length) {
                                  if (((index + 1) ==
                                          controller.allProducts.length) &&
                                      !controller.isLastPage) {
                                    controller.loadMoreProducts();
                                  }
                                }

                                return ItemTile(
                                  item: controller.allProducts[index],
                                  favoritesAnimationMethod:
                                      itemSelectedFavoritesAnimentinos,
                                  // follow: perfilController.isFollowing.value,
                                );
                              },
                            ),
                          )
                        : GridView.count(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            physics: const BouncingScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 9 / 11.5,
                            children: List.generate(
                              10,
                              (index) => CustomShimmer(
                                height: double.infinity,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
