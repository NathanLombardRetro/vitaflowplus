import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitaflowplus/ui/bloodsugar/viewbloodsugar/viewbloodsugar_page.dart';
import 'package:vitaflowplus/ui/healthpage/viewhealth/viewhealth_page.dart';
import 'package:vitaflowplus/ui/workouts/workout/workouts.dart';

class Dashboard extends StatefulWidget {
   Dashboard({super.key});

  @override
  State<Dashboard> createState() => _MyWidgetState();
}

void signUserOut(){
  FirebaseAuth.instance.signOut();
}

class _MyWidgetState extends State<Dashboard> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<DocumentSnapshot> getUserData() async {
    final userUID = user.uid;
    return await FirebaseFirestore.instance.collection('users').doc(userUID).get();
    }

  void _showPopupMenu(BuildContext context) async {
  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(100, 100, 0, 0),
    items: [
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
            signUserOut();
            Navigator.pop(context);
          },
        ),
      ),
    ],
    elevation: 8.0,
  );
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
                    signUserOut();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Placeholder(
                fallbackHeight: 200, // Placeholder for graph
              ),
              SizedBox(height: 16),
              Text(
                "Current Sugar Reading:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Placeholder Value", // Replace with actual sugar reading
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Carbs",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Placeholder Value", // Replace with actual carbs value
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Water Intake",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Placeholder Value", // Replace with actual water intake value
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Last Workout",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Placeholder Value", // Replace with actual last workout value
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sleep Time",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Placeholder Value", // Replace with actual sleep time value
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {}, // Placeholder function for home action
              icon: Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkoutsPage()),
                );
              },
              icon: Icon(Icons.fitness_center),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GraphPage()),
                );
              },
              icon: Icon(Icons.favorite),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SleepWaterPage()),
                );
              },
              icon: Icon(Icons.local_hospital),
            ),
          ],
        ),
      ),
    );
  }
}
