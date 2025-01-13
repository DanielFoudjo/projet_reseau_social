import 'package:flutter/material.dart';
import 'package:projet_reseau_social/models/post_model.dart';
import 'package:projet_reseau_social/models/user_model.dart';
import '../services/post_service.dart';
import '../utils/navigation.dart';
import '../utils/user.dart';
import 'chat_screen.dart';

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
      List<Post> fetchedPosts = await PostService().fetchPosts(userId);
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print("Erreur lors du chargement des posts : $e");
    }
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
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Avatars Section
          Container(
            height: 100,
            color: Colors.white,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: 10, // Replace with dynamic count
              separatorBuilder: (context, index) => SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        "https://via.placeholder.com/150", // Replace with dynamic URL
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "User $index", // Replace with dynamic username
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 10),
          // Posts Feed
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: posts.length, // Replace with dynamic post count
              itemBuilder: (context, index) {
                final post = posts[index];
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
                            userAvatarUrl ?? "", // Replace with dynamic URL
                          ),
                        ),
                        title: Text(
                          userName, // Replace with dynamic username
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(post.createdAt.timeZoneOffset.toString() + "ago"), // Replace with dynamic timestamp
                        trailing: Icon(Icons.more_vert),
                      ),
                      // Post Image
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
                                  icon: Icon(Icons.favorite_border),
                                  onPressed: () {},
                                ),
                                SizedBox(width: 5),
                                Text(post.likeCount.toString()), // Replace with dynamic like count
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.comment),
                                  onPressed: () {},
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
