import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AddWorkoutPage extends StatefulWidget{
  AddWorkoutPage({super.key});

  @override
  State <AddWorkoutPage> createState() => _MyAddWorkoutState();
}

class _MyAddWorkoutState extends State<AddWorkoutPage>
{
  final TextEditingController _workoutNameController = TextEditingController();
  final TextEditingController _timeTrainedController = TextEditingController();
  final TextEditingController _workoutDescriptionController = TextEditingController();
  final TextEditingController _exercisesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;

  Future<DocumentSnapshot> getUserData() async {
    final userUID = user.uid;
    return await FirebaseFirestore.instance.collection('users').doc(userUID).get();
    }

    Future<void> _addWorkout() async {
  try {
    // Get user ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    String workoutName = _workoutNameController.text;
    String timeTrained = _timeTrainedController.text;
    String workoutDescription = _workoutDescriptionController.text;
    List<String> exercises = _exercisesController.text.split(',');

    String workoutId = Uuid().v4();

    await FirebaseFirestore.instance.collection('workouts').doc(workoutId).set({
      'userId': userId,
      'workoutName': workoutName,
      'timeTrained': timeTrained,
      'workoutDescription': workoutDescription,
      'exercises': exercises,
      'date': DateTime.now(),
    });

    print('Workout added successfully');
    Navigator.pop(context);
  } catch (e) {
    print('Failed to add workout: $e');
  }
}


    @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
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
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Workout',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _workoutNameController,
                  decoration: InputDecoration(labelText: 'Workout Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a workout name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _timeTrainedController,
                  decoration: InputDecoration(labelText: 'Time Trained'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the time trained';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _workoutDescriptionController,
                  decoration: InputDecoration(labelText: 'Workout Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a workout description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _exercisesController,
                  decoration: InputDecoration(labelText: 'Exercises (comma-separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one exercise';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addWorkout();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}