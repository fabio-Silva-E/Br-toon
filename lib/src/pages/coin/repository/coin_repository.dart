import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/coin_models.dart';
import 'package:brasiltoon/src/pages/coin/result/coin_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';

class CoinRepository {
  final _httpManager = HttpManager();

  Future<CoinResult<CoinModel>> getAllCoins(Map<String, dynamic> body) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllCoins,
      method: HttpMethods.post,
      body: body,
    );
    if (result['result'] != null) {
      List<CoinModel> data = List<Map<String, dynamic>>.from(result['result'])
          .map(CoinModel.fromJson)
          .toList();
      return CoinResult<CoinModel>.success(data);
    } else {
      return CoinResult.error(
          'ocorreu um erro inesperado ao recuperar a lista');
    }
  }
}
