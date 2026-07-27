import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final String currentUserId;
  final VoidCallback onLikeToggle;
  final VoidCallback onReply;
  final VoidCallback? onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.onLikeToggle,
    required this.onReply,
    this.onDelete,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    final bool isOwner = widget.post.userId == widget.currentUserId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.post.userAvatarUrl != null
                      ? NetworkImage(widget.post.userAvatarUrl!)
                      : null,
                  child: widget.post.userAvatarUrl == null
                      ? Text(widget.post.userName[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '@${widget.post.userUsername}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (isOwner)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: widget.onDelete,
                    tooltip: 'Excluir post',
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(widget.post.content),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: widget.post.isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: widget.onLikeToggle,
                    ),
                    Text('${widget.post.likesCount}'),
                  ],
                ),
                TextButton.icon(
                  onPressed: widget.onReply,
                  icon: const Icon(Icons.reply_outlined, size: 18),
                  label: const Text('Responder'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}