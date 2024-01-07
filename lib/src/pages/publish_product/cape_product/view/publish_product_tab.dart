import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/publish_product/cape_product/controller/cape_product_controller.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:image_picker/image_picker.dart';

class PublishProductTab extends StatefulWidget {
  const PublishProductTab({Key? key}) : super(key: key);
  @override
  State<PublishProductTab> createState() => _PublishProductTabState();
}

class _PublishProductTabState extends State<PublishProductTab> {
  Widget getImageWidget() {
    if (capa != null) {
      if (kIsWeb) {
        return Image.network(capa!.path); // Se for web, usa Image.network
      } else {
        return Image.file(
            File(capa!.path)); // Para outras plataformas, usa Image.file
      }
    } else {
      return const SizedBox
          .shrink(); // Se não houver imagem, retorna um Widget vazio
    }
  }

  final UtilsServices ultilsServices = UtilsServices();
  XFile? capa;
  final capeProductController = Get.find<CapeProductController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController capeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late TextEditingController categoryController = TextEditingController();
  String? productId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capa'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildTextField(
                controller: titleController,
                label: 'Título',
              ),
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text(' capa'),
                onTap: () => uploadImage(),
                trailing: getImageWidget(),
              ),
              buildTextField(
                controller: descriptionController,
                label: 'Descrição da história',
              ),
              buildCategoryDropdown(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: capeProductController.isloading.value
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        // Verificar se todos os campos obrigatórios estão preenchidos
                        if (capa != null &&
                            titleController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty &&
                            categoryController.text.isNotEmpty) {
                          // Realizar o upload da capa e publicar
                          String imagePath = await capeProductController
                              .saveImageToAppDirectory(File(capa!.path));

                          capeProductController.publishCape(
                            title: titleController.text,
                            cape: imagePath,
                            description: descriptionController.text,
                            category: categoryController.text,
                          );
                        } else {
                          // Mostrar mensagem de erro se algum campo estiver vazio
                          ultilsServices.showToast(
                            message:
                                'Preencha todos os campos antes de publicar.',
                            isError: true,
                          );
                        }
                      },
                child: capeProductController.isloading.value
                    ? const CircularProgressIndicator()
                    : const Text('Publicar Capa'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
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
        ),
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return GetBuilder<CapeProductController>(
      builder: (controller) {
        if (categoryController.text.isEmpty) {
          categoryController.text = controller.allCategories.first.id;
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
                'Escolha o gênero da sua historia:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: controller.selectedCategoryId.toString(),
                items: controller.allCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id.toString(),
                    child: Text(category.title),
                  );
                }).toList(),
                onChanged: (value) {
                  String categoryId = value ?? '';
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

  uploadImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() => capa = file);
      }
    } catch (e) {
      print(e);
    }
  }
}
