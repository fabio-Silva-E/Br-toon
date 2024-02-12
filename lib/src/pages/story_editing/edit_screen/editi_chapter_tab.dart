import 'dart:io';

import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
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
      return Image.network(widget.chapter.chaptersUrls,
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
    String caminho = widget.chapter.chaptersUrls;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Capitulo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTextField(
              controller: titleController,
              label: 'Título',
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
                        : Image.network(widget.chapter.chaptersUrls,
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
            buildTextField(
              controller: descriptionController,
              label: 'Descrição do capitulo',
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
                            bool? result = await showOrderConfirmation();
                            if (result ?? false) {
                              if (imageFile != null) {
                                await editingControler.editeImage(
                                    caminho, File(imageFile!.path));
                              }
                              editingControler.editeChapter(
                                title: titleController.text,
                                chapterId: widget.chapterId,
                                description: descriptionController.text,
                              );
                            } else {
                              utilsServices.showToast(
                                message: 'Atualizção não concluida',
                                isError: true,
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

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    // required PhosphorIcons icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 40,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: const Icon(
            PhosphorIcons.pencil,
            // outras propriedades do ícone, se necessário
          ),
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

  Future<bool?> showOrderConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Comfirmação'),
          content: const Text('Deseja realmente comfirmar a alteração'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('não'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('sim'),
            ),
          ],
        );
      },
    );
  }
}
