import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/repository/product_pages_chapter_repository.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/result/product_pages_chapter_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';

int itemsPerpage = 0;

class ProductPagesChapterController extends GetxController {
  final utilsServices = UtilsServices();
  final authController = Get.find<AuthController>();
  final String chapterId;

  ProductPagesChapterController({required this.chapterId});
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
}
