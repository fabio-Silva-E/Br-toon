import 'dart:io';

import 'package:brasiltoon/src/pages/base/controller/navigation_controller.dart';
import 'package:brasiltoon/src/pages/splash/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/controller/pages_product_controller.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:image_picker/image_picker.dart';

class PublishPageTab extends StatefulWidget {
  final String chapterId;
  const PublishPageTab({
    super.key,
    required this.chapterId,
  });

  @override
  State<PublishPageTab> createState() => _PublishPageTabState();
}

class _PublishPageTabState extends State<PublishPageTab> {
  Widget getImageWidget() {
    if (pagina != null) {
      if (kIsWeb) {
        return Image.network(pagina!.path); // Se for web, usa Image.network
      } else {
        return Image.file(
            File(pagina!.path)); // Para outras plataformas, usa Image.file
      }
    } else {
      return const SizedBox
          .shrink(); // Se não houver imagem, retorna um Widget vazio
    }
  }

  int pageCount = 1;
  final UtilsServices utilsServices = UtilsServices();
  final navigationController = Get.find<NavigationController>();
  XFile? pagina;
  final pageController = Get.find<PublishPageController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Custom AppBar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: const Text(
                  'Pagina',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text(' pagina'),
                onTap: () => uploadImage(),
                trailing: getImageWidget(),
              ),
              ElevatedButton(
                onPressed: pageController.isloading.value
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        // Verificar se todos os campos obrigatórios estão preenchidos
                        if (pagina != null) {
                          // Realizar o upload da capa e publicar
                          String imagePath = await pageController
                              .saveImageToAppDirectory(File(pagina!.path));
                          setState(() {
                            pageCount++;
                          });
                          pageController.publishPages(
                            page: imagePath,
                            chapterId: widget.chapterId,
                          );
                        } else {
                          print('Preencha todos os campos antes de publicar.');
                          // Mostrar mensagem de erro se algum campo estiver vazio
                          utilsServices.showToast(
                            message:
                                'Preencha todos os campos antes de publicar.',
                            isError: true,
                          );
                        }
                      },
                child: pageController.isloading.value
                    ? const CircularProgressIndicator()
                    : Text('Publicar página $pageCount'),
              ),
              TextButton(
                onPressed: () {
                  // Navegar de volta para PublishersTab
                  Get.to(() => const SplashScreen());
                },
                child: const Text('Finalizar publicação'),
              ),
            ],
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
        setState(() => pagina = file);
      }
    } catch (e) {
      print(e);
    }
  }
}
