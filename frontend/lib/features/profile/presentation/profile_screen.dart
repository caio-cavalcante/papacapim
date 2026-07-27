import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/post_model.dart';
import '../../../data/mocks/mock_data.dart';
import '../../../features/feed/widgets/post_card.dart';
import '../widgets/stats_counter.dart';
import '../../profile/presentation/edit_profile_screen.dart';

/// Tela de Perfil.
///
/// Pode ser usada de duas formas:
/// 1. Via bottom nav (sem args) → exibe o perfil do usuário logado.
/// 2. Via rota '/profile' com [ProfileScreenArgs] → exibe perfil de outro usuário.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel _user;
  late bool _isCurrentUser;
  late List<PostModel> _posts;
  bool _isFollowing = false;
  bool _argsResolved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsResolved) {
      _argsResolved = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is ProfileScreenArgs) {
        _user = args.user;
        _isCurrentUser = args.isCurrentUser;
      } else {
        _user = MockData.currentUser;
        _isCurrentUser = true;
      }
      _isFollowing = _user.isFollowing;
      _posts = MockData.postsForUser(_user.id);
    }
  }

  // ─── Seguidores locais (simulação) ────────────────────────────────────────
  int get _followersCount =>
      _user.followersCount + (_isFollowing && !_user.isFollowing ? 1 : 0);

  void _toggleFollow() {
    setState(() => _isFollowing = !_isFollowing);
  }

  // ─── Navegação para editar perfil ─────────────────────────────────────────
  Future<void> _goToEditProfile() async {
    final updated = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(user: _user),
      ),
    );
    if (updated != null) {
      setState(() {
        _user = updated;
        _posts = MockData.postsForUser(_user.id);
      });
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar com nome do usuário
          SliverAppBar(
            pinned: true,
            expandedHeight: 0,
            title: Text(
              _isCurrentUser ? 'Meu Perfil' : _user.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            actions: [
              if (_isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: 'Configurações',
                  onPressed: () {},
                ),
            ],
          ),

          // Cabeçalho do perfil
          SliverToBoxAdapter(
            child: _ProfileHeader(
              user: _user,
              isCurrentUser: _isCurrentUser,
              isFollowing: _isFollowing,
              followersCount: _followersCount,
              onEditProfile: _goToEditProfile,
              onToggleFollow: _toggleFollow,
            ),
          ),

          // Divider + Label "Postagens"
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.article_outlined,
                      size: 18, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Postagens',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_posts.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lista de posts
          if (_posts.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.article_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Nenhuma postagem ainda.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = _posts[index];
                  return PostCard(
                    post: post,
                    currentUserId: MockData.currentUser.id,
                    onLikeToggle: () {
                      setState(() {
                        final newLiked = !post.isLiked;
                        _posts[index] = PostModel(
                          id: post.id,
                          userId: post.userId,
                          userName: post.userName,
                          userUsername: post.userUsername,
                          userAvatarUrl: post.userAvatarUrl,
                          content: post.content,
                          createdAt: post.createdAt,
                          likesCount: newLiked
                              ? post.likesCount + 1
                              : post.likesCount - 1,
                          isLiked: newLiked,
                          parentPostId: post.parentPostId,
                        );
                      });
                    },
                    onReply: () {},
                    onDelete: _isCurrentUser
                        ? () => setState(() => _posts.removeAt(index))
                        : null,
                  );
                },
                childCount: _posts.length,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Header de perfil ─────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final UserModel user;
  final bool isCurrentUser;
  final bool isFollowing;
  final int followersCount;
  final VoidCallback onEditProfile;
  final VoidCallback onToggleFollow;

  const _ProfileHeader({
    required this.user,
    required this.isCurrentUser,
    required this.isFollowing,
    required this.followersCount,
    required this.onEditProfile,
    required this.onToggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.tertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: colorScheme.surface,
                    backgroundImage: user.avatarUrl != null
                        ? NetworkImage(user.avatarUrl!)
                        : null,
                    child: user.avatarUrl == null
                        ? Text(
                            user.name[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Nome
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // @username
          Text(
            '@${user.username}',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          // Contadores
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatsCounter(count: followersCount, label: 'Seguidores'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  width: 1,
                  height: 32,
                  color: colorScheme.outlineVariant,
                ),
              ),
              StatsCounter(count: user.followingCount, label: 'Seguindo'),
            ],
          ),

          const SizedBox(height: 20),

          // Botão condicional
          SizedBox(
            width: double.infinity,
            child: isCurrentUser
                ? OutlinedButton.icon(
                    onPressed: onEditProfile,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Editar Perfil'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : FilledButton.icon(
                    onPressed: onToggleFollow,
                    icon: Icon(
                      isFollowing
                          ? Icons.person_remove_outlined
                          : Icons.person_add_outlined,
                      size: 18,
                    ),
                    label: Text(isFollowing ? 'Deixar de seguir' : 'Seguir'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: isFollowing
                          ? colorScheme.secondaryContainer
                          : colorScheme.primary,
                      foregroundColor: isFollowing
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onPrimary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Args de rota ─────────────────────────────────────────────────────────────

/// Parâmetros passados via [Navigator.pushNamed] para a rota '/profile'.
class ProfileScreenArgs {
  final UserModel user;
  final bool isCurrentUser;

  const ProfileScreenArgs({
    required this.user,
    this.isCurrentUser = false,
  });
}
