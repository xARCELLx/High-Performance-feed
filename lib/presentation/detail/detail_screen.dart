import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/post_model.dart';

class DetailScreen extends StatefulWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool highQualityLoaded = false;

  @override
  void initState() {
    super.initState();

    /// simulate async loading of better image
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        highQualityLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          /// HERO IMAGE
          Hero(
            tag: post.id,
            child: Stack(
              children: [
                /// 🔹 Thumbnail (instant)
                CachedNetworkImage(
                  imageUrl: post.thumbUrl,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),

                /// 🔹 Mobile image (fade in)
                if (highQualityLoaded)
                  Positioned.fill(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: highQualityLoaded ? 1 : 0,
                      child: CachedNetworkImage(
                        imageUrl: post.mobileUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// DOWNLOAD BUTTON
          ElevatedButton(
            onPressed: () {
              _downloadHighRes(post.rawUrl);
            },
            child: const Text("Download High-Res"),
          ),
        ],
      ),
    );
  }

  void _downloadHighRes(String url) {
    /// for assignment, just print or open link
    debugPrint("Download: $url");
  }
}