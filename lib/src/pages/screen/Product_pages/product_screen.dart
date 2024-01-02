import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/controller/product_pages_chapter_controller.dart';

class ProductScreen extends StatelessWidget {
  final String chapterId;
  final ItemModel item;

  const ProductScreen({
    Key? key,
    required this.chapterId,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('Received chapter ID in ProductScreen: $chapterId');
    return Scaffold(
      appBar: AppBar(
        title: Text(item.itemName),
      ),
      backgroundColor: Colors.white.withAlpha(250),
      body: GetBuilder<ProductPagesChapterController>(
        builder: (controller) {
          List<PagesChapterItemModel> pages = controller.allPages;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: pages.map((page) {
                String pageUrl = page.page;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.asset(
                        pageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
