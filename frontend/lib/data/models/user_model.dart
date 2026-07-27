class UserModel {
  final String id;
  final String name;
  final String username;
  final String? avatarUrl;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.avatarUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
  });
}