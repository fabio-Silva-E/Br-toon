import 'dart:io';

import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brasiltoon/src/pages/story_editing/controller/editing_controller.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditingPageTab extends StatefulWidget {
  final String pageId;

  //final ItemModel publishersItem;
  const EditingPageTab({
    Key? key,
    //  required this.publishersItem,
    required this.pageId,
    required this.page,
  }) : super(key: key);
  final PagesChapterItemModel page;

  @override
  State<EditingPageTab> createState() => _EditingPageTabState();
}

class _EditingPageTabState extends State<EditingPageTab> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late TextEditingController categoryController = TextEditingController();
  final UtilsServices utilsServices = UtilsServices();
  Widget getImageWidget() {
    if (imageFile != null) {
      if (kIsWeb) {
        return Image.network(imageFile!.path); // Se for web, usa Image.network
      } else {
        return Image.file(
            File(imageFile!.path)); // Para outras plataformas, usa Image.file
      }
    } else {
      return Image.network(widget.page.page!.file,
          fit:
              BoxFit.cover); // Se não houver imagem, retorna widget.item.imgUrl
    }
  }

  final imagePicker = ImagePicker();
  XFile? imageFile;
  final editingControler = Get.find<EditingController>();
  @override
  @override
  Widget build(BuildContext context) {
    String caminho = widget.page.page!.id;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Editar pagina',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: imageFile != null
                            ? getImageWidget()
                            : Image.network(widget.page.page!.file,
                                fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      onPressed: () => uploadImage(),
                      icon: const Icon(
                        PhosphorIcons.pencil,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: SizedBox(
                    //  height: 45,
                    child: Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: editingControler.isLoading.value
                              ? null
                              : () async {
                                  bool? result = await ShowOrderConfirmation
                                      .showOrderConfirmation(
                                          context,
                                          'a pagina sera atualizada dejesa continuar esta ação?',
                                          'sim',
                                          'não');
                                  if (result ?? false) {
                                    if (imageFile != null) {
                                      await editingControler.editePage(
                                          pageId: widget.pageId,
                                          Id: caminho,
                                          newImageFile: imageFile!);
                                    }
                                  } else {
                                    utilsServices.showToast(
                                      message: 'Atualizção não concluida',
                                    );
                                  }
                                },
                          child: editingControler.isLoading.value
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Atualizar',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() => imageFile = file);
      }
    } catch (e) {}
  }
}
