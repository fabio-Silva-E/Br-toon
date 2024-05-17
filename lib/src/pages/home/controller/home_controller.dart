import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/gallery_models.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/favorites/repository/favorites_repository.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/controller/product_pages_chapter_controller.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/controller/product_chapter_controller.dart';
import 'package:brasiltoon/src/pages/story_editing/repository/editing_repository.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/home/repository/home_repository.dart';
import 'package:brasiltoon/src/pages/home/result/home_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:path_provider/path_provider.dart';
//import 'dart:html' as html;
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

const int itemPerPage = 6;

class HomeController extends GetxController {
  final utilsServices = UtilsServices();
  final homeRepository = HomeRepository();
  final favoritesRepository = FavoritesRepository();
  // final favoritesController = Get.find<FavoritesController>();
  final authController = Get.find<AuthController>();
  final productChapterController = ProductChapterController();
  final productPagesChapterController = ProductPagesChapterController();
  final editingRepository = EditingRepository();
  // final FileDownloadService fileDownloadService = FileDownloadService(); // Serviço para downloads

  bool isCategoryLoading = false;
  bool isProductLoading = true;
  bool isChangingCategory = false;
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;

  GalleryModel? gallery;
  List<ItemModel> get allProducts => currentCategory?.items ?? [];
  RxString searchTitle = ''.obs;
  // List<ItemModel> Products = [];
  List<ChapterItemModel> allChapters = [];
  ItemModel? currentItem;
  bool get isLastPage {
    if (currentCategory!.items.length < itemPerPage) return true;
    return currentCategory!.pagination * itemPerPage > allProducts.length;
  }

  // Função específica para atualizar a tela
  /* void updateScreen() {
    update(); // Este método força a atualização da interface do usuário
  }*/

  void setLoading(
    bool value, {
    bool isProduct = false,
    /*bool changingCategory = false*/
  }) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }
    //isChangingCategory = changingCategory;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    debounce(
      searchTitle,
      (_) => filterByTitle(),
      time: const Duration(milliseconds: 600),
    );
    getAllCategory();
    getAllGallery();
  }

  void selectCategory(CategoryModel category) {
    // Marque como mudança de categoria
    currentCategory = category;
    update();
    if (currentCategory!.items.isNotEmpty) {
      // Marque como fim da mudança de categoria
      return;
    }
    getAllProducts();
  }

  Future<void> getAllGallery() async {
    setLoading(true);
    HomeResult<GalleryModel> homeResult = await homeRepository.getAllGallery();
    setLoading(false);
    homeResult.when(
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

  Future<void> getAllCategory() async {
    setLoading(true);
    HomeResult<CategoryModel> homeResult =
        await homeRepository.getAllCategories();
    setLoading(false);
    homeResult.when(
      success: (data) {
        allCategories.assignAll(data);
        if (allCategories.isEmpty) return;
        selectCategory(allCategories.first);
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

  void filterByTitle() {
    for (var category in allCategories) {
      category.items.clear();
      category.pagination = 0;
    }
    if (searchTitle.value.isEmpty) {
      allCategories.removeAt(0);
    } else {
      CategoryModel? c = allCategories.firstWhereOrNull((cat) => cat.id == '');

      if (c == null) {
        final allProductsCategory = CategoryModel(
          title: 'todos',
          id: '',
          items: [],
          pagination: 0,
        );
        allCategories.insert(0, allProductsCategory);
      } else {
        c.items.clear();
        c.pagination = 0;
      }
    }
    currentCategory = allCategories.first;
    update();
    getAllProducts();
  }

  void loadMoreProducts() {
    currentCategory!.pagination++;
    getAllProducts(canLoad: false);
  }

  Future<void> getAllProducts({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }
    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'itemsPerPage': itemPerPage,
      'categoryId': currentCategory!.id,
    };
    if (searchTitle.value.isNotEmpty) {
      body['title'] = searchTitle.value;
      if (currentCategory!.id == '') {
        body.remove('categoryId');
      }
    }
    HomeResult<ItemModel> result = await homeRepository.getAllProducts(body);
    setLoading(false, isProduct: true);
    result.when(
      success: (data) {
        currentCategory!.items.addAll(data);

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

  Future<void> addItem({
    required String category,
    required ItemModel item,
    // required String categoryId,
  }) async {
    // Obtenha a categoria correspondente ao ID

    getAllCategory();
    currentCategory =
        allCategories.firstWhereOrNull((cat) => cat.id == category);
    // Adiciona o novo item à lista de favoritos da categoria correspondente
    currentCategory!.items.add(item);

    getAllProducts();
    update();
  }

  Future<void> downloadAllChaptersAndPages({required ItemModel item}) async {
    var dio = Dio(); // Criar a instância de Dio

    print("Historia: $item");
    productChapterController.selectProduct(item);
    await productChapterController.getAllChapter(item.id);

    if (kIsWeb) {
      /*  try {
        var response = await dio.get(
          item.imgUrl!.file,
          options: Options(responseType: ResponseType.bytes),
        );
        final content = response.data as Uint8List;

        final blob = html.Blob([content]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "Capa ${item.itemName}.jpg")
          ..click();
        html.Url.revokeObjectUrl(url);
      } catch (e) {
        utilsServices.showToast(
          message: "Erro durante o download no navegador: $e",
          isError: true,
        );
        print("Erro durante o download no navegador: $e");
      }
      // Processo de download para Web
      for (var chapter in item.chapters) {
        try {
          var response = await dio.get(
            chapter.chaptersUrls!.file,
            options: Options(responseType: ResponseType.bytes),
          );
          final content = response.data as Uint8List;

          final blob = html.Blob([content]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute(
                "download", "Capa capitulo ${chapter.nameChapter}.jpg")
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
        }
      }*/
    } else {
      final downloadPath = await chooseDirectory();
      // final downloadPath = await getExternalStorageDirectories();
      if (downloadPath == null) {
        utilsServices.showToast(
            message: "Não foi possível acessar o diretório de download",
            isError: true);
        return;
      }
      // Processo de download para Mobile

      try {
        final coverPath = '$downloadPath/Capa ${item.itemName}.jpg';

        var response = await dio.download(item.imgUrl!.file, coverPath);
        if (response.statusCode == 200) {
          utilsServices.showToast(
            message: "Download concluído para $coverPath",
          );
        } else {
          utilsServices.showToast(
            message:
                "Falha no download para $coverPath com status ${response.statusCode}",
            isError: true,
          );
        }
      } catch (e) {
        utilsServices.showToast(
          message: "Erro durante o download em mobile: $e",
          isError: true,
        );
      }
      for (var chapter in item.chapters) {
        try {
          final filePath = '$downloadPath/Capítulo ${chapter.nameChapter}.jpg';

          var response =
              await dio.download(chapter.chaptersUrls!.file, filePath);
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
}


  // Seus outros métodos e variáveis ...

