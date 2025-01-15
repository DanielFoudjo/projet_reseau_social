import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String userId;
  String ownerUsername;
  String ownerAvatar;
  String? content;
  String? imageUrl;
  DateTime createdAt;
  int likeCount=0; // nombre de like
  int commentsCount=0; // nombre de comments
  // final String? userAvatarUrl; // URL de l'avatar
  List<String> likedBy;

  Post({
    this.id,
    required this.userId,
    required this.ownerUsername,
    required this.ownerAvatar,
    this.content,
    this.imageUrl,
    required this.createdAt, 
    required likeCount,
    required commentsCount,
    this.likedBy = const [],
  });

  factory Post.fromMap(Map<String, dynamic> data, String id) {
    return Post(
      id: data['id'],
      userId: data['userId'] ?? '',
      ownerUsername: data['ownerUsername'] ?? '',
      ownerAvatar: data['ownerAvatar'] ?? '',
      content: data['content'] ?? '', // Assure-toi que 'username' existe dans la base de données
      // userAvatarUrl: data['userAvatarUrl'] ?? '', // Assure-toi que 'userAvatarUrl' existe aussi
      // content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likeCount: data['likeCount']?? 0,
      commentsCount: data['commentsCount']?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
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
