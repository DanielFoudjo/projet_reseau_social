import 'package:flutter/material.dart';
import '../utils/navigation.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("https://via.placeholder.com/50"),
            ),
            title: Text("User $index liked your post."),
            subtitle: Text("2 hours ago"),
          );
        },
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}
