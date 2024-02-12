import 'package:get/get.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/pages_chapters_models.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/repository/product_pages_chapter_repository.dart';
import 'package:brasiltoon/src/pages/screen/Product_pages/result/product_pages_chapter_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';

const int itemsPerpage = 6;

class ProductPagesChapterController extends GetxController {
  final utilsServices = UtilsServices();
  final String chapterId;
  ProductPagesChapterController({required this.chapterId});
  final productPagesChapterRepository = ProductPagesChapterRepository();
  List<PagesChapterItemModel> get allPages => currentChapter?.items ?? [];
  List<ChapterItemModel> allChapter = [];
  late ChapterItemModel? currentChapter;
  late PagesChapterItemModel currentPage;
  bool isChapterLoading = false;
  bool isPageLoading = true;

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
    // selectChapter();
  }

  void selectChapter(ChapterItemModel chapter) {
    currentChapter = chapter;
    update();
    if (currentChapter!.items.isNotEmpty) return;
    getAllPages(chapter.id);
  }

  Future<void> getAllChapterId() async {
    setLoading(true);
    ProductPagesChapterResult<ChapterItemModel> productPagesChapterResult =
        await productPagesChapterRepository.getAllChapterId();
    setLoading(false);
    productPagesChapterResult.when(
      success: (data) {
        allChapter.assignAll(data);
        print('capitulos $allChapter');
        if (allChapter.isEmpty) return;
        selectChapter(allChapter.first);
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

  Future<void> getAllPages(String chapterId) async {
    print('Updating pages for chapter ID: $chapterId');
    setLoading(true, isPage: true);
    Map<String, dynamic> body = {
      'page': currentChapter!.pagination,
      'itemsPerPage': itemsPerpage,
      'chapterId': chapterId, // currentChapter!.id,
    };
    ProductPagesChapterResult<PagesChapterItemModel> productPagesChapterResult =
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
  /* Future<void> getAllPages(String chapterId) async {
    setLoading(true, isPage: true);
    Map<String, dynamic> body = {
      'page': currentChapter!.pagination,
      'itemsPerPage': itemsPerpage,
      'chapterId': chapterId,
    };
    ProductPagesChapterResult<PagesChapterItemModel> productPagesChapterResult =
        await productPagesChapterRepository.getAllPages(body);
    setLoading(false, isPage: true);
    productPagesChapterResult.when(
      success: (data) {
        print('Received pages for chapter $chapterId: $data');
        currentChapter!.items = data;
        update(); // Certifique-se de chamar o método update() para notificar as mudanças aos observadores.
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }*/
}
