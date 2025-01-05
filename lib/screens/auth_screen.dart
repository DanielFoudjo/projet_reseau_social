import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/signup.dart';

class AuthScreen extends StatelessWidget {

  TextEditingController username0 = TextEditingController();
  TextEditingController password0 = TextEditingController();
  TextEditingController email0 = TextEditingController();
  
  

  final AuthService authService = AuthService();


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
                        String email = email0.text;
                        String password = password0.text;
                        String username = username0.text;
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => signup(email,password,username)), // Assurez-vous que LoginScreen() est défini dans login.dart
                        // );
                        User? user = await authService.signup(email, password, username);
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
                                  onPressed: () {
                                    // Logique d'inscription
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
