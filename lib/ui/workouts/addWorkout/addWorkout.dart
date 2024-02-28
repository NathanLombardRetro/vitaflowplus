import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddWorkoutPage extends StatefulWidget{
  AddWorkoutPage({super.key});

  @override
  State <AddWorkoutPage> createState() => _MyAddWorkoutState();
}

class _MyAddWorkoutState extends State<AddWorkoutPage>
{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();


  final user = FirebaseAuth.instance.currentUser!;

  Future<DocumentSnapshot> getUserData() async {
    final userUID = user.uid;
    return await FirebaseFirestore.instance.collection('users').doc(userUID).get();
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/default.png'), // Placeholder image
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
                    // Add functionality for settings
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}