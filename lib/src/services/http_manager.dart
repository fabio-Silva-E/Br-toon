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
    //headers da requisição
    final defautHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
        'X-Parse-Application-Id': '7SgciAjPemPXufDdr8OCBxVXgLqVO0gdRGm8Wlg2',
        'X-Parse-REST-API-Key': '7vkH9vlU2cepO5WMAvJEF6cqE02fWcXnDVvHAN2I',
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
