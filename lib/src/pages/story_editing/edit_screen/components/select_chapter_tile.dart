import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brasiltoon/src/pages/story_editing/controller/editing_controller.dart';
import 'package:brasiltoon/src/pages/story_editing/edit_screen/editi_chapter_tab.dart';
import 'package:brasiltoon/src/services/util_services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectChapterTile extends StatefulWidget {
  final String productId;
  final int index;
  const SelectChapterTile({
    Key? key,
    required this.productId,
    // required this.item,
    required this.chapter,
    required this.index,
  }) : super(key: key);
  // final ItemModel item;
  final ChapterItemModel chapter;
  @override
  State<SelectChapterTile> createState() => _SelectChapterTileState();
}

class _SelectChapterTileState extends State<SelectChapterTile> {
  final GlobalKey imageGk = GlobalKey();
  final editingController = Get.find<EditingController>();
  final UtilsServices utilsServices = UtilsServices();
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
          leading: Image.network(
            widget.chapter.chaptersUrls!.file,
            key: imageGk,
            height: 60,
            width: 60,
          ),
          title: Text(
            widget.chapter.nameChapter,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            '  ${widget.index}° capítulo',
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Background color to red
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  bool? result = await ShowOrderConfirmation.showOrderConfirmation(
                      context,
                      'Esta certo de que quer deletar este capitulo todas a paginas relacionadas a ele serão deletadas?',
                      'sim',
                      'não');
                  if (result ?? false) {
                    await editingController.deleteChapter(
                      chapterId: widget.chapter.id,
                      productId: widget.productId,
                    );
                  } else {
                    utilsServices.showToast(message: 'Exclusão não concluída');
                  }
                },
                child: editingController.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 20,
                      ),
              )),
        ),
      ),
    );
  }
}
