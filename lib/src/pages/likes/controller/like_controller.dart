import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
import 'package:brasiltoon/src/pages/likes/repository/like_repository.dart';
import 'package:brasiltoon/src/services/util_services.dart';
import 'package:get/get.dart';

class LikeController extends GetxController {
  final LikeRepository likeRepository = LikeRepository();
  final UtilsServices utilsServices = UtilsServices();
  final authController = Get.find<AuthController>();

  var isLiked = <String, RxBool>{}.obs;
  var likeCount = <String, RxInt>{}.obs;

  Future<void> checkLikeStatus(String productId, String userId) async {
    print('Checking like status for userId: $userId, productId: $productId');
    final result = await likeRepository.isLikedByUser(
      userId: userId,
      productId: productId,
    );

    result.when(
      success: (check) {
        isLiked[productId] = RxBool(check);
        print('Like status for productId: $productId is $check');
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        print('Error checking like status: $message');
      },
    );
  }

  Future<void> getLikeCount(String productId) async {
    print('Getting like count for productId: $productId');
    final result = await likeRepository.getLikeCount(productId: productId);

    result.when(
      success: (count) {
        likeCount[productId] = RxInt(count);
        print('Like count for productId: $productId is $count');
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        print('Error getting like count: $message');
      },
    );
  }

  Future<void> likePost(String productId, String userId) async {
    print('Liking post. userId: $userId, productId: $productId');
    final result = await likeRepository.likePost(
      userId: userId,
      productId: productId,
    );

    result.when(
      success: (success) {
        if (success) {
          isLiked[productId]?.value = true;
          likeCount[productId]?.value = (likeCount[productId]?.value ?? 0) + 1;
          print('Successfully liked the post. productId: $productId');
        }
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        print('Error liking the post: $message');
      },
    );
  }

  Future<void> unlikePost(String productId, String userId) async {
    print('Unliking post. userId: $userId, productId: $productId');
    final result = await likeRepository.unlikePost(
      userId: userId,
      productId: productId,
    );

    result.when(
      success: (success) {
        if (success) {
          isLiked[productId]?.value = false;
          likeCount[productId]?.value = (likeCount[productId]?.value ?? 1) - 1;
          print('Successfully unliked the post. productId: $productId');
        }
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
        print('Error unliking the post: $message');
      },
    );
  }
}
