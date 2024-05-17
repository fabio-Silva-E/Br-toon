import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brasiltoon/src/pages/story_editing/controller/editing_controller.dart';
import 'package:brasiltoon/src/pages/story_editing/edit_screen/editi_page_tab.dart';
import 'package:brasiltoon/src/services/util_services.dart';

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

  @override
  State<SelectPageTile> createState() => _SelectPageTileState();
}

class _SelectPageTileState extends State<SelectPageTile> {
  final GlobalKey imageGk = GlobalKey();
  final editingControler = Get.find<EditingController>();
  final UtilsServices utilsServices = UtilsServices();

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
        padding: const EdgeInsets.symmetric(vertical: 0.5),
        child: Column(
//crossAxisAlignment: CrossAxisAlignment.stretch,
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
              widget.page.page!.file,
              key: imageGk,
              // fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 5,
              child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red, // Muda a cor de fundo para vermelho
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      bool? result =
                          await ShowOrderConfirmation.showOrderConfirmation(
                              context,
                              'Esta certo de que quer deletar esta pagina?',
                              'sim',
                              'não');
                      if (result ?? false) {
                        await editingControler.deletePage(
                          pageId: widget.page.id,
                          chapter: widget.chapterId,
                        );
                      } else {
                        utilsServices.showToast(
                            message: 'Exclusão não concluída');
                      }
                    },
                    child: editingControler.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                            size: 20,
                          ),
                  )),
            ),
          ],
          // Titulo
        ),
      ),
    );
  }
}
