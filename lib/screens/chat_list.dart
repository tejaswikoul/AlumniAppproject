import 'package:demo_alumnet/components/my_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_alumnet/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({Key? key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Remove the IconButton for notifications
      ),
      body: _buildUserList(),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['username']) {
      return ListTile(
        contentPadding: EdgeInsets.all(10.0),
        leading: const Icon(
          Icons.person,
          size: 50.0,
          color: Colors.black,
        ),
        title: Text(data['username']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['username'],
                receiverUserid: data['uid'],
              ),
            ),
          );
        },
        trailing: const Icon(
          Icons.chat,
          size: 40.0,
          color: Colors.blue,
        ),
      );
    } else {
      return Container();
    }
  }
}
