import 'package:demo_alumnet/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String uid;
  String username;
  String bio;

  Member({
    required this.uid,
    required this.username,
    required this.bio,
  });
}

class AllMembersWidget extends StatelessWidget {
  const AllMembersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllMembers(),
      builder: (context, AsyncSnapshot<List<Member>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Member> members = snapshot.data!;
          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              Member member = members[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to UserProfilePage with the selected user's uid
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(uid: member.uid),
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.person_4_sharp,
                    size: 50.0,
                    color: Colors.black,
                  ),
                  title: Text(member.username),
                  subtitle: Text("   - ${member.bio}"),
                  // trailing: const Icon(
                  //   Icons.chat,
                  //   size: 40.0,
                  //   color: Colors.blue,
                  // )
                ),
              );
            },
          );
        }
      },
    );
  }
}

Future<List<Member>> getAllMembers() async {
  QuerySnapshot<Map<String, dynamic>> membersSnapshot =
      await FirebaseFirestore.instance.collection('users').get();

  List<Member> members = [];

  for (QueryDocumentSnapshot<Map<String, dynamic>> doc
      in membersSnapshot.docs) {
    members.add(Member(
      uid: doc.id,
      username: doc['username'],
      bio: doc['bio'],
    ));
  }

  return members;
}
