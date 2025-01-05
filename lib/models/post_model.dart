import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final String username; // Nom de l'utilisateur
  final String userAvatarUrl; // URL de l'avatar

  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.username,
    required this.userAvatarUrl
  });

  factory Post.fromMap(Map<String, dynamic> data, String id) {
    return Post(
      id: id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? '', // Assure-toi que 'username' existe dans la base de données
      userAvatarUrl: data['userAvatarUrl'] ?? '', // Assure-toi que 'userAvatarUrl' existe aussi
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'userAvatarUrl': userAvatarUrl,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
