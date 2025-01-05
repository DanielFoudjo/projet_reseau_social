import 'package:flutter/material.dart';

class CreatePostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(child: Text("Upload your content here.")),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Write a caption...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Post creation logic
              },
              child: Text("Post"),
            ),
          ],
        ),
      ),
    );
  }
}
