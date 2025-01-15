import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projet_reseau_social/models/user_model.dart';

class GetUserDataFromFirestore {
  static Future<UserModel?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Récupération des données utilisateur depuis Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Nom de la collection
          .doc(uid) // UID comme clé du document
          .get();

      if (userDoc.exists) {
        // Conversion des données en modèle utilisateur
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>, user.uid);
      }
    }
  }

  static Future<UserModel> getOneUser(String username) async {

      // Récupération des données utilisateur depuis Firestore
      // DocumentSnapshot userDoc = await FirebaseFirestore.instance
      //     .collection('users') // Nom de la collection
      //     .doc(ownerUid) // UID comme clé du document
      //     .get();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users') // Nom de la collection
        .where('username', isEqualTo: username) // Champ et valeur à rechercher
        .limit(1) // Limite à un seul résultat (optionnel mais recommandé)
        .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Conversion des données en modèle utilisateur
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>, userDoc['id']);
      }else {
        throw Exception("Utilisateur introuvable.");
      }
  }


}
