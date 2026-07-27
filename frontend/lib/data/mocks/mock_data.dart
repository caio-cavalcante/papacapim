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

  // ─── Usuários para busca ──────────────────────────────────────────────────
  static const List<UserModel> searchableUsers = [
    UserModel(
      id: 'user_me',
      name: 'Caio Cavalcante',
      username: 'caio_cavalcante',
      followersCount: 142,
      followingCount: 38,
      isFollowing: false,
    ),
    UserModel(
      id: 'user_1',
      name: 'João Paulo',
      username: 'jp_prof',
      followersCount: 310,
      followingCount: 12,
      isFollowing: false,
    ),
    UserModel(
      id: 'user_2',
      name: 'Luan Coelho',
      username: 'luannnnn_dev',
      followersCount: 520,
      followingCount: 74,
      isFollowing: true,
    ),
    UserModel(
      id: 'user_3',
      name: 'Breno Oliveira',
      username: 'ditador01',
      followersCount: 88,
      followingCount: 30,
      isFollowing: false,
    ),
    UserModel(
      id: 'user_4',
      name: 'Joseph Borges',
      username: 'joseph_nao_stalin',
      followersCount: 1024,
      followingCount: 200,
      isFollowing: false,
    ),
    UserModel(
      id: 'user_5',
      name: 'Triz',
      username: 'be_a_triz',
      followersCount: 45,
      followingCount: 15,
      isFollowing: true,
    ),
  ];

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
    PostModel(
      id: 'p3',
      userId: 'user_2',
      userName: 'Luan Coelho',
      userUsername: 'luannnnn_dev',
      content:
          'Flutter é incrível! Consegui criar um app bonito em poucos dias 🚀',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      likesCount: 34,
      isLiked: false,
    ),
    PostModel(
      id: 'p4',
      userId: 'user_3',
      userName: 'Breno Oliveira',
      userUsername: 'ditador01',
      content:
          'Dica: utilize o DevTools do Flutter para depurar o layout em tempo real.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likesCount: 19,
      isLiked: false,
    ),
    PostModel(
      id: 'p5',
      userId: 'user_4',
      userName: 'Joseph Borges',
      userUsername: 'joseph_nao_stalin',
      content:
          'Material 3 + Flutter = combinação perfeita para apps modernos e acessíveis! 🎨',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      likesCount: 87,
      isLiked: true,
    ),
    PostModel(
      id: 'p6',
      userId: 'user_5',
      userName: 'Triz',
      userUsername: 'be_a_triz',
      content:
          'Papacapim sendo desenvolvido com muito café ☕ e dedicação. Vamos nessa!',
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      likesCount: 7,
      isLiked: false,
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

  /// Retorna o [UserModel] correspondente ao [userId] da lista [searchableUsers].
  static UserModel? userById(String userId) {
    try {
      return searchableUsers.firstWhere((u) => u.id == userId);
    } catch (_) {
      return null;
    }
  }
}