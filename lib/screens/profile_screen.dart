import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/navigation.dart';

class ProfileScreen extends StatelessWidget {
  final String userId; // ID de l'utilisateur

  ProfileScreen({required this.userId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Aucun profil trouvé."));
          }

          // Données de l'utilisateur
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String profileImage = userData['avatarUrl'] ?? "https://via.placeholder.com/150";
          String userName = userData['username'] ?? "Nom d'utilisateur";
          String bio = userData['bio'] ?? "Pas de bio";

          return Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImage),
              ),
              SizedBox(height: 10),
              Text(userName, style: TextStyle(fontSize: 18)),
              SizedBox(height: 5),
              Text(bio, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigation vers la page d'édition
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfileScreen(userId: userId)),
                  );
                },
                child: Text("Edit Profile"),
              ),
              SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('posts')
                      .where('userId', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, postSnapshot) {
                    if (postSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!postSnapshot.hasData || postSnapshot.data!.docs.isEmpty) {
                      return Center(child: Text("Aucune publication trouvée."));
                    }

                    var posts = postSnapshot.data!.docs;

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        var post = posts[index].data() as Map<String, dynamic>;
                        String postImage = post['imageUrl'] ?? "https://via.placeholder.com/150";

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            image: DecorationImage(
                              image: NetworkImage(postImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  final String userId;

  EditProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Center(child: Text("Page d'édition de profil")),
    );
  }
}
