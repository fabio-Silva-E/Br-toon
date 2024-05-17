import 'dart:io';

import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/repository/product_pages_chapter_repository.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/result/product_pages_chapter_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'dart:html' as html;

int itemsPerpage = 0;

class ProductPagesChapterController extends GetxController {
  final utilsServices = UtilsServices();
  final authController = Get.find<AuthController>();
  //final String chapterId;
  // ProductPagesChapterController({required this.chapterId});
  final productPagesChapterRepository = ProductPagesChapterRepository();
  List<PagesChapterItemModel> get allPages => currentChapter?.items ?? [];
  List<PagesChapterItemModel> get allPagesOfEditor =>
      currentChapterOfEditor?.items ?? [];
  List<ChapterItemModel> allChapter = [];
  late ChapterItemModel? currentChapter;
  late ChapterItemModel? currentChapterOfEditor;
  late PagesChapterItemModel currentPage;
  bool isChapterLoading = false;
  bool isPageLoading = true;
  bool get isLastPage {
    if (currentChapter!.items.length < itemsPerpage) return true;
    return currentChapter!.pagination * itemsPerpage > allPages.length;
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

  Future<void> deletePage(
      {required String pageId, required String chapterId}) async {
    // Lógica para excluir a página
    allPagesOfEditor.removeWhere((page) => page.id == pageId);
    getAllPagesToEditor(chapterId);
    update(); // Isso atualizará todos os ouvintes
  }

  void setLoading(bool value, {bool isPage = false}) {
    if (!isPage) {
      isChapterLoading = value;
    } else {
      isPageLoading = value;
    }

    update();
  }

  @override
  void onInit() {
    super.onInit();
    getAllChapterId();
  }

  void selectChapter(ChapterItemModel chapter) {
    currentChapter = chapter;
    update();
    if (currentChapter!.items.isNotEmpty) return;
    getAllPages(chapter.id);
  }

  void selectChapterOfTditor(ChapterItemModel chapter) {
    currentChapterOfEditor = chapter;
    update();
    if (currentChapterOfEditor!.items.isNotEmpty) return;
    getAllPages(chapter.id);
  }

  Future<void> getAllChapterId() async {
    setLoading(true);
    ProductPagesChapterResult<List<ChapterItemModel>>
        productPagesChapterResult =
        await productPagesChapterRepository.getAllChapterId();
    setLoading(false);
    productPagesChapterResult.when(
      success: (data) {
        allChapter.assignAll(data);

        if (allChapter.isEmpty) return;
        selectChapter(allChapter.first);
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

  void loadMoreProducts() async {
    currentChapter!.pagination++;

    await getAllPages(
        currentChapter!.id); // Aguarda até que getAllPages seja concluído
  }

  Future<void> getAllPages(String chapterId) async {
    int pageCount = await getCountPages(chapterId);
    itemsPerpage = pageCount;
    setLoading(true, isPage: true);
    Map<String, dynamic> body = {
      'page': currentChapter!.pagination,
      'itemsPerPage': itemsPerpage,
      'chapterId': chapterId, // currentChapter!.id,
    };
    ProductPagesChapterResult<List<PagesChapterItemModel>>
        productPagesChapterResult =
        await productPagesChapterRepository.getAllPages(body);
    setLoading(false, isPage: true);
    productPagesChapterResult.when(
      success: (data) {
        //  print(data);
        currentChapter!.items = data;
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

  Future<void> getAllPagesToEditor(String chapterId) async {
    setLoading(true, isPage: true);
    Map<String, dynamic> body = {
      'page': currentChapterOfEditor!.pagination,
      'itemsPerPage': null,
      'chapterId': chapterId, // currentChapter!.id,
    };
    ProductPagesChapterResult<List<PagesChapterItemModel>>
        productPagesChapterResult =
        await productPagesChapterRepository.getAllPages(body);
    setLoading(false, isPage: true);
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

  Future<int> getCountPages(String chapterId) async {
    setLoading(true, isPage: true);

    final result = await productPagesChapterRepository.pagesCount(
      user: authController.user.id!,
      token: authController.user.token!,
      chapterId: chapterId,
    );

    setLoading(false, isPage: true);

    // Acesse itemCount e message da resposta e faça o tratamento necessário
    final int itemCount = result['itemCount'] as int;
//    final String message = result['message'] as String;

    //  print(itemCount); // Apenas para verificar se o itemCount está correto
    print(itemCount);
    return itemCount; // Retorna itemCount
  }

  Future<void> addCountPages(String chapterId) async {
    setLoading(true, isPage: true);

    final result = await productPagesChapterRepository.addPagesCount(
      user: authController.user.id!,
      token: authController.user.token!,
      chapterId: chapterId,
    );

    setLoading(false, isPage: true);

    result.when(
      success: (message) {
        utilsServices.showToast(
          message: message,
        );
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<String> messageGetCountPages(String chapterId) async {
    setLoading(true, isPage: true);

    final result = await productPagesChapterRepository.pagesCount(
      user: authController.user.id!,
      token: authController.user.token!,
      chapterId: chapterId,
    );

    setLoading(false, isPage: true);

    //final int itemCount = result['itemCount'] as int;
    final String message = result['message'] as String;
    print(message);
    /*if (message == 'PAGES_TO_ADD_FOUND') {
      return true;
    } else {*/
    return message;
    // }
  }

  Future<void> downloadFile(
      {required String fileUrl, required String name}) async {
    if (kIsWeb) {
      /*  // Processo de download para Web
      try {
        var dio = Dio();
        var response = await dio.get(fileUrl,
            options: Options(responseType: ResponseType.bytes));
        final content = response.data as Uint8List;

        // Criar um elemento <a> para iniciar o download
        final blob = html.Blob([content]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "$name.jpg")
          ..click();
        html.Url.revokeObjectUrl(url);
      } catch (e) {
        print("Erro durante o download no navegador: $e");
      }*/
    } else {
      // Processo de download para Mobile

      var dio = Dio();
      final downloadPath = await chooseDirectory();
      // final downloadPath = await getExternalStorageDirectories();
      if (downloadPath == null) {
        utilsServices.showToast(
            message: "Não foi possível acessar o diretório de download",
            isError: true);
        return;
      }
      try {
        final filePath = '$downloadPath/$name';

        var response = await dio.download(fileUrl, filePath);
        if (response.statusCode == 200) {
          utilsServices.showToast(
            message: "Download concluido para $filePath",
          );
        } else {
          utilsServices.showToast(
            message: "Falha no download ${response.statusCode}",
            isError: true,
          );
        }
      } catch (e) {
        utilsServices.showToast(
          message: "Erro durante o download em mobile $e",
          isError: true,
        );
      }
    }
  }
}
