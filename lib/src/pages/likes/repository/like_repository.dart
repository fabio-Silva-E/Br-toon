import 'package:brasiltoon/src/constants/endpoint.dart';
import 'package:brasiltoon/src/pages/likes/result/like_result.dart';
import 'package:brasiltoon/src/services/http_manager.dart';
import 'package:logger/logger.dart';

class LikeRepository {
  final HttpManager _httpManager = HttpManager();
  final Logger logger = Logger();

  Future<LikeResult<bool>> likePost({
    required String userId,
    required String productId,
  }) async {
    final body = {
      'userId': userId, // Assegure-se de usar 'userId' em vez de 'user'
      'postId': productId,
    };

    logger.d('Request body for like: $body');

    final result = await _httpManager.restRequest(
      url: Endpoints.like,
      method: HttpMethods.post,
      body: body,
    );

    logger.d('Response from like request: $result');

    if (result['result'] != null) {
      return LikeResult.success(result['result']['success']);
    } else {
      return LikeResult.error('Não foi possível adicionar o like');
    }
  }

  Future<LikeResult<bool>> unlikePost({
    required String userId,
    required String productId,
  }) async {
    final body = {
      'userId': userId, // Assegure-se de usar 'userId' em vez de 'user'
      'postId': productId,
    };

    logger.d('Request body for unlike: $body');

    final result = await _httpManager.restRequest(
      url: Endpoints.unlike,
      method: HttpMethods.post,
      body: body,
    );

    logger.d('Response from unlike request: $result');

    if (result['result'] != null) {
      return LikeResult.success(result['result']['success']);
    } else {
      return LikeResult.error('Não foi possível remover o like');
    }
  }

  Future<LikeResult<int>> getLikeCount({
    required String productId,
  }) async {
    final body = {
      'postId': productId,
    };

    logger.d('Request body for getLikeCount: $body');

    final result = await _httpManager.restRequest(
      url: Endpoints.getLikeCount,
      method: HttpMethods.post,
      body: body,
    );

    logger.d('Response from getLikeCount request: $result');

    if (result['result'] != null) {
      return LikeResult.success(result['result']['likeCount']);
    } else {
      return LikeResult.error(
          'Não foi possível recuperar os likes desta história');
    }
  }

  Future<LikeResult<bool>> isLikedByUser({
    required String userId,
    required String productId,
  }) async {
    final body = {
      'userId': userId, // Assegure-se de usar 'userId' em vez de 'user'
      'postId': productId,
    };

    final result = await _httpManager.restRequest(
      url: Endpoints.isLikedByUser,
      method: HttpMethods.post,
      body: body,
    );

    if (result['result'] != null) {
      return LikeResult.success(result['result']['isLiked'] as bool);
    } else {
      return LikeResult.error('Não foi possível checar o estado do like');
    }
  }
}
