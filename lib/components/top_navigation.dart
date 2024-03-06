import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitaflowplus/ui/login/auth_page.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/default.png'),
          radius: 16,
        ),
      ),
      title: FutureBuilder<DocumentSnapshot>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final firstName = userData['firstName'];
            final lastName = userData['lastName'];
            return Text('$firstName $lastName');
          }
        },
      ),
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.settings),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  signUserOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<DocumentSnapshot> getUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userUID = user.uid;
    return await FirebaseFirestore.instance.collection('users').doc(userUID).get();
  }
}