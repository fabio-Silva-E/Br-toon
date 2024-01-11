import 'dart:io';

import 'package:brasiltoon/src/pages/story_editing/controller/editing_controller.dart';
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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late TextEditingController categoryController = TextEditingController();

  Widget getImageWidget() {
    if (imageFile != null) {
      if (kIsWeb) {
        return Image.network(imageFile!.path); // Se for web, usa Image.network
      } else {
        return Image.file(
            File(imageFile!.path)); // Para outras plataformas, usa Image.file
      }
    } else {
      return Image.network(widget.item.imgUrl,
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
    titleController.text = widget.item.itemName;
    descriptionController.text = widget.item.description;
  }

  @override
  Widget build(BuildContext context) {
    String caminho = widget.item.imgUrl;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Capa'),
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
                        : Image.network(widget.item.imgUrl, fit: BoxFit.cover),
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
              label: 'Descrição da história',
            ),
            buildCategoryDropdown(),
            const SizedBox(height: 20),
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
                            if (imageFile != null) {
                              await editingControler.modifyCover(
                                  caminho, File(imageFile!.path));
                            }
                            editingControler.editiCover(
                              title: titleController.text,
                              productId: widget.productId,
                              description: descriptionController.text,
                              category: categoryController.text,
                            );
                          },
                    child: editingControler.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Atualizar capa  '),
                  )),
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
