class Post {
  final String id;
  final String thumbUrl;
  final String mobileUrl;
  final String rawUrl;
  int likeCount;
  bool isLiked;

  Post({
    required this.id,
    required this.thumbUrl,
    required this.mobileUrl,
    required this.rawUrl,
    required this.likeCount,
    this.isLiked = false,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      thumbUrl: map['media_thumb_url'],
      mobileUrl: map['media_mobile_url'],
      rawUrl: map['media_raw_url'],
      likeCount: map['like_count'] ?? 0,
    );
  }
}