import 'package:flutter/material.dart';
import '../../../data/mocks/mock_data.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/user_model.dart';
import '../../feed/widgets/post_card.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../../core/navigation/app_routes.dart';

/// Tela de Busca com TabBar (Posts | Usuários) e filtragem dinâmica em tempo real.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  // Posts mutáveis (para like local)
  late List<PostModel> _allPosts;

  // Usuários com follow local state
  late List<_UserFollowState> _users;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _allPosts = List<PostModel>.from(MockData.allPosts);
    _users = MockData.searchableUsers
        .map((u) => _UserFollowState(user: u, isFollowing: u.isFollowing))
        .toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ─── Filtragem ─────────────────────────────────────────────────────────────

  List<PostModel> get _filteredPosts {
    if (_query.isEmpty) return _allPosts;
    final q = _query.toLowerCase();
    return _allPosts.where((p) => p.content.toLowerCase().contains(q)).toList();
  }

  List<_UserFollowState> get _filteredUsers {
    if (_query.isEmpty) return _users;
    final q = _query.toLowerCase();
    return _users
        .where((s) =>
            s.user.name.toLowerCase().contains(q) ||
            s.user.username.toLowerCase().contains(q))
        .toList();
  }

  // ─── Ações ─────────────────────────────────────────────────────────────────

  void _onQueryChanged(String value) {
    setState(() => _query = value.trim());
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  void _toggleFollow(int filteredIndex) {
    final original = _filteredUsers[filteredIndex];
    final globalIdx = _users.indexOf(original);
    if (globalIdx != -1) {
      setState(() {
        _users[globalIdx] = _UserFollowState(
          user: original.user,
          isFollowing: !original.isFollowing,
        );
      });
    }
  }

  void _navigateToProfile(UserModel user) {
    final isCurrentUser = user.id == MockData.currentUser.id;
    Navigator.pushNamed(
      context,
      AppRoutes.profile,
      arguments: ProfileScreenArgs(user: user, isCurrentUser: isCurrentUser),
    );
  }

  void _toggleLike(int filteredIndex) {
    final post = _filteredPosts[filteredIndex];
    final globalIdx = _allPosts.indexWhere((p) => p.id == post.id);
    if (globalIdx == -1) return;
    setState(() {
      final p = _allPosts[globalIdx];
      _allPosts[globalIdx] = PostModel(
        id: p.id,
        userId: p.userId,
        userName: p.userName,
        userUsername: p.userUsername,
        userAvatarUrl: p.userAvatarUrl,
        content: p.content,
        createdAt: p.createdAt,
        likesCount: p.isLiked ? p.likesCount - 1 : p.likesCount + 1,
        isLiked: !p.isLiked,
        parentPostId: p.parentPostId,
      );
    });
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: colorScheme.surfaceTint,
            title: const Text(
              'Busca',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(112),
              child: Column(
                children: [
                  // ── Campo de busca ───────────────────────────────────────
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SearchBar(
                      controller: _searchController,
                      hintText: 'Buscar posts e usuários…',
                      leading: Icon(Icons.search, color: colorScheme.primary),
                      trailing: _query.isNotEmpty
                          ? [
                              IconButton(
                                icon: const Icon(Icons.clear),
                                tooltip: 'Limpar',
                                onPressed: _clearSearch,
                              )
                            ]
                          : null,
                      onChanged: _onQueryChanged,
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 16),
                      ),
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor: WidgetStatePropertyAll(
                        colorScheme.surfaceContainerHighest,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  // ── TabBar ───────────────────────────────────────────────
                  TabBar(
                    controller: _tabController,
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    indicatorColor: colorScheme.primary,
                    dividerColor: colorScheme.outlineVariant,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                    tabs: [
                      Tab(
                        icon: const Icon(Icons.article_outlined, size: 20),
                        text: 'Posts (${_filteredPosts.length})',
                      ),
                      Tab(
                        icon: const Icon(Icons.people_outline, size: 20),
                        text: 'Usuários (${_filteredUsers.length})',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],

        // ── Conteúdo das abas ─────────────────────────────────────────────
        body: TabBarView(
          controller: _tabController,
          children: [
            _PostsTab(
              posts: _filteredPosts,
              query: _query,
              onLike: _toggleLike,
            ),
            _UsersTab(
              users: _filteredUsers,
              query: _query,
              onToggleFollow: _toggleFollow,
              onNavigateToProfile: _navigateToProfile,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Aba de Posts ─────────────────────────────────────────────────────────────

class _PostsTab extends StatelessWidget {
  final List<PostModel> posts;
  final String query;
  final void Function(int index) onLike;

  const _PostsTab({
    required this.posts,
    required this.query,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return _EmptyState(
        icon: Icons.article_outlined,
        title: query.isEmpty ? 'Nenhum post disponível' : 'Nenhum post encontrado',
        subtitle: query.isEmpty
            ? 'Os posts aparecerão aqui.'
            : 'Tente buscar por outro termo.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(
          post: posts[index],
          currentUserId: MockData.currentUser.id,
          onLikeToggle: () => onLike(index),
          onReply: () {},
        );
      },
    );
  }
}

// ─── Aba de Usuários ──────────────────────────────────────────────────────────

class _UsersTab extends StatelessWidget {
  final List<_UserFollowState> users;
  final String query;
  final void Function(int index) onToggleFollow;
  final void Function(UserModel user) onNavigateToProfile;

  const _UsersTab({
    required this.users,
    required this.query,
    required this.onToggleFollow,
    required this.onNavigateToProfile,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return _EmptyState(
        icon: Icons.person_search_outlined,
        title: query.isEmpty
            ? 'Nenhum usuário encontrado'
            : 'Nenhum resultado para "$query"',
        subtitle: query.isEmpty
            ? 'Os usuários aparecerão aqui.'
            : 'Tente buscar pelo nome ou @username.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final state = users[index];
        return _UserTile(
          userState: state,
          onToggleFollow: () => onToggleFollow(index),
          onNavigate: () => onNavigateToProfile(state.user),
        );
      },
    );
  }
}

// ─── Item de Usuário ──────────────────────────────────────────────────────────

class _UserTile extends StatelessWidget {
  final _UserFollowState userState;
  final VoidCallback onToggleFollow;
  final VoidCallback onNavigate;

  const _UserTile({
    required this.userState,
    required this.onToggleFollow,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = userState.user;
    final isCurrentUser = user.id == MockData.currentUser.id;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onNavigate,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Avatar
              _UserAvatar(user: user, colorScheme: colorScheme),

              const SizedBox(width: 12),

              // Nome e @username
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@${user.username}',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${_formatCount(user.followersCount)} seguidores',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Botão de ação
              if (isCurrentUser)
                OutlinedButton.icon(
                  onPressed: onNavigate,
                  icon: const Icon(Icons.person_outline, size: 16),
                  label: const Text('Ver Perfil'),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              else
                FilledButton.icon(
                  onPressed: onToggleFollow,
                  icon: Icon(
                    userState.isFollowing
                        ? Icons.person_remove_outlined
                        : Icons.person_add_outlined,
                    size: 16,
                  ),
                  label: Text(userState.isFollowing ? 'Seguindo' : 'Seguir'),
                  style: FilledButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: userState.isFollowing
                        ? colorScheme.secondaryContainer
                        : colorScheme.primary,
                    foregroundColor: userState.isFollowing
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onPrimary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return '$count';
  }
}

// ─── Avatar do usuário ────────────────────────────────────────────────────────

class _UserAvatar extends StatelessWidget {
  final UserModel user;
  final ColorScheme colorScheme;

  const _UserAvatar({required this.user, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.5),
        child: CircleAvatar(
          backgroundColor: colorScheme.surface,
          backgroundImage:
              user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
          child: user.avatarUrl == null
              ? Text(
                  user.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

// ─── Estado Vazio ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
              ),
              child: Icon(
                icon,
                size: 40,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── State holder para follow local ──────────────────────────────────────────

class _UserFollowState {
  final UserModel user;
  final bool isFollowing;

  const _UserFollowState({required this.user, required this.isFollowing});
}
