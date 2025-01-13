import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String userId;
  String? content;
  String? imageUrl;
  DateTime createdAt;
  int likeCount=0; // nombre de like
  int commentsCount=0; // nombre de comments
  // final String? userAvatarUrl; // URL de l'avatar

  Post({
    required this.userId,
    this.content,
    this.imageUrl,
    required this.createdAt, 
    required likeCount,
    required commentsCount,
  });

  factory Post.fromMap(Map<String, dynamic> data, String id) {
    return Post(
      userId: data['userId'] ?? '',
      content: data['content'] ?? '', // Assure-toi que 'username' existe dans la base de données
      // userAvatarUrl: data['userAvatarUrl'] ?? '', // Assure-toi que 'userAvatarUrl' existe aussi
      // content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likeCount: data['likeCount']?? 0,
      commentsCount: data['commentsCount']?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      // 'username': username,
      // 'userAvatarUrl': userAvatarUrl,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'likeCount': likeCount,
      'commentsCount': commentsCount,
    };
  }
}
