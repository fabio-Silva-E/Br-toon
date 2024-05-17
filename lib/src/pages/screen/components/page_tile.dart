import 'package:brasiltoon/src/constants/border_radius.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/controller/product_pages_chapter_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageTile extends StatefulWidget {
  final String chapterId;
  final int index;
  const PageTile({
    Key? key,
    required this.chapterId,
    required this.page,
    required this.index,
    required this.chapter,
  }) : super(key: key);
  final PagesChapterItemModel page;
  final ChapterItemModel chapter;
  @override
  State<PageTile> createState() => _PageTileState();
}

class _PageTileState extends State<PageTile> {
  final GlobalKey imageGk = GlobalKey();
  final productPagesChapterController =
      Get.find<ProductPagesChapterController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      child: Column(
        // Substituindo Stack por Column
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            widget.page.page!.file,
            key: imageGk,
            fit: BoxFit.cover,
          ),
          Container(
            // Este container agora está abaixo da imagem
            color: Colors.black.withOpacity(0.5),
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Capítulo ${widget.chapter.nameChapter}, Página ${widget.index}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    bool? result =
                        await ShowOrderConfirmation.showOrderConfirmation(
                      context,
                      'Confirmar download desta página?',
                      'Sim',
                      'Não',
                    );
                    if (result ?? false) {
                      productPagesChapterController.downloadFile(
                        fileUrl: widget.page.page!.file,
                        name:
                            "Capítulo ${widget.chapter.nameChapter} - Página ${widget.index}",
                      );
                    }
                  },
                  child: const Icon(
                    Icons.download, // Ícone de download
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
