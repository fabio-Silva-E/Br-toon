import 'dart:io';

import 'package:brasiltoon/src/pages/base/controller/navigation_controller.dart';
import 'package:brasiltoon/src/pages/common_widgets/showOrderConfirmation_widgest.dart';
//import 'package:brasiltoon/src/pages/screen/Product_pages/controller/product_pages_chapter_controller.dart';
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

  final UtilsServices utilsServices = UtilsServices();
  final navigationController = Get.find<NavigationController>();
  XFile? pagina;
  final pageController = Get.find<PublishPageController>();
  //final pages = Get.find<ProductPagesChapterController>();
  @override
  void initState() {
    super.initState();
    pageCount = pageController.allPagesOfEditor.length;
  }

  int pageCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                  'Publicar paginas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text(
                  ' pagina',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onTap: () => uploadImage(),
                trailing: getImageWidget(),
              ),
              SizedBox(
                height: 45,
                child: Obx(() => ElevatedButton(
                      onPressed: pageController.isloading.value
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              bool? result = await ShowOrderConfirmation
                                  .showOrderConfirmation(
                                      context,
                                      'Esta certo que quer publicar esta pagina?',
                                      'sim',
                                      'não');
                              if (result ?? false) {
                                // Verificar se todos os campos obrigatórios estão preenchidos
                                if (pagina != null) {
                                  // Realizar o upload da capa e publicar
                                  String imagePath = await pageController
                                      .saveImageToParse(pagina!);
                                  setState(() {
                                    pageCount++;
                                  });
                                  pageController.publishPages(
                                    page: imagePath,
                                    chapterId: widget.chapterId,
                                  );
                                } else {
                                  // Mostrar mensagem de erro se algum campo estiver vazio
                                  utilsServices.showToast(
                                    message:
                                        'Preencha todos os campos antes de publicar.',
                                    isError: true,
                                  );
                                }
                              } else {
                                utilsServices.showToast(
                                  message: 'Atualização não concluida',
                                );
                              }
                            },
                      child: pageController.isloading.value
                          ? const CircularProgressIndicator()
                          : const Text('Publicar pagina'),
                    )),
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
