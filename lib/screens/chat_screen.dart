import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../utils/user.dart';

class ChatScreen extends StatefulWidget {
  final String currentUser; // L'utilisateur actuel
  final String chatWithUser; // L'utilisateur avec qui discuter
  final String chatRoomId; // L'identifiant de la salle de chat

  ChatScreen({
    required this.currentUser,
    required this.chatWithUser,
    required this.chatRoomId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String profile = '';


  @override
  void initState() {
    super.initState();
    _loadUserName(); // Charger les données utilisateur au démarrage
  }


  Future<void> _loadUserName() async { 
    UserModel? userData = await GetUserDataFromFirestore.getOneUser(widget.chatWithUser); // Appel de la méthode dans user_service.dart
      if (userData != null){
      setState(() {
        profile = userData.avatarUrl ?? '';
        
      });
    }
  }



  void sendMessage() {
    String messageContent = _messageController.text.trim();
    if (messageContent.isNotEmpty) {
      _firestore.collection('messages').add({
        'chatRoomId': widget.chatRoomId,
        'from': widget.currentUser,
        'to': widget.chatWithUser,
        'contents': messageContent,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profile), // Remplace par l'image de l'utilisateur
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatWithUser, // Nom de l'utilisateur avec qui discuter
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Online", // Tu peux intégrer le statut en ligne ici
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Liste des messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('chatRoomId', isEqualTo: widget.chatRoomId)
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Pas encore de messages."));
                }

                List<DocumentSnapshot> docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    bool isSentByMe = data['from'] == widget.currentUser;

                    return buildMessageBubble(data['contents'], isSentByMe);
                  },
                );
              },
            ),
          ),
          // Barre d'entrée du message
          buildInputBar(),
        ],
      ),
    );
  }

  Widget buildMessageBubble(String message, bool isSentByMe) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        constraints: BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blue.shade100 : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(isSentByMe ? 15 : 0),
            bottomRight: Radius.circular(isSentByMe ? 0 : 15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSentByMe ? Colors.black : Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget buildInputBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.blue),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Tapez un message...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}