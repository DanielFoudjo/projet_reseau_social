import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Génère un identifiant unique pour une salle de chat entre deux utilisateurs
  String generateChatRoomId(String user1, String user2) {
    List<String> users = [user1, user2];
    users.sort();
    return users.join('_');
  }

  /// Récupère la liste des utilisateurs enregistrés
  Stream<List<Map<String, dynamic>>> getUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// Récupère la liste des conversations de l'utilisateur actuel
  Stream<List<Map<String, dynamic>>> getConversations(String currentUser) {
    return _firestore
        .collection('messages')
        .where('from', isEqualTo: currentUser)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// Envoie un message dans Firestore
  Future<void> sendMessage(MessageModel message, String chatRoomId) async {
    try {
      final messageData = message.toJson();
      messageData['chatRoomId'] = chatRoomId;

      await _firestore.collection('messages').add(messageData);
    } catch (e) {
      print('Erreur lors de l\'envoi du message : $e');
    }
  }

}
