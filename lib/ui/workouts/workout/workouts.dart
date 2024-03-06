import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitaflowplus/models/workout_model.dart';
import 'package:vitaflowplus/ui/workouts/addWorkout/addWorkout.dart';

class WorkoutsPage extends StatefulWidget {
  @override
  _WorkoutsPageState createState() => _WorkoutsPageState();
}


class _WorkoutsPageState extends State<WorkoutsPage> {
  List<Workout> workouts = [];
  final user = FirebaseAuth.instance.currentUser!;

  Future<List<Workout>> fetchWorkouts(String userId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('workouts')
        .where('userId', isEqualTo: userId)
        .get();

    List<Workout> fetchedWorkouts = querySnapshot.docs.map((doc) {
      return Workout(
        workoutName: doc['workoutName'],
        workoutDescription: doc['workoutDescription'],
        timeTrained: doc['timeTrained'],
        exercises: List<String>.from(doc['exercises']),
        userId: doc['userId'],
        date: doc['date'].toDate(),
      );
    }).toList();

    return fetchedWorkouts;
  } catch (error) {
    print("Error fetching workouts: $error");
    throw error;
  }
}

  void _viewStats(Workout workout) {
    print("Viewing stats for ${workout.workoutName}");
  }

  void _uploadWorkout() {
    print("Navigating to upload workout page");
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workouts"),
      ),
      body: FutureBuilder<List<Workout>>(
        future: fetchWorkouts(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final workouts = snapshot.data!;
            return ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (BuildContext context, int index) {
                final workout = workouts[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(workout.workoutName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Time Trained: ${workout.timeTrained}"),
                        Text("workoutDescription: ${workout.workoutDescription}"),
                        Text("Exercises: ${workout.exercises.join(", ")}"),
                      ],
                    ),
                    onTap: () {
                      // Handle tap on workout
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWorkoutPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}