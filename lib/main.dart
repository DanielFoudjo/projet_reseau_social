import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/search_screen.dart';
import 'screens/create_post_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Ajout de Firebase Auth
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SocialNetworkApp());
}

class SocialNetworkApp extends StatelessWidget {
  const SocialNetworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Network',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      // Écran par défaut (page d'accueil après login)
      home: AuthScreen(),
      routes: {
        '/home': (context) => FeedScreen(),
        '/search': (context) => SearchScreen(),
        '/create-post': (context) => CreatePostScreen(),
        '/notifications': (context) => NotificationsScreen(),
        '/profile': (context) {
          // Récupération du userId de l'utilisateur connecté
          final String? userId = FirebaseAuth.instance.currentUser?.uid;

          if (userId == null) {
            // Si aucun utilisateur connecté, affiche un message ou redirige
            return Scaffold(
              appBar: AppBar(title: const Text("Erreur")),
              body: const Center(
                child: Text(
                  "Aucun utilisateur connecté. Veuillez vous connecter.",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            );
          }

          // Si un utilisateur est connecté, charge la page du profil
          return ProfileScreen(userId: userId);
        },
      },
    );
  }
}
