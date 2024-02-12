import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/view/publish_product_chapter_tab.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/controller/product_chapter_controller.dart';
import 'package:brasiltoon/src/pages/story_editing/edit_screen/components/select_chapter_tile.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectChapterToEditing extends StatefulWidget {
  final String productId;
  const SelectChapterToEditing({
    Key? key,
    required this.productId,
    required this.item,
  }) : super(key: key);
  final ItemModel item;
  @override
  State<SelectChapterToEditing> createState() => _SelectChapterToEditingState();
}

class _SelectChapterToEditingState extends State<SelectChapterToEditing> {
  final UtilsServices utilsServices = UtilsServices();
  final ProductChapterController controller =
      Get.put(ProductChapterController());
  @override
  @override
  void initState() {
    super.initState();
    _loadChapters(); // Chama a função que carrega os capítulos
  }

// Função para carregar os capítulos de forma assíncrona
  Future<void> _loadChapters() async {
    // Aguarda a conclusão da operação assíncrona
    await controller.getAllChapter(widget.productId);

    // Após a conclusão, você pode imprimir os capítulos
    //print('Capítulos carregados: ${controller.allChapters}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text('Capitulos'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(16), // Ajuste conforme necessário

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'selecione o capitulo que dejesa editar',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            // Lista de itens do carrinho
            Expanded(
              child:
                  GetBuilder<ProductChapterController>(builder: (controller) {
                if (controller.allChapters.isEmpty) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 40,
                          color: CustomColors.customSwatchColor,
                        ),
                        const Text('Não a capitulos postados'),
                      ]);
                }
                return ListView.builder(
                  itemCount: controller.allChapters.length,
                  itemBuilder: (_, index) {
                    return SelectChapterTile(
                      chapter: controller.allChapters[index],
                      productId: widget.productId,
                      item: widget.item,
                      index: index + 1,
                    );
                  },
                );
              }),
            ),
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
            const SizedBox(height: 10),
            SizedBox(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.customSwatchColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  Get.to(() => PublishChapterTab(productId: widget.item.id));
                  // print(widget.item.id);
                },
                child: const Text(
                  'Adicionar capitulo',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
