import 'package:flutter/material.dart';
import 'package:projet_reseau_social/models/post_model.dart';
import 'package:projet_reseau_social/models/user_model.dart';
import '../services/post_service.dart';
import '../utils/navigation.dart';
import '../utils/user.dart';
import 'chat_screen.dart';
import 'discussions_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  List<Post> posts = []; // Liste des posts
  String userName = "Home"; // Variable pour stocker le nom de l'utilisateur
  String userId = '';
  String? userAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Charger les données utilisateur au démarrage
    _fetchPosts();
  }

  // Méthode pour charger les posts à partir de Firestore

  

  Future<void> _loadUserName() async { 
    UserModel? userData = await GetUserDataFromFirestore.getUserData(); // Appel de la méthode dans user_service.dart
      if (userData != null){
      setState(() {
        userName = userData.name;
        userId = userData.id; // Récupérer l'ID de l'utilisateur
        userAvatarUrl = userData.avatarUrl; // Récupérer l'URL de l'avatar de l'utilisateur
      });
    }
    await _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      List<Post> fetchedPosts = await PostService().fetchPosts();
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print("Erreur lors du chargement des posts : $e");
    }
  }

  Future<void> _handleLike(Post post) async {
    try {
      bool isLiked = post.likedBy.contains(userId);
      await PostService().likePost(post.id ?? '', userId, isLiked);
      setState(() {
        // Mettre à jour localement les données du post
        if (isLiked) {
          post.likedBy.remove(userId);
          post.likeCount -= 1;
        } else {
          post.likedBy.add(userId);
          post.likeCount += 1;
        }
      });
    } catch (e) {
      print("Erreur lors de l'ajout du like : $e");
    }
  }

  void _showCommentDialog(String postId) {
  TextEditingController commentController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Ajouter un commentaire"),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(hintText: "Écris ton commentaire..."),
          maxLines: null, // Permet plusieurs lignes
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer la boîte de dialogue
            },
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              String content = commentController.text.trim();
              if (content.isNotEmpty) {
                // Appeler la méthode du service pour ajouter un commentaire
                await PostService().addComment(postId, userId, userName, content);
                Navigator.pop(context); // Fermer la boîte de dialogue après l'envoi
                setState(() {
                
                }); // Recharger les posts pour afficher le nouveau commentaire
              }
            },
            child: Text("Envoyer"),
          ),
        ],
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          // "Home",
          userName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.message, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(currentUser: userName,)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Avatars Section
          // Container(
          //   height: 100,
          //   color: Colors.white,
          //   child: ListView.separated(
          //     scrollDirection: Axis.horizontal,
          //     padding: EdgeInsets.symmetric(horizontal: 10),
          //     itemCount: 10, // Replace with dynamic count
          //     separatorBuilder: (context, index) => SizedBox(width: 10),
          //     itemBuilder: (context, index) {
          //       // return Column(
          //       //   children: [
          //       //     CircleAvatar(
          //       //       radius: 30,
          //       //       backgroundImage: NetworkImage(
          //       //         "https://via.placeholder.com/150", // Replace with dynamic URL
          //       //       ),
          //       //     ),
          //       //     SizedBox(height: 5),
          //       //     Text(
          //       //       "User $index", // Replace with dynamic username
          //       //       style: TextStyle(fontSize: 12),
          //       //     ),
          //       //   ],
          //       // );
          //     },
          //   ),
          // ),
          SizedBox(height: 10),
          // Posts Feed
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: posts.length, // Replace with dynamic post count
              itemBuilder: (context, index) {
                final post = posts[index];
                bool isLiked = post.likedBy.contains(userId);
                return Card(
                  margin: EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info Row
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            post.ownerAvatar, // Replace with dynamic URL
                          ),
                        ),
                        title: Text(
                          post.ownerUsername, // Replace with dynamic username
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("posté le " + post.createdAt.toString()), // Replace with dynamic timestamp
                        trailing: Icon(Icons.more_vert),
                      ),
                      // Post Image
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: Text(
                          post.content ?? '', // Remplacez par le message du post
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(
                              post.imageUrl ?? '', // Replace with dynamic image URL
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Post Actions
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () {
                                    _handleLike(post);
                                  },
                                ),
                                SizedBox(width: 5),
                                Text(post.likeCount.toString()), // Replace with dynamic like count
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.comment),
                                  onPressed: () {
                                    _showCommentDialog(post.id!);
                                  },
                                ),
                                SizedBox(width: 5),
                                Text(post.commentsCount.toString()), // Replace with dynamic comment count
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}