import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/post_model.dart';
import '../data/repositories/post_repository.dart';

final postRepositoryProvider = Provider((ref) => PostRepository());

final feedProvider =
StateNotifierProvider<FeedNotifier, List<Post>>((ref) {
  return FeedNotifier(ref);
});

class FeedNotifier extends StateNotifier<List<Post>> {
  FeedNotifier(this.ref) : super([]);

  final Ref ref;

  int page = 0;
  bool isLoading = false;

  /// 🔥 Prevent spam clicking
  final Map<String, bool> _loadingMap = {};

  /// ==============================
  /// 📡 FETCH POSTS (PAGINATION)
  /// ==============================
  Future<void> fetchNextPosts() async {
    if (isLoading) return;

    isLoading = true;

    final repo = ref.read(postRepositoryProvider);

    try {
      final newPosts = await repo.fetchPosts(
        page * 10,
        (page + 1) * 10 - 1,
      );

      state = [...state, ...newPosts];
      page++;
    } catch (e) {
      // optional: log error
    }

    isLoading = false;
  }

  /// ==============================
  /// 🔄 REFRESH FEED
  /// ==============================
  Future<void> refreshFeed() async {
    page = 0;
    state = [];
    await fetchNextPosts();
  }

  /// ==============================
  /// TOGGLE LIKE (OPTIMISTIC UI)
  /// ==============================
  Future<void> toggleLike(Post post) async {
    /// 🚨 Prevent spam clicking
    if (_loadingMap[post.id] == true) return;
    _loadingMap[post.id] = true;

    final repo = ref.read(postRepositoryProvider);

    /// 🔁 Save old state for rollback
    final oldLiked = post.isLiked;
    final oldCount = post.likeCount;

    /// OPTIMISTIC UPDATE (instant UI)
    post.isLiked = !post.isLiked;
    post.likeCount += post.isLiked ? 1 : -1;

    /// Trigger UI rebuild
    state = [...state];

    try {
      /// 🔥 Backend call
      await repo.toggleLike(post.id, "user_123");
    } catch (e) {
      /// ROLLBACK if API fails
      post.isLiked = oldLiked;
      post.likeCount = oldCount;

      state = [...state];
    }

    /// ✅ Allow next click
    _loadingMap[post.id] = false;
  }
}