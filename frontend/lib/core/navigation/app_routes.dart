import 'package:flutter/material.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/feed/presentation/feed_screen.dart';
import '../../features/feed/presentation/create_post_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../data/mocks/mock_data.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String mainShell = '/';
  static const String createPost = '/create-post';
  static const String editProfile = '/edit-profile';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        mainShell: (context) => const MainShell(),
        createPost: (context) => const CreatePostScreen(),
        // '/edit-profile' é aberto via MaterialPageRoute diretamente do ProfileScreen.
        // Mantido aqui como fallback sem args.
        editProfile: (context) =>
            EditProfileScreen(user: MockData.currentUser),
        // '/profile' recebe ProfileScreenArgs via settings.arguments.
        profile: (context) => const ProfileScreen(),
      };
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    FeedScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Busca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}