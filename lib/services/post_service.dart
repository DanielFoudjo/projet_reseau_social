import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model';
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
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    // Générer un ID pour le document
    String documentId = posts.doc().id;
    await _firestore.collection('posts').doc(documentId).set({
      'id' : documentId,
      'userId': userId,
      'ownerUsername' : ownerUsername,
      'ownerAvatar' : ownerAvatar,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'likeCount': 0,
      'commentCount': 0,
      'likedBy': [],
    });
  }



  Future<void> likePost(String postId, String userId, bool isLiked) async {
    try {
      // Référence au document du post dans Firestore
      DocumentReference postRef = _firestore.collection('posts').doc(postId);

      if (isLiked) {
        // Si l'utilisateur a aimé, on le retire de `likedBy` et décrémente `likeCount`
        await postRef.update({
          'likedBy': FieldValue.arrayRemove([userId]),
          'likeCount': FieldValue.increment(-1),
        });
      } else {
        // Si l'utilisateur n'a pas aimé, on l'ajoute à `likedBy` et incrémente `likeCount`
        await postRef.update({
          'likedBy': FieldValue.arrayUnion([userId]),
          'likeCount': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print("Erreur lors de la mise à jour du like : $e");
      throw Exception("Impossible de liker le post.");
    }
  }


  // Ajouter un commentaire à un post
  Future<void> addComment(String postId, String userId, String username, String content) async {
    final comment = Comment(
      userId: userId,
      username: username,
      content: content,
      createdAt: DateTime.now(),
    );

    // Ajout du commentaire dans la collection des commentaires sous le post
    await _firestore.collection('posts').doc(postId).collection('comments').add(comment.toMap());

    // Met à jour le compteur de commentaires du post
    await _firestore.collection('posts').doc(postId).update({
      'commentCount': FieldValue.increment(1),
    });
  }

  // Récupérer les commentaires d'un post
  Future<List<Comment>> fetchComments(String postId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Comment.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}



//   Future<void> _likePost(Post post) async {
//   try {
//     // Vérifie si l'utilisateur a déjà aimé le post
//     final isLiked = post.likedBy.contains(userId);

//     // Met à jour la base de données Firestore
//     await FirebaseFirestore.instance
//         .collection('posts')
//         .doc(post.id)
//         .update({
//       'likeCount': FieldValue.increment(isLiked ? -1 : 1),
//       'likedBy': isLiked
//           ? FieldValue.arrayRemove([userId]) // Retirer l'utilisateur des likes
//           : FieldValue.arrayUnion([userId]) // Ajouter l'utilisateur aux likes
//     });

//     // Met à jour localement pour une meilleure UX
//     setState(() {
//       if (isLiked) {
//         post.likedBy.remove(userId);
//         post.likeCount--;
//       } else {
//         post.likedBy.add(userId);
//         post.likeCount++;
//       }
//     });
//   } catch (e) {
//     print("Erreur lors de l'ajout d'un like : $e");
//   }
// }


