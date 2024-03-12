import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Notification 1
          _buildNotificationItem(
            "You have a new connection request from Rahul Singh.",
            "2 hours ago",
          ),

          // Notification 2
          _buildNotificationItem(
            "Rahul Singh liked your post.",
            "Yesterday",
          ),

          // Notification 3
          _buildNotificationItem(
            "Pranjal commented on your article.",
            "3 days ago",
          ),

          // Add more notifications as needed
          _buildNotificationItem(
            "Rahul Singh mentioned you in a comment.",
            "4 days ago",
          ),

          _buildNotificationItem(
            "Rahul Singh shared a post with you.",
            "5 days ago",
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String time) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.purple,
        child: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(time),
    );
  }
}
