import 'package:flutter/material.dart';
import 'core/navigation/app_routes.dart';

void main() {
  runApp(const PapacapimApp());
}

class PapacapimApp extends StatelessWidget {
  const PapacapimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Papacapim',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Define a rota inicial para o Shell principal (Feed, Busca, Perfil)
      initialRoute: AppRoutes.mainShell,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}