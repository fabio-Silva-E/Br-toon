import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/pages/common_widgets/custom_shimmer.dart';
import 'package:brasiltoon/src/pages/common_widgets/category_tile.dart';
import 'package:brasiltoon/src/pages/publish_product/cape_product/view/publish_product_tab.dart';
import 'package:brasiltoon/src/pages/publishers/controller/publishers_contoller.dart';
import 'package:brasiltoon/src/pages/publishers/view/components/publishers_tile.dart';

class PublishersTab extends StatefulWidget {
  const PublishersTab({super.key});

  @override
  State<PublishersTab> createState() => _PublishersTabState();
}

class _PublishersTabState extends State<PublishersTab> {
  final searchController = TextEditingController();
  /* void removeItemFromPublishers(PublishersItemModel publishersItem) {
    setState(() {
      appData.publishersItems.remove(publishersItem);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            'Minhas Publicações',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          color: Colors.black,
          child: Column(children: [
            //campo de pesquisa
            GetBuilder<PublisherController>(
              builder: (controller) {
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
              },
            ),

            //categorias
            GetBuilder<PublisherController>(
              builder: (controller) {
                return Container(
                  padding: const EdgeInsets.only(left: 25),
                  height: 40,
                  child: !controller.isCategoryloading
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            return CategoryTile(
                              onPressed: () {
                                controller.selectCategory(
                                  controller.allCategories[index],
                                );
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
            GetBuilder<PublisherController>(
              builder: (controller) {
                return Expanded(
                  child: !controller.isProductloading
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
                                'Não há histórias para apresentar',
                                style: TextStyle(
                                  fontSize: 12,
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
                              return PublishersTile(
                                publishersItem: controller.allProducts[index],
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
            //publicar historia
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  /*    bool? result = await ShowOrderConfirmation.showOrderConfirmation(
                      context,
                      'Para realizar publicações sera necessario ter moedas en sua carteira Brasiltoon',
                      'continuar',
                      'sair');
                  if (result ?? false) {*/
                  Get.to(() => const PublishProductTab());
                  //  }
                },
                // Navegação para a página PublishProduct

                child: const Text(
                  'Publicar Historia',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
