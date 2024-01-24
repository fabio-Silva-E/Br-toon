import 'package:brasiltoon/src/models/coin_models.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/coin/repository/coin_repository.dart';
import 'package:brasiltoon/src/pages/coin/result/coin_result.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:get/get.dart';

const int itemPerPage = 6;

class CoinController extends GetxController {
  final cointRepository = CoinRepository();
  final authController = Get.find<AuthController>();
  final utilsServices = UtilsServices();
  List<CoinModel> coins = [];
  // RxBool isloading = false.obs;
  void setLoading(bool value) {}
  @override
  void onInit() {
    super.onInit();
    getAllCoins();
  }

  /*Future<void> getAllCoins() async {
    
      setLoading(true);
    
    Map<String, dynamic> body = {
     
      'itemsPerPage': itemPerPage,
      
    };
   
    }
    CoinResult<CoinModel> result = await cointRepository.getAllCoins(body);
    setLoading(false);
    result.when(
      success: (data) {
        currentCategory!.items.addAll(data);
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }*/
  Future<void> getAllCoins() async {
    setLoading(true); //se houver erro no loading trocar por RxBool
    Map<String, dynamic> body = {'itemsPerPage': itemPerPage};
    CoinResult<CoinModel> result = await cointRepository.getAllCoins(body);
    setLoading(false);
    result.when(
      success: (data) {
        print(data);
        coins = data;
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
}
