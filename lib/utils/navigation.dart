import 'package:flutter/material.dart';
import '../screens/create_post_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/feed_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Navigation extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      
      selectedItemColor: Colors.red, // Icon color when selected
      unselectedItemColor: Colors.black, // Icon color when unselected
      onTap: (index) {
        if(index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FeedScreen()),
          );
        }else if(index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        }else if(index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        }else if(index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NotificationsScreen()),
          );
        }else if(index == 4) {
          Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        // Si aucun utilisateur n'est connecté, affiche un message ou redirige
        return Scaffold(
          body: Center(
            child: Text(
              "Aucun utilisateur connecté. Veuillez vous connecter.",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
        );
      }

      return ProfileScreen(userId: userId); // Passe l'ID utilisateur connecté
    },
  ),
);

        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Search",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: "Post",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Notifications",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}