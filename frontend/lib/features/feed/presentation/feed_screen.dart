import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../data/mocks/mock_data.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String _currentUserId = 'user_me';

  // ignore: prefer_final_fields
  List<PostModel> _followingPosts = List.from(MockData.followingPosts);
  // ignore: prefer_final_fields
  List<PostModel> _allPosts = List.from(MockData.allPosts);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleLike(List<PostModel> list, int index) {
    setState(() {
      final post = list[index];
      final newIsLiked = !post.isLiked;
      final newLikesCount = newIsLiked ? post.likesCount + 1 : post.likesCount - 1;

      list[index] = PostModel(
        id: post.id,
        userId: post.userId,
        userName: post.userName,
        userUsername: post.userUsername,
        userAvatarUrl: post.userAvatarUrl,
        content: post.content,
        createdAt: post.createdAt,
        likesCount: newLikesCount,
        isLiked: newIsLiked,
        parentPostId: post.parentPostId,
      );
    });
  }

  void _deletePost(List<PostModel> list, int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  Widget _buildPostList(List<PostModel> posts) {
    if (posts.isEmpty) {
      return const Center(child: Text('Nenhuma postagem encontrada.'));
    }
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCard(
          post: post,
          currentUserId: _currentUserId,
          onLikeToggle: () => _toggleLike(posts, index),
          onReply: () {
            Navigator.pushNamed(
              context,
              '/create-post',
              arguments: post.id,
            );
          },
          onDelete: () => _deletePost(posts, index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papacapim'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Seguindo'),
            Tab(text: 'Explorar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostList(_followingPosts),
          _buildPostList(_allPosts),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-post');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}