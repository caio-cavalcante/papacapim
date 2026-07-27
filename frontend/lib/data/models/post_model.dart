class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String userUsername;
  final String? userAvatarUrl;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final bool isLiked;
  final String? parentPostId;

  const PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userUsername,
    this.userAvatarUrl,
    required this.content,
    required this.createdAt,
    this.likesCount = 0,
    this.isLiked = false,
    this.parentPostId,
  });
}