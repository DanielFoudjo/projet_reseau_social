import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'feed_screen.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
   
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  TextEditingController username0 = TextEditingController();
  TextEditingController password0 = TextEditingController();
  TextEditingController email0 = TextEditingController();
  TextEditingController bio0 = TextEditingController();
  TextEditingController avatarUrl0 = TextEditingController();

  TextEditingController email1 = TextEditingController();
  TextEditingController password1 = TextEditingController();
  
  

  final AuthService authService = AuthService();

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  File? _selectedImage; // To store the selected image file

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      await _uploadAndSetAvatarUrl(_selectedImage!);
    }
  }


  Future<void> _uploadAndSetAvatarUrl(File imageFile) async {
    try {
      String fileName = "/avatars/${DateTime.now().millisecondsSinceEpoch}.png";
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Set the URL in the controller
      avatarUrl0.text = downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Failed to upload image");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              // Title
              Text(
                "Login/Register",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30),
              // Login and Sign Up buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        String email10 = email1.text;
                        String password10 = password1.text;
                        User? user = await authService.login(email10, password10);
                        if (user != null) {
                          // Si l'inscription réussit, naviguer vers FeedScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => FeedScreen()),
                          );
                        } else {
                          // Optionnel : afficher une erreur si l'inscription échoue
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Connexion échouée. Veuillez réessayer.")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 50),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Login"),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Inscription'),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // Champs du formulaire d'inscription
                                    TextField(
                                      controller: username0,
                                      decoration: InputDecoration(
                                        labelText: 'Nom',
                                      ),
                                    ),
                                    TextField(
                                      controller: email0,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                      ),
                                    ),
                                    TextField(
                                      controller: password0,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: 'Mot de passe',
                                      ),
                                    ),
                                    TextField(
                                      controller: bio0,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: 'Ajouter une bio',
                                      ),
                                    ),

                                    SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.blue.shade100,
                                      backgroundImage: _selectedImage != null
                                          ? FileImage(_selectedImage!)
                                          : null,
                                      child: _selectedImage == null
                                          ? Icon(
                                              Icons.add_a_photo,
                                              size: 30,
                                              color: Colors.blue,
                                            )
                                          : null,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Appuyez pour sélectionner une image",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(height: 10),
                                  // Avatar URL Field (read-only)
                                  TextField(
                                    controller: avatarUrl0,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: "URL de l'avatar",
                                      prefixIcon:
                                          Icon(Icons.link, color: Colors.blue),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                    // Vous pouvez ajouter d'autres champs
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: ()  async {
                                    String email = email0.text;
                                    String password = password0.text;
                                    String username = username0.text;
                                    String bio = bio0.text;
                                    String avatarUrl = avatarUrl0.text;
                                    User? user = await authService.signup(email, password, username, bio, avatarUrl);

                                    if (user != null) {
                                      // Si l'inscription réussit, naviguer vers FeedScreen
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => FeedScreen()),
                                      );
                                    } else {
                                      // Optionnel : afficher une erreur si l'inscription échoue
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Inscription échouée. Veuillez réessayer.")),
                                      );
                                    }
                                  },
                                  child: Text('S\'inscrire'),
                                ),
                              ],
                            );
                          },
                        );},
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 50),
                        backgroundColor: Colors.blue.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Email field
              TextField(
                controller: email1,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Password field
              TextField(
                controller: password1,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Password recovery
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Password Recovery",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 30),
              // Social Media buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook, color: Colors.red),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.apple, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
