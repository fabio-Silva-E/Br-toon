import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/models/category_model.dart';
import 'package:brasiltoon/src/pages/story_editing/repository/editing_erros.dart'
    as Errors;
import 'package:brasiltoon/src/pages/story_editing/result/editi_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';
import 'dart:convert';

class EditingRepository {
  final HttpManager _httpManager = HttpManager();
  EditiResult handleSucessOrError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      return EditiResult.success('Pagina alterada com sucesso');
    } else {
      return EditiResult.error(Errors.editingErrorString(result['error']));
    }
  }

  Future<EditiResult<List<CategoryModel>>> getAllCategories() async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllCategories,
      method: HttpMethods.post,
    );

    if (result['result'] != null) {
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();
      return EditiResult.success(data);
    } else {
      return EditiResult.error(Errors.editingErrorString(result['error']));
    }
  }

  Future<EditiResult<String>> editeCover({
    required String userId,
    required String token,
    required String title,
    required String productId,
    required String description,
    required String category,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.editeCoverStory,
        method: HttpMethods.post,
        body: {
          'user': userId,
          'productId': productId,
          "title": title,
          "description": description,
          "category": category
        },
        headers: {
          'X-Parse-Session-Token': token,
        });
    if (result['result'] != null) {
      Map<String, dynamic> jsonData = result['result'];

      // Formata o JSON com quebra de linha após cada vírgula
      String jsonString = const JsonEncoder().convert(jsonData);
      // Remove as chaves e as aspas
      jsonString = jsonString
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll('"', '');

      // Formata o JSON com quebra de linha após cada vírgula
      String formattedJson =
          const JsonEncoder.withIndent('  ').convert(jsonData);
      formattedJson = formattedJson.replaceAll(',', ',\n');

      return EditiResult.success(formattedJson);
      //   print('id ');
    } else {
      return EditiResult.error(Errors.editingErrorString(result['error']));
    }
  }

  Future<EditiResult<String>> editeChapter({
    required String userId,
    required String token,
    required String title,
    required String chapterId,
    required String description,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.editeChapterStory,
        method: HttpMethods.post,
        body: {
          'user': userId,
          'chapterId': chapterId,
          "title": title,
          "description": description
        },
        headers: {
          'X-Parse-Session-Token': token,
        });
    if (result['result'] != null) {
      Map<String, dynamic> jsonData = result['result'];

      // Formata o JSON com quebra de linha após cada vírgula
      String jsonString = const JsonEncoder().convert(jsonData);
      // Remove as chaves e as aspas
      jsonString = jsonString
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll('"', '');

      // Formata o JSON com quebra de linha após cada vírgula
      String formattedJson =
          const JsonEncoder.withIndent('  ').convert(jsonData);
      formattedJson = formattedJson.replaceAll(',', ',\n');

      return EditiResult.success(formattedJson);
      //   print('id ');
    } else {
      return EditiResult.error(Errors.editingErrorString(result['error']));
    }
  }

  Future<EditiResult<String>> editePage({
    required String userId,
    required String token,
    required String pageId,
  }) async {
    final result = await _httpManager
        .restRequest(url: Endpoints.editePage, method: HttpMethods.post, body: {
      'user': userId,
      'pageId': pageId,
    }, headers: {
      'X-Parse-Session-Token': token,
    });

    // Formata o JSON com quebra de linha após cada vírgula
    if (result['result'] != null) {
      return EditiResult.success(result['result']);
      //   print('id ');
    } else {
      return EditiResult.error(Errors.editingErrorString(result['error']));
    }
  }

  Future<EditiResult<String>> deletePage({
    required String userId,
    required String token,
    required String pageId,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.deletePage,
        method: HttpMethods.post,
        body: {
          'user': userId,
          'pageId': pageId,
        },
        headers: {
          'X-Parse-Session-Token': token,
        });

    // Formata o JSON com quebra de linha após cada vírgula
    if (result['result'] != null) {
      return EditiResult.success(result['result']);
      //   print('id ');
    } else {
      return EditiResult.error(Errors.editingErrorString(result['error']));
    }
  }

  Future<EditiResult<String>> deleteChapter({
    required String userId,
    required String token,
    required String chapterId,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.deleteChapter,
        method: HttpMethods.post,
        body: {
          'user': userId,
          'chapterId': chapterId,
        },
        headers: {
          'X-Parse-Session-Token': token,
        });
    if (result['result'] != null) {
      return EditiResult.success(result['result']);
    } else {
      return EditiResult.error(Errors.editingErrorString(result['error']));
    }
  }

  Future<EditiResult<String>> deleteCover({
    required String userId,
    required String token,
    required String productId,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.deleteStory,
        method: HttpMethods.post,
        body: {
          'user': userId,
          'productId': productId,
        },
        headers: {
          'X-Parse-Session-Token': token,
        });
    if (result['result'] != null) {
      return EditiResult.success(result['result']);
    } else {
      return EditiResult.error(Errors.editingErrorString(result['error']));
    }
  }
}
