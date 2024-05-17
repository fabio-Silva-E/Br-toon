import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/repository/publish_chapter_repository.dart';
import 'package:brasiltoon/src/pages/publish_product/chapters_product/result/publish_chapter_result.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/view/publish_pages_product.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class PublishChapterController extends GetxController {
  final utilsServices = UtilsServices();
  final String productId;
  RxBool isloading = false.obs;
  final authController = Get.find<AuthController>();

  PublishChapterController({required this.productId});
  final chapterRepository = ChapterRepository();

  Future<void> publishChapter({
    required String title,
    required String cape,
    required String productId,
    required String description,
  }) async {
    isloading.value = true;
    final ChapterResult<String> result = await chapterRepository.publishChapter(
        token: authController.user.token!,
        userId: authController.user.id!,
        title: title,
        cape: cape,
        productId: productId,
        description: description);
    isloading.value = false;

    result.when(success: (chapterId) {
      print(chapterId);

      update();
      Get.to(() => PublishPageTab(chapterId: chapterId));
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });

    //  update();
  }

  Future<String> saveImageToParse(XFile image) async {
    isloading.value = true;
    ParseFileBase? parseFile;

    if (kIsWeb) {
      //Flutter Web
      parseFile = ParseWebFile(await image.readAsBytes(),
          name: 'image.jpg'); //Name for file is required
    } else {
      //Flutter Mobile/Desktop
      parseFile = ParseFile(File(image.path));
    }
    await parseFile.save();

    final gallery = ParseObject('GalleryChapter')..set('file', parseFile);
    await gallery.save();
    final savedId = gallery.objectId;

    // Obtenha o ID salvo

    //isloading.value = false;
    return savedId.toString();
  }
}
