import 'dart:io';

import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/pages/common_widgets/build_text_field.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brasiltoon/src/pages/story_editing/controller/editing_controller.dart';
import 'package:brasiltoon/src/pages/story_editing/edit_screen/select_page_to_editi.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditingChapterTab extends StatefulWidget {
  final String chapterId;

  //final ItemModel publishersItem;
  const EditingChapterTab({
    Key? key,
    //  required this.publishersItem,
    required this.chapterId,
    required this.chapter,
  }) : super(key: key);
  final ChapterItemModel chapter;

  @override
  State<EditingChapterTab> createState() => _EditingChapterTabState();
}

class _EditingChapterTabState extends State<EditingChapterTab> {
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
      return Image.network(widget.chapter.chaptersUrls!.file,
          fit:
              BoxFit.cover); // Se não houver imagem, retorna widget.item.imgUrl
    }
  }

  final imagePicker = ImagePicker();
  XFile? imageFile;
  final editingControler = Get.find<EditingController>();
  @override
  void initState() {
    super.initState();
    // Inicializa o controlador do título com um valor específico
    titleController.text = widget.chapter.nameChapter;
    descriptionController.text = widget.chapter.description;
  }

  @override
  Widget build(BuildContext context) {
    String caminho = widget.chapter.chaptersUrls!.id;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Editar Capitulo',
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
            const SizedBox(height: 20),
            BuildTextField(
              controller: titleController,
              label: 'Título',
              icon: PhosphorIcons.pencil,
            ),
            Stack(
              children: [
                ClipRRect(
                  child: Container(
                    height: 200, // Ajuste conforme necessário
                    width: 150, // Ajuste conforme necessário
                    color: const Color.fromARGB(99, 71, 67, 67),
                    child: imageFile != null
                        ? getImageWidget()
                        : Image.network(widget.chapter.chaptersUrls!.file,
                            fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      onPressed: () => uploadImage(),
                      icon: Icon(
                        PhosphorIcons.pencil,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            BuildTextField(
              controller: descriptionController,
              label: 'Descrição do capitulo',
              icon: PhosphorIcons.pencil,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 45,
              child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: editingControler.isLoading.value
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            bool? result = await ShowOrderConfirmation
                                .showOrderConfirmation(
                                    context,
                                    'A capa deste capitulo sera atualizada dejesa continuar esta ação',
                                    'sim',
                                    'não');
                            if (result ?? false) {
                              if (imageFile != null) {
                                editingControler.editeChapter(
                                  title: titleController.text,
                                  chapterId: widget.chapterId,
                                  description: descriptionController.text,
                                  newImageFile: imageFile,
                                  Id: caminho,
                                );
                              }
                            } else {
                              utilsServices.showToast(
                                message: 'Atualizção não concluida',
                              );
                            }
                          },
                    child: editingControler.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Atualizar'),
                  )),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 45,

              //crossAxisAlignment: CrossAxisAlignment.stretch,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.customSwatchColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  Get.to(() => SelectPageToEditing(
                        chapterId: widget.chapterId,
                      ));
                  // print(widget.item.id);
                },
                child: const Text(
                  'Editar paginas',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
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
    } catch (e) {
      print(e);
    }
  }
}
