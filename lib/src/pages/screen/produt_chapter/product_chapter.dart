import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/pages/screen/components/chapter_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/controller/product_chapter_controller.dart';

class ProductChapter extends StatefulWidget {
  final String productId;
  const ProductChapter({
    Key? key,
    required this.productId,
    required this.item,
  }) : super(key: key);
  final ItemModel item;
  @override
  State<ProductChapter> createState() => _ProductChapterState();
}

class _ProductChapterState extends State<ProductChapter> {
  late List<PagesChapterItemModel> pagesList;
  late bool _isLoading;
  late ChapterItemModel selectedChapter;
  late ProductChapterController productChapterController;
  final ProductChapterController controller =
      Get.put(ProductChapterController());

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    controller.getAllChapter(widget.productId).then((_) {
      setState(() {
        _isLoading =
            false; // Quando os dados carregarem, altera o estado de carregamento
      });
    });
  }

// Função para carregar os capítulos de forma assíncrona

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.item.itemName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: _isLoading // Verifica se está carregando
          ? const Center(
              child:
                  CircularProgressIndicator(), // Mostra o indicador de carregamento
            )
          : Column(children: [
              // Lista de itens do carrinho
              Expanded(
                child:
                    GetBuilder<ProductChapterController>(builder: (controller) {
                  if (controller.allChapters.isEmpty) {
                    return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 40,
                              color: CustomColors.customSwatchColor,
                            ),
                            const Text(
                              'Não a capitulos postados',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ]),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.allChapters.length,
                    itemBuilder: (_, index) {
                      return ChapterTile(
                        chapter: controller.allChapters[index],
                        productId: widget.productId,
                        item: widget.item,
                        index: index + 1,
                      );
                    },
                  );
                }),
              ),
            ]),
    );
  }
}
