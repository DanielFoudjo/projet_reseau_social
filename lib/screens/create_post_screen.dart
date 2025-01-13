import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../services/post_service.dart';
import '../utils/user.dart';
import '../utils/navigation.dart';

class CreatePostScreen extends StatefulWidget {
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  String? profile;
  String idUser = '';

  File? _selectedImage; // To store the selected image file
  TextEditingController postContent = TextEditingController();
  TextEditingController imageUrl = TextEditingController();

  // Fonction pour sélectionner un média (image ou vidéo)
  // Function to pick an image from the gallery
  Future<void> _addMedia() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      await _uploadAndSetAvatarUrl(_selectedImage!);
    }
  }


  Future<void> _uploadAndSetAvatarUrl(File imageFile) async {
    try {
      String fileName = "/posts/${DateTime.now().millisecondsSinceEpoch}.png";
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Set the URL in the controller
      imageUrl.text = downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Failed to upload image");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Charger les données utilisateur au démarrage
  }


  Future<void> _loadUserName() async { 
    UserModel? userData = await GetUserDataFromFirestore.getUserData(); // Appel de la méthode dans user_service.dart
      if (userData != null){
      setState(() {
        profile = userData.avatarUrl;
        idUser = userData.id;
        print(profile);
      });
    }
  }


  // Fonction pour supprimer le média sélectionné
  void removeMedia() {
    setState(() {
      _selectedImage = null;
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Create Post",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Zone de profil et zone de texte
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                radius: 24,
                backgroundImage: profile != null
                    ? NetworkImage(profile!) // Charge l'image depuis l'URL si disponible
                    : AssetImage('assets/default_avatar.png') as ImageProvider, // Image par défaut si aucune URL n'est disponible
              ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: postContent,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "What’s on your mind?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Zone de prévisualisation du média
          if (_selectedImage != null)
            Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: removeMedia,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 12,
                        child: Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 10),
          // Section Ajouter une photo ou une vidéo
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: InkWell(
              onTap: _addMedia,
              child: Row(
                children: [
                  Icon(Icons.photo_library, color: Colors.blue, size: 30),
                  SizedBox(width: 10),
                  Text(
                    _selectedImage == null
                        ? "Add Photo/Video"
                        : "Replace Photo/Video",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          // Section Ajouter d'autres détails
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.tag, color: Colors.grey),
                    SizedBox(width: 10),
                    Text("Tag People"),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey),
                    SizedBox(width: 10),
                    Text("Add Location"),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Icon(Icons.emoji_emotions, color: Colors.grey),
                    SizedBox(width: 10),
                    Text("Feeling/Activity"),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          // Bouton Publier
          Container(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                String postContent1 = postContent.text;
                String imageUrl1 = imageUrl.text;
                if (postContent1.isEmpty && imageUrl1.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Veillez mettre du contenu ou un media")),
                  );
                }else{
                  // Envoi du post à Firebase
                  // Send the post to Firebase
                  PostService().createPost(idUser, postContent1, imageUrl1);
                  postContent.clear();
                  imageUrl.clear();
                  removeMedia();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Post publié avec succès")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Post",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}
