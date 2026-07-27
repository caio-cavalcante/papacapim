import '../models/post_model.dart';
import '../models/user_model.dart';

class MockData {
  // ─── Usuário logado (eu mesmo) ────────────────────────────────────────────
  static const UserModel currentUser = UserModel(
    id: 'user_me',
    name: 'Caio Cavalcante',
    username: 'caio_cavalcante',
    followersCount: 142,
    followingCount: 38,
    isFollowing: false,
  );

  // ─── Outro usuário (para demo de seguir/deixar de seguir) ────────────────
  static const UserModel otherUser = UserModel(
    id: 'user_1',
    name: 'João Paulo',
    username: 'jp_prof',
    followersCount: 310,
    followingCount: 12,
    isFollowing: false,
  );

  // ─── Posts do feed ────────────────────────────────────────────────────────
  static final List<PostModel> followingPosts = [
    PostModel(
      id: 'p1',
      userId: 'user_1',
      userName: 'João Paulo',
      userUsername: 'jp_prof',
      content:
          'Trabalho de Flutter do Papacapim lançado! Fiquem atentos aos prazos.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 12,
      isLiked: false,
    ),
  ];

  static final List<PostModel> allPosts = [
    PostModel(
      id: 'p1',
      userId: 'user_1',
      userName: 'João Paulo',
      userUsername: 'jp_prof',
      content:
          'Trabalho de Flutter do Papacapim lançado! Fiquem atentos aos prazos.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 12,
      isLiked: false,
    ),
    PostModel(
      id: 'p2',
      userId: 'user_me',
      userName: 'Caio Cavalcante',
      userUsername: 'caio_cavalcante',
      content: 'Estrutura do aplicativo finalizada sem erros de compilação!',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      likesCount: 3,
      isLiked: true,
    ),
  ];

  // ─── Posts por perfil ─────────────────────────────────────────────────────
  static final List<PostModel> currentUserPosts = [
    PostModel(
      id: 'me_p1',
      userId: 'user_me',
      userName: 'Caio Cavalcante',
      userUsername: 'caio_cavalcante',
      content: 'Estrutura do aplicativo finalizada sem erros de compilação!',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      likesCount: 3,
      isLiked: true,
    ),
    PostModel(
      id: 'me_p2',
      userId: 'user_me',
      userName: 'Caio Cavalcante',
      userUsername: 'caio_cavalcante',
      content:
          'Clean Architecture + Flutter é uma combinação poderosa. Muito feliz com o progresso do projeto Papacapim 🐦',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likesCount: 21,
      isLiked: false,
    ),
    PostModel(
      id: 'me_p3',
      userId: 'user_me',
      userName: 'Caio Cavalcante',
      userUsername: 'caio_cavalcante',
      content:
          'Dica do dia: use IndexedStack no BottomNavigation para preservar o estado de cada aba sem recriar os widgets.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      likesCount: 47,
      isLiked: false,
    ),
  ];

  static final List<PostModel> otherUserPosts = [
    PostModel(
      id: 'jp_p1',
      userId: 'user_1',
      userName: 'João Paulo',
      userUsername: 'jp_prof',
      content:
          'Trabalho de Flutter do Papacapim lançado! Fiquem atentos aos prazos.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 12,
      isLiked: false,
    ),
    PostModel(
      id: 'jp_p2',
      userId: 'user_1',
      userName: 'João Paulo',
      userUsername: 'jp_prof',
      content:
          'Lembrem-se: a documentação do Flutter é excelente. Leiam antes de perguntar 😄',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      likesCount: 56,
      isLiked: true,
    ),
    PostModel(
      id: 'jp_p3',
      userId: 'user_1',
      userName: 'João Paulo',
      userUsername: 'jp_prof',
      content:
          'Apresentações da Parte 1 na próxima semana. Caprichem no design! A interface é o primeiro impacto para os investidores.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      likesCount: 33,
      isLiked: false,
    ),
  ];

  /// Retorna os posts de um determinado userId a partir dos dados mockados.
  static List<PostModel> postsForUser(String userId) {
    if (userId == 'user_me') return currentUserPosts;
    if (userId == 'user_1') return otherUserPosts;
    return allPosts.where((p) => p.userId == userId).toList();
  }
}