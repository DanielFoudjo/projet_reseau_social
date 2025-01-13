import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
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
              backgroundImage: AssetImage(''), // Remplacez par l'image souhaitée
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Username",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Online",
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
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                buildMessageBubble("Hello! How are you?", true),
                buildMessageBubble("I'm good, thanks! 😊", false),
                buildMessageBubble("What about you?", false),
                buildMessageBubble("I'm doing great, thank you! ❤️", true),
                buildMessageBubble("Let's meet later?", true),
              ],
            ),
          ),
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
              decoration: InputDecoration(
                hintText: "Type a message",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
