import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/controller/product_pages_chapter_controller.dart';

class ProductScreen extends StatefulWidget {
  final String chapterId;
  final ItemModel item;

  const ProductScreen({
    Key? key,
    required this.chapterId,
    required this.item,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductPagesChapterController controller =
      Get.put(ProductPagesChapterController(chapterId: ''));
  @override
  void initState() {
    super.initState();

    controller.getAllPages(widget.chapterId);
  }

  @override
  Widget build(BuildContext context) {
    // print('Received chapter ID in ProductScreen: $chapterId');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.itemName),
      ),
      backgroundColor: Colors.white.withAlpha(250),
      body: GetBuilder<ProductPagesChapterController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.allPages.length,
            itemBuilder: (context, index) {
              PagesChapterItemModel pages = controller.allPages[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'pagina ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Image.network(
                      pages.page,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
