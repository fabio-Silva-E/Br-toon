import 'dart:io';

import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/pages/common_widgets/build_text_field.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
import 'package:brasiltoon/src/pages/story_editing/controller/editing_controller.dart';
import 'package:brasiltoon/src/pages/story_editing/edit_screen/select_chapter_to_editing_tab.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditingCapeTab extends StatefulWidget {
  final String productId;
  final String category;
  //final ItemModel publishersItem;
  const EditingCapeTab({
    Key? key,
    //  required this.publishersItem,
    required this.productId,
    required this.item,
    required this.category,
  }) : super(key: key);
  final ItemModel item;

  @override
  State<EditingCapeTab> createState() => _EditingCapeTabState();
}

class _EditingCapeTabState extends State<EditingCapeTab> {
  final TextEditingController idController = TextEditingController();
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
      return Image.network(widget.item.imgUrl!.file,
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
    idController.text = widget.item.id;
    // Inicializa o controlador do título com um valor específico
    titleController.text = widget.item.itemName;
    descriptionController.text = widget.item.description;
  }

  /* @override
void didUpdateWidget(covariant EditingCapeTab oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.item != widget.item) {
    // Aqui você pode atualizar as propriedades ou realizar outras operações
    // baseadas nas mudanças de widget.
  }
}*/

  @override
  Widget build(BuildContext context) {
    String caminho = widget.item.imgUrl!.id;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Editar Capa',
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
                        : Image.network(widget.item.imgUrl!.file,
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
              label: 'Descrição da história',
              icon: PhosphorIcons.pencil,
            ),
            buildCategoryDropdown(),
            const SizedBox(height: 20),
            //botão do carrinho

            SizedBox(
              height: 45,
              child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.customSwatchColor,
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
                                    'dejesa continuar esta ação!',
                                    'continuar',
                                    'não');
                            if (result ?? false) {
                              if (imageFile != null) {
                                /*  await editingControler.overwriteFileInGallery(
                                    objectId: caminho, newFile: imageFile!);
                              }*/
                                editingControler.editeCover(
                                  title: titleController.text,
                                  productId: widget.productId,
                                  description: descriptionController.text,
                                  category: categoryController.text,
                                  newImageFile: imageFile,
                                  Id: caminho,
                                );
                              }
                            } else {
                              utilsServices.showToast(
                                message: 'Atualização não concluida',
                              );
                            }
                          },
                    child: editingControler.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Atualizar capa',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                  )),
            ),
            const SizedBox(height: 20),
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
                  Get.to(() => SelectChapterToEditing(
                        productId: widget.item.id,
                        // item: widget.item,
                      ));
                  // print(widget.item.id);
                },
                child: const Text(
                  'Editar capitulos',
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

  Widget buildCategoryDropdown() {
    return GetBuilder<EditingController>(
      builder: (controller) {
        if (categoryController.text.isEmpty) {
          categoryController.text = widget.category;
        }
        // Obtém o ID da primeira categoria

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 40,
          ),
          decoration: const BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                ' gênero :',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: widget.category,
                items: controller.allCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id.toString(),
                    child: Text(category.title),
                  );
                }).toList(),
                onChanged: (value) {
                  String categoryId = value ?? widget.category;
                  controller.selectCategory(
                    controller.allCategories.firstWhere(
                      (category) => category.id.toString() == categoryId,
                    ),
                  );
                  categoryController.text = categoryId;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
