import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/post_model.dart';
import '../../detail/detail_screen.dart';
import '../../../providers/post_provider.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        /// 🔥 Navigate to Detail Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(post: post),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

          /// 🔥 HEAVY SHADOW (GPU test)
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 30,
              spreadRadius: 5,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖼️ IMAGE + HERO
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
              child: Hero(
                tag: post.id,
                child: CachedNetworkImage(
                  imageUrl: post.thumbUrl,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,

                  /// 🔥 RAM optimization
                  memCacheWidth: 400,
                  memCacheHeight: 400,

                  placeholder: (context, url) => Container(
                    height: 260,
                    color: Colors.grey[300],
                  ),

                  errorWidget: (context, url, error) =>
                  const SizedBox(
                    height: 260,
                    child: Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            ),

            /// ❤️ FOOTER (INTERACTIVE)
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  /// 🔥 LIKE BUTTON (now functional)
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(feedProvider.notifier)
                          .toggleLike(post);
                    },
                    child: Icon(
                      post.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                      post.isLiked ? Colors.red : Colors.black,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// LIKE COUNT
                  Text(
                    "${post.likeCount} likes",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}