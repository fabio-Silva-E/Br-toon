import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/product_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChapterTile extends StatefulWidget {
  final String productId;
  final int index;
  const ChapterTile({
    Key? key,
    required this.productId,
    required this.item,
    required this.chapter,
    required this.index,
  }) : super(key: key);
  final ItemModel item;
  final ChapterItemModel chapter;
  @override
  State<ChapterTile> createState() => _ChapterTileState();
}

class _ChapterTileState extends State<ChapterTile> {
  final GlobalKey imageGk = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductScreen(
              chapterId: widget.chapter.id,
              item: widget.item,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            Image.network(
              widget.chapter.chaptersUrls,
              key: imageGk,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(
                    0.5), // Adicione uma cor de fundo ao texto para melhorar a legibilidade
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${widget.index}° capitulo  ${widget.chapter.nameChapter}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
