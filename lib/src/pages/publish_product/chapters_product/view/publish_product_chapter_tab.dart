import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/controller/publish_chapter_controller.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:image_picker/image_picker.dart';

class PublishChapterTab extends StatefulWidget {
  final String productId;
  const PublishChapterTab({
    super.key,
    required this.productId,
  });

  @override
  State<PublishChapterTab> createState() => _PublishChapterTabState();
}

class _PublishChapterTabState extends State<PublishChapterTab> {
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

  final UtilsServices utilsServices = UtilsServices();
  XFile? capa;
  final chapterController = Get.find<PublishChapterController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController capeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capitulo'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildTextField(
                controller: titleController,
                label: 'Título ',
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
              const SizedBox(height: 20),
              SizedBox(
                  child: Obx(
                () => ElevatedButton(
                  onPressed: chapterController.isloading.value
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          // Verificar se todos os campos obrigatórios estão preenchidos
                          if (capa != null &&
                              titleController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty) {
                            // Realizar o upload da capa e publicar
                            String imagePath = await chapterController
                                .saveImageToAppDirectory(File(capa!.path));

                            chapterController.publishChapter(
                              title: titleController.text,
                              cape: imagePath,
                              description: descriptionController.text,
                              productId: widget.productId,
                            );
                          } else {
                            print(
                                'Preencha todos os campos antes de publicar.');
                            // Mostrar mensagem de erro se algum campo estiver vazio
                            utilsServices.showToast(
                              message:
                                  'Preencha todos os campos antes de publicar.',
                              isError: true,
                            );
                          }
                        },
                  child: chapterController.isloading.value
                      ? const CircularProgressIndicator()
                      : const Text('Publicar'),
                ),
              )),
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
