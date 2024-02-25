import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/story_editing/edit_screen/editi_page_tab.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectPageTile extends StatefulWidget {
  final String chapterId;
  final int index;
  const SelectPageTile({
    Key? key,
    required this.chapterId,
    required this.page,
    required this.index,
    // required this.chapter,
  }) : super(key: key);
  final PagesChapterItemModel page;
  // final ChapterItemModel chapter;
  @override
  State<SelectPageTile> createState() => _SelectPageTileState();
}

class _SelectPageTileState extends State<SelectPageTile> {
  final GlobalKey imageGk = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => EditingPageTab(
              pageId: widget.page.id,
              page: widget.page,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '  ${widget.index}° pagina',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Image.network(
              widget.page.page,
              key: imageGk,
              fit: BoxFit.cover,
            ),
          ],
          // Titulo
        ),
      ),
    );
  }
}
