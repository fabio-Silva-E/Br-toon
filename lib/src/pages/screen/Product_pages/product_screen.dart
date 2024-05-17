import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/pages/screen/components/page_tile.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/controller/product_pages_chapter_controller.dart';

class ProductScreen extends StatefulWidget {
  final String chapterId;
  final ItemModel item;
  final ChapterItemModel name;
  const ProductScreen({
    Key? key,
    required this.chapterId,
    required this.item,
    required this.name,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late bool _isLoading;
  final UtilsServices utilsServices = UtilsServices();
  final ProductPagesChapterController controller =
      Get.put(ProductPagesChapterController());

  @override
  /* void initState() {
    super.initState();
    _isLoading = true;

    // Chamadas das funções independentes
    _loadPagesAndCheckMessage();
    _loadAllPages();
  }

  Future<void> _loadPagesAndCheckMessage() async {
    String message = await controller.messageGetCountPages(widget.chapterId);

    if (message == 'PAGES_TO_ADD_FOUND') {
      _showConfirmationDialog();
    }
  }

  Future<void> _showConfirmationDialog() async {
    bool? result = await ShowOrderConfirmation.showOrderConfirmation(
        context,
        'A mais paginas para este capitulos a serem liberados com o uso de moedas deseja liberar mais paginas?',
        'sim',
        'não');

    if (result ?? false) {
      await controller.addCountPages(widget.chapterId);
      await _loadAllPages();
    }
  }

  Future<void> _loadAllPages() async {
    await controller.getAllPages(widget.chapterId).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }*/
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadPages(); // Chama a função que carrega os capítulos
  }

// Função para carregar os capítulos de forma assíncrona
  Future<void> _loadPages() async {
    // Aguarda a conclusão da operação assíncrona
    await controller.getAllPages(widget.chapterId);
    setState(() {
      _isLoading = false;
    });
    // Após a conclusão, você pode imprimir os capítulos
    //print('Capítulos carregados: ${controller.allChapters}');
  }

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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: GetBuilder<ProductPagesChapterController>(
                    builder: (controller) {
                      if (controller.allPages.isEmpty) {
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
                                'Não há páginas postadas',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: controller.allPages.length,
                        itemBuilder: (_, index) {
                          return PageTile(
                            page: controller.allPages[index],
                            chapterId: widget.chapterId,
                            index: index + 1,
                            chapter: widget.name,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
