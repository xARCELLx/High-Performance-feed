import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';

class PostRepository {
  final supabase = Supabase.instance.client;

  Future<List<Post>> fetchPosts(int from, int to) async {
    final response = await supabase
        .from('posts')
        .select()
        .order('created_at', ascending: false)
        .range(from, to);

    return (response as List)
        .map((e) => Post.fromMap(e))
        .toList();
  }

  Future<void> toggleLike(String postId, String userId) async {
    await supabase.rpc('toggle_like', params: {
      'p_post_id': postId,
      'p_user_id': userId,
    });
  }
}