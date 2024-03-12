import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  File? _image;
  final TextEditingController _textEditingController = TextEditingController();
  String? _userId; // Variable to store the current user's ID

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  // Function to get the current user's ID
  void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  Future<void> _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _uploadPost() async {
    try {
      String text = _textEditingController.text.trim();

      if (_image == null) {
        // Show an error message because image is mandatory
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image.'),
          ),
        );
        return;
      }

      String imagePath = "";
      String postId = DateTime.now().millisecondsSinceEpoch.toString();

      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(
                'images/$postId',
              );
      firebase_storage.UploadTask uploadTask =
          storageReference.putFile(_image!);

      await uploadTask.whenComplete(() async {
        imagePath = await storageReference.getDownloadURL();
      });

      // Fetch the username from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users') // Update this to your users collection
          .doc(_userId)
          .get();
      String username = userSnapshot['username'];

      // Add the postId, userId, and username to the post data
      await FirebaseFirestore.instance.collection('posts').add({
        'postId': postId,
        'userId': _userId,
        'username': username, // Use the fetched username
        'text': text,
        'imagePath': imagePath,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context); // Close the post page after posting
    } catch (e) {
      print("Error uploading post: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _uploadPost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _textEditingController,
              decoration:
                  const InputDecoration(labelText: 'Write something...'),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            _image != null
                ? Image.file(_image!, height: 150)
                : const SizedBox.shrink(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getImage,
              child: const Text('Select Image'),
            ),
          ],
        ),
      ),
    );
  }
}
