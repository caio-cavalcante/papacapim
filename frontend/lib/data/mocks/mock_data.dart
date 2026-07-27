import '../models/post_model.dart';

class MockData {
  static final List<PostModel> followingPosts = [
    PostModel(
      id: 'p1',
      userId: 'user_1',
      userName: 'João Paulo',
      userUsername: 'jp_prof',
      content: 'Trabalho de Flutter do Papacapim lançado! Fiquem atentos aos prazos.',
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
      content: 'Trabalho de Flutter do Papacapim lançado! Fiquem atentos aos prazos.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 12,
      isLiked: false,
    ),
    PostModel(
      id: 'p2',
      userId: 'user_2',
      userName: 'Caio Cavalcante',
      userUsername: 'caio_cavalcante',
      content: 'Estrutura do aplicativo finalizada sem erros de compilação!',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      likesCount: 3,
      isLiked: true,
    ),
  ];
}