import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Post>> fetchPosts() async {
    QuerySnapshot snapshot = await _firestore.collection('posts').orderBy('createdAt', descending: true).get();
    // QuerySnapshot snapshot = await _firestore
    //   .collection('posts')
    //   .where('userId', isNotEqualTo: currentUserId) // Exclure les posts de l'utilisateur connecté
    //   .orderBy('createdAt', descending: true) // Tri par date de création
    //   .get();
    return snapshot.docs.map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> createPost(String userId, String ownerUsername, String ownerAvatar, String content, String imageUrl) async {
    await _firestore.collection('posts').add({
      'userId': userId,
      'ownerUsername' : ownerUsername,
      'ownerAvatar' : ownerAvatar,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'likeCount': 0,
      'commentCount': 0,
    });
  }
}
