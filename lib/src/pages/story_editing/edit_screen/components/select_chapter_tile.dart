import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/story_editing/edit_screen/editi_chapter_tab.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectChapterTile extends StatefulWidget {
  final String productId;
  final int index;
  const SelectChapterTile({
    Key? key,
    required this.productId,
    required this.item,
    required this.chapter,
    required this.index,
  }) : super(key: key);
  final ItemModel item;
  final ChapterItemModel chapter;
  @override
  State<SelectChapterTile> createState() => _SelectChapterTileState();
}

class _SelectChapterTileState extends State<SelectChapterTile> {
  final GlobalKey imageGk = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => EditingChapterTab(
              chapterId: widget.chapter.id,
              chapter: widget.chapter,
            ));
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          // Imagem
          leading: Image.network(
            widget.chapter.chaptersUrls,
            key: imageGk,
            height: 60,
            width: 60,
          ),
          // Titulo
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                FittedBox(
                  child: Text(
                    widget.chapter.nameChapter,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          subtitle: Text(
            '  ${widget.index}° capitulo',
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
