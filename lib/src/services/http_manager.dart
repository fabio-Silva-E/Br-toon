import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

abstract class HttpMethods {
  static const String post = 'POST';
  static const String get = 'GET';
  static const String put = 'PUT';
  static const String patch = 'PATCH';
  static const String delete = 'DELETE';
}

class HttpManager {
  final Logger logger = Logger();
  Future<Map> restRequest({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  }) async {
    final defautHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
        'X-Parse-Application-Id': // "H13T1aiOUr09EFLEcNTWgpUZsVhf2b0hsogOQZim",
            'yourAppId', //'H13T1aiOUr09EFLEcNTWgpUZsVhf2b0hsogOQZim',
        'X-Parse-REST-API-Key': // "IjfLzpM8Pm6ld49UvzOhzQkkQWKNNNbmo1aYPo9Y",
            'yourMasterKey' // 'IjfLzpM8Pm6ld49UvzOhzQkkQWKNNNbmo1aYPo9Y',
      });
    Dio dio = Dio();
    try {
      logger.d('Making request to $url with method $method');
      logger.d('Request headers: $defautHeaders');
      logger.d('Request body: $body');
      Response response = await dio.request(
        url,
        options: Options(
          headers: defautHeaders,
          method: method,
        ),
        data: body,
      );
      //Retorno do resultado do backend
      logger.d('Response status: ${response.statusCode}');
      logger.d('Response data: ${response.data}');
      return response.data;
    } on DioException catch (error) {
      //Retorno do erro do dio request
      return error.response?.data ?? {};
    } catch (error) {
      logger.e('General error: $error');
      //Retorno de map vasio para erro generalizado
      return {'error': 'An error occurred'};
    }
  }
}
