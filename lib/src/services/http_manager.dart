import 'package:dio/dio.dart';

abstract class HttpMethods {
  static const String post = 'POST';
  static const String get = 'GET';
  static const String put = 'PUT';
  static const String patch = 'PATCH';
  static const String delete = 'DELETE';
}

class HttpManager {
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
        'X-Parse-Application-Id': "H13T1aiOUr09EFLEcNTWgpUZsVhf2b0hsogOQZim",
        //  'yourAppId', //'H13T1aiOUr09EFLEcNTWgpUZsVhf2b0hsogOQZim',
        'X-Parse-REST-API-Key': "IjfLzpM8Pm6ld49UvzOhzQkkQWKNNNbmo1aYPo9Y",
        //     'yourMasterKey' // 'IjfLzpM8Pm6ld49UvzOhzQkkQWKNNNbmo1aYPo9Y',
      });
    Dio dio = Dio();
    try {
      Response response = await dio.request(
        url,
        options: Options(
          headers: defautHeaders,
          method: method,
        ),
        data: body,
      );
      //Retorno do resultado do backend
      return response.data;
    } on DioException catch (error) {
      //Retorno do erro do dio request
      return error.response?.data ?? {};
    } catch (error) {
      //Retorno de map vasio para erro generalizado
      return {};
    }
  }
}
