import 'dart:io';

import 'package:brasiltoon/src/models/gallery_models.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/controller/product_pages_chapter_controller.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/repository/product_chapter_repository.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/result/product_chapter_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'dart:html' as html;

int itemsPerpage = 0;

class ProductChapterController extends GetxController {
  final utilsServices = UtilsServices();
  final authController = Get.find<AuthController>();
  final productChapterRepository = ProductChapterRepository();
  List<ChapterItemModel> get allChapters => currentProduct?.chapters ?? [];
  List<ChapterItemModel> get allChaptersOfEditor =>
      currentProductOfEditor?.chapters ?? [];
  List<ItemModel> allProduct = [];
  late ItemModel? currentProduct;
  late ItemModel? currentProductOfEditor;
  late ChapterItemModel currentChapter;
  bool isProductLoading = false;
  bool isChapterLoading = true;
  final productPagesChapterController = ProductPagesChapterController();

  bool get isLastChapter {
    if (currentProduct!.chapters.length < itemsPerpage) return true;
    return currentProduct!.pagination * itemsPerpage > allChapters.length;
  }

  Future<String?> chooseDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      // O usuário cancelou a operação de seleção de diretório
      print('Seleção de diretório cancelada');
      return null;
    } else {
      print('Diretório selecionado: $selectedDirectory');
      return selectedDirectory;
    }
  }

  Future<String?> getDownloadDirectory() async {
    if (await requestPermissions()) {
      if (Platform.isAndroid) {
        // Pega o diretório externo para Android
        Directory? externalDir = await getExternalStorageDirectory();

        // Verifica se obteve o diretório externo
        if (externalDir != null) {
          // Caminho para a pasta de download

          // Retorna o caminho completo da pasta de download
          return '${externalDir.path}/Download';
        }
      } else if (Platform.isIOS) {
        // Para iOS, geralmente usamos o diretório de documentos do aplicativo
        return (await getApplicationDocumentsDirectory()).path;
      }
    }

    return null; // Se a permissão não foi concedida ou o diretório não pôde ser obtido
  }

  Future<bool> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> deleteChapter(
      {required String chapterId, required String productId}) async {
    getAllChapterOfEditor(productId);
    allChaptersOfEditor.removeWhere((chapter) => chapter.id == chapterId);

    update(); // Isso atualizará todos os ouvintes
  }

  void setLoading(bool value, {bool isChapter = false}) {
    if (!isChapter) {
      isProductLoading = value;
    } else {
      isChapterLoading = value;
    }

    update();
  }

  @override
  void onInit() {
    super.onInit();
    getAllProductId();
    getAllGallery();
  }

  Future<void> getAllGallery() async {
    setLoading(true);
    ProductChapterResult<GalleryModel> productChapterResult =
        await productChapterRepository.getAllGalleryChapter();
    setLoading(false);
    productChapterResult.when(
      success: (data) {
        data;
        print(data);
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
    setLoading(false);
  }

  void selectProduct(ItemModel product) {
    currentProduct = product;

    update();
    if (currentProduct!.chapters.isNotEmpty) return;
    getAllChapter(product.id);
  }

  void selectProductOfEditor(ItemModel product) {
    currentProductOfEditor = product;

    update();
    if (currentProductOfEditor!.chapters.isNotEmpty) return;
    getAllChapter(product.id);
  }

  Future<void> getAllProductId() async {
    setLoading(true);
    ProductChapterResult<ItemModel> productChapterResult =
        await productChapterRepository.getAllProductId();
    setLoading(false);
    productChapterResult.when(
      success: (data) {
        allProduct.assignAll(data);
        // print(allProduct);
        if (allProduct.isEmpty) return;
        selectProduct(allProduct.first);
        selectProductOfEditor(allProduct.first);
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

  Future<void> getAllChapter(String productId) async {
    int chapterCount = await getChapterPages(productId);
    itemsPerpage = chapterCount;
    setLoading(true, isChapter: true);
    Map<String, dynamic> body = {
      'page': currentProduct!.pagination,
      'itemsPerPage': itemsPerpage,
      'productId': productId, //currentProduct!.id,
    };
    ProductChapterResult<ChapterItemModel> productChapterResult =
        await productChapterRepository.getAllChapter(body);
    setLoading(false, isChapter: true);
    productChapterResult.when(
      success: (data) {
        // print(data);
        currentProduct!.chapters = data;
        /*  allChapters.assignAll(data);
        if (allChapters.isEmpty) return;
        selectChapter(allChapters.first);*/
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> getAllChapterOfEditor(String productId) async {
    //int chapterCount = await getChapterPages(productId);
    // itemsPerpage = chapterCount;
    setLoading(true, isChapter: true);
    Map<String, dynamic> body = {
      'page': currentProductOfEditor!.pagination,
      'itemsPerPage': null,
      'productId': productId, //currentProduct!.id,
    };
    ProductChapterResult<ChapterItemModel> productChapterResult =
        await productChapterRepository.getAllChapter(body);
    setLoading(false, isChapter: true);
    productChapterResult.when(
      success: (data) {
        // print(data);
        currentProductOfEditor!.chapters = data;
        update();
        /*  allChapters.assignAll(data);
        if (allChapters.isEmpty) return;
        selectChapter(allChapters.first);*/
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<int> getChapterPages(String productId) async {
    setLoading(true, isChapter: true);

    int result = await productChapterRepository.chapterCount(
      user: authController.user.id!,
      token: authController.user.token!,
      productId: productId,
    );

    setLoading(false, isChapter: true);

    int chapterCount = 0; // Valor padrão

    // Atribua diretamente o valor retornado do método pagesCount à pageCount
    chapterCount = result;

    // Não é necessário usar productPagesChapterResult.when para um tipo int
    // print(chapterCount);
    return chapterCount; // Retorne 'pageCount' após o tratamento do resultado
  }

  Future<void> downloadAllPagesOfChapter(
      {required ChapterItemModel chapter}) async {
    var dio = Dio(); // Criar a instância de Dio

    if (kIsWeb) {
      /* try {
        var response = await dio.get(
          chapter.chaptersUrls!.file,
          options: Options(responseType: ResponseType.bytes),
        );
        final content = response.data as Uint8List;

        final blob = html.Blob([content]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "Capitulo ${chapter.nameChapter}.jpg")
          ..click();
        html.Url.revokeObjectUrl(url);
      } catch (e) {
        utilsServices.showToast(
          message: "Erro durante o download no navegador: $e",
          isError: true,
        );
        print("Erro durante o download no navegador: $e");
      }
      productPagesChapterController.selectChapter(chapter);
      await productPagesChapterController.getAllPages(chapter.id);
      int index = 0;
      for (var page in chapter.items) {
        index++;
        try {
          var response = await dio.get(
            page.page!.file,
            options: Options(responseType: ResponseType.bytes),
          );
          final content = response.data as Uint8List;

          final blob = html.Blob([content]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute("download",
                "Capítulo ${chapter.nameChapter} - Página $index.jpg")
            ..click();
          html.Url.revokeObjectUrl(url);
        } catch (e) {
          utilsServices.showToast(
            message: "Erro durante o download no navegador: $e",
            isError: true,
          );
          print("Erro durante o download no navegador: $e");
        }
      }*/
    } else {
      // Processo de download para Mobile
      final downloadPath = await chooseDirectory();
      // final downloadPath = await getExternalStorageDirectories();
      if (downloadPath == null) {
        utilsServices.showToast(
            message: "Não foi possível acessar o diretório de download",
            isError: true);
        return;
      }

      try {
        final filePath = '$downloadPath/Capitulo ${chapter.nameChapter}.jpg';

        var response = await dio.download(chapter.chaptersUrls!.file, filePath);
        if (response.statusCode == 200) {
          utilsServices.showToast(
            message: "Download concluído para $filePath",
          );
        } else {
          utilsServices.showToast(
            message:
                "Falha no download para $filePath com status ${response.statusCode}",
            isError: true,
          );
        }
      } catch (e) {
        utilsServices.showToast(
          message: "Erro durante o download em mobile: $e",
          isError: true,
        );
      }
      productPagesChapterController.selectChapter(chapter);
      await productPagesChapterController.getAllPages(chapter.id);
      int index = 1;
      for (var page in chapter.items) {
        try {
          final filePath =
              '$downloadPath/Capítulo ${chapter.nameChapter} - Página $index.jpg';
          index++;
          var response = await dio.download(page.page!.file, filePath);
          if (response.statusCode == 200) {
            utilsServices.showToast(
              message: "Download concluído para $filePath",
            );
          } else {
            utilsServices.showToast(
              message:
                  "Falha no download para $filePath com status ${response.statusCode}",
              isError: true,
            );
          }
        } catch (e) {
          utilsServices.showToast(
            message: "Erro durante o download em mobile: $e",
            isError: true,
          );
        }
      }
    }
  }
}
