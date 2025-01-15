import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../screens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  final String currentUser;

  HomeScreen({required this.currentUser});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ChatService _chatService = ChatService();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversations"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un utilisateur...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Liste des utilisateurs trouvés
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatService.getUsers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<Map<String, dynamic>> users = snapshot.data!;
                List<Map<String, dynamic>> filteredUsers = users.where((user) {
                  return user['username']
                      .toString()
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return ListTile(
                      title: Text(user['username']),
                      subtitle: Text(user['email']),
                      onTap: () {
                        final chatRoomId = _chatService.generateChatRoomId(
                          widget.currentUser,
                          user['username'],
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              currentUser: widget.currentUser,
                              chatWithUser: user['username'],
                              chatRoomId: chatRoomId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
