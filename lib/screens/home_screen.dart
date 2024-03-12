import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_alumnet/components/my_bottom_navbar.dart';
import 'package:demo_alumnet/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String appTitle = "VESlumni";
  late String _userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto', // Use Roboto font family
          ),
        ),
        // Remove the IconButton for notifications
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No posts available.'),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!.docs.map((DocumentSnapshot post) {
                  return PostWidget(post: post, userId: _userId);
                }).toList(),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}

class PostWidget extends StatefulWidget {
  final DocumentSnapshot post;
  final String userId;

  const PostWidget({Key? key, required this.post, required this.userId})
      : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.post.data() as Map<String, dynamic>;
    String postText = data['text'];
    String postImage = data['imagePath'] ?? '';
    String postUserId = data['userId'];
    int likesCount = data['likesCount'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/default_profile_image.png'),
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FutureBuilder(
                future: _getUsername(postUserId),
                builder: (context, AsyncSnapshot<String> usernameSnapshot) {
                  if (usernameSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const LinearProgressIndicator();
                  }

                  if (usernameSnapshot.hasError) {
                    return Text('Error: ${usernameSnapshot.error}');
                  }

                  return Text(
                    '${usernameSnapshot.data}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (postImage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                postImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 8.0, 24.0, 16),
          child: Text(
            postText,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto', // Use Roboto font family
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _toggleLike(widget.post.reference);
                    },
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_outline,
                      size: 24,
                      color: isLiked ? Colors.red : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$likesCount likes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  void _toggleLike(DocumentReference postRef) {
    setState(() {
      isLiked = !isLiked;
    });

    postRef.update({
      'likesCount':
          isLiked ? FieldValue.increment(1) : FieldValue.increment(-1),
    });
  }

  Future<String> _getUsername(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userSnapshot['username'];
    } catch (e) {
      print('Error fetching username: $e');
      return '';
    }
  }
}
