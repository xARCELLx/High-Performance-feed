import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/post_provider.dart';
import 'widgets/post_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    /// initial load
    Future.microtask(() {
      ref.read(feedProvider.notifier).fetchNextPosts();
    });

    /// pagination trigger
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 300) {
        ref.read(feedProvider.notifier).fetchNextPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Feed")),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(feedProvider.notifier).refreshFeed(),
        child: ListView.builder(
          controller: _controller,
          itemCount: posts.length,

          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,

          itemBuilder: (context, index) {
            final post = posts[index];

            return RepaintBoundary(
              child: PostCard(post: post),
            );
          },
        ),
      ),
    );
  }
}