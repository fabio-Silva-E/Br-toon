import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/models/chapter_models.dart';
import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/repository/product_chapter_repository.dart';
import 'package:brasiltoon/src/pages/screen/produt_chapter/result/product_chapter_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';

int itemsPerpage = 0;

class ProductChapterController extends GetxController {
  final utilsServices = UtilsServices();
  final authController = Get.find<AuthController>();

  final productChapterRepository = ProductChapterRepository();
  List<ChapterItemModel> get allChapters => currentProduct?.chapters ?? [];
  List<ItemModel> allProduct = [];
  late ItemModel? currentProduct;
  late ChapterItemModel currentChapter;
  bool isProductLoading = false;
  bool isChapterLoading = true;

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
  }

  /* void onChapterSelected(String chapterId, ItemModel item) {
    // Faça o que for necessário com o ID do capítulo e o item selecionado
    // por exemplo, navegar para ProductScreen e passar as informações necessárias
    Get.to(
        () => ProductScreen(
              chapterId: chapterId,
              item: item,
            ), binding: BindingsBuilder(() {
      Get.put<ProductPagesChapterController>(
        ProductPagesChapterController(chapterId: chapterId),
      );
    }));
    Get.find<ProductPagesChapterController>().getAllPages(chapterId);
  }
*/
/*  void selectChapter(ChapterItemModel chapter) {
    currentChapter = chapter;
    update();
  }*/

  void selectProduct(ItemModel product) {
    currentProduct = product;

    update();
    if (currentProduct!.chapters.isNotEmpty) return;
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
}
