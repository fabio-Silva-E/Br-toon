import 'dart:io';

import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/repository/pages_product_repository.dart';
import 'package:brasiltoon/src/pages/publish_product/pages_product/result/pages_product_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class PublishPageController extends GetxController {
  final utilsServices = UtilsServices();
  final String chapterId;
  RxBool isloading = false.obs;
  List<PagesChapterItemModel> get allPagesOfEditor =>
      currentChapterOfEditor?.items ?? [];
  final authController = Get.find<AuthController>();
  ChapterItemModel? currentChapterOfEditor;
  List<ChapterItemModel> allChapter = [];
  PublishPageController({required this.chapterId});
  final pageRepository = PageRepository();
  @override
  void onInit() {
    super.onInit();
    getAllChapterId();
  }

  Future<void> getAllPages(String chapterId) async {
    isloading(true);
    Map<String, dynamic> body = {
      'page': currentChapterOfEditor!.pagination,

      'chapterId': chapterId, // currentChapter!.id,
    };
    PageResult<List<PagesChapterItemModel>> productPagesChapterResult =
        await pageRepository.getAllPages(body);
    isloading(false);
    productPagesChapterResult.when(
      success: (data) {
        //  print(data);
        currentChapterOfEditor!.items = data;
        update();
        //  print('Success! capitulo ID: $chapterId');
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  void selectChapterOfTditor(ChapterItemModel chapter) {
    currentChapterOfEditor = chapter;
    update();
    if (currentChapterOfEditor!.items.isNotEmpty) return;
    getAllPages(chapter.id);
  }

  Future<void> getAllChapterId() async {
    isloading(true);
    PageResult<List<ChapterItemModel>> productPagesChapterResult =
        await pageRepository.getAllChapterId();
    isloading(false);
    productPagesChapterResult.when(
      success: (data) {
        allChapter.assignAll(data);

        if (allChapter.isEmpty) return;

        selectChapterOfTditor(allChapter.first);
        update();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> publishPages({
    required String page,
    required String chapterId,
  }) async {
    isloading.value = true;
    final PageResult<String> result = await pageRepository.publishPages(
      token: authController.user.token!,
      userId: authController.user.id!,
      page: page,
      chapterId: chapterId,
    );
    isloading.value = false;
    print('chapter ID: $chapterId');
    result.when(success: (pageId) {
      pageId;

      update();
      print('Success! page ID: $pageId');
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

    final gallery = ParseObject('GalleryPage')..set('file', parseFile);
    await gallery.save();
    final savedId = gallery.objectId;

    // Obtenha o ID salvo

    //isloading.value = false;
    return savedId.toString();
  }
}
