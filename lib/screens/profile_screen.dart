import 'package:flutter/material.dart';
import '../utils/navigation.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://via.placeholder.com/150"),
          ),
          SizedBox(height: 10),
          Text("User Name", style: TextStyle(fontSize: 18)),
          SizedBox(height: 5),
          Text("Bio here...", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: Text("Edit Profile")),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[300],
                  margin: EdgeInsets.all(2),
                  child: Center(child: Text("Post $index")),
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
