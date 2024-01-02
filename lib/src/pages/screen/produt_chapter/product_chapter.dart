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

  late ChapterItemModel selectedChapter;
  late ProductChapterController productChapterController;
  final ProductChapterController controller =
      Get.put(ProductChapterController());

  @override
  void initState() {
    super.initState();

    controller.getAllChapter(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.itemName),
      ),
      body: GetBuilder<ProductChapterController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.allChapters.length,
            itemBuilder: (context, index) {
              ChapterItemModel chapter = controller.allChapters[index];

              return GestureDetector(
                onTap: () async {
                  ProductChapterController controller =
                      Get.find<ProductChapterController>();

                  controller.onChapterSelected(chapter.id, widget.item);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Capítulo ${index + 1} - ${chapter.nameChapter}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Image.asset(
                        chapter.chaptersUrls,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
