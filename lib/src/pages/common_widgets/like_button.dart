import 'package:brasiltoon/src/models/item_models.dart';
import 'package:brasiltoon/src/models/user_models.dart';
import 'package:brasiltoon/src/pages/likes/controller/like_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LikeButton extends StatelessWidget {
  final String post;
  final String userId;

  const LikeButton({
    super.key,
    required this.post,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final LikeController likeController = Get.find<LikeController>();

    // Initialize the state for this particular LikeButton
    likeController.checkLikeStatus(post, userId);
    likeController.getLikeCount(post);

    return Obx(() {
      // Fetch the correct state for the specific post
      bool isLiked = likeController.isLiked[post]?.value ?? false;
      int likeCount = likeController.likeCount[post]?.value ?? 0;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              '$likeCount',
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4), // Spacing between text and icon
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
            ),
            onPressed: () {
              if (isLiked) {
                likeController.unlikePost(post, userId);
              } else {
                likeController.likePost(post, userId);
              }
            },
          ),
        ],
      );
    });
  }
}
