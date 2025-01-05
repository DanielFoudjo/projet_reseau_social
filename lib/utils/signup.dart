import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signup(String email, String password, String username, String bio, String avatarUrl) async {
    try {
      // Création de l'utilisateur avec Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupération de l'utilisateur authentifié
      User? user = userCredential.user;

      if (user != null) {
        // Ajout des données utilisateur dans Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'email': email,
          'username': username,
          'bio': bio,
          'avatarUrl': avatarUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("Inscription réussie pour l'utilisateur ${user.email}");
        return user;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      // Gestion des exceptions spécifiques à Firebase Authentication
      if (e.code == 'email-already-in-use') {
        print("Cet email est déjà utilisé.");
      } else if (e.code == 'weak-password') {
        print("Le mot de passe est trop faible.");
      } else {
        print("Erreur lors de l'inscription : ${e.message}");
      }
      return null;
    } catch (e) {
      // Gestion des erreurs inattendues
      print("Erreur inattendue : $e");
      return null;
    }
  }
}
