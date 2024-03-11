import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitaflowplus/components/bottom_navigation.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:vitaflowplus/models/workout_model.dart';
import 'package:vitaflowplus/services/firebaseFunctions.dart';
import 'package:vitaflowplus/ui/bloodsugar/viewbloodsugar/viewbloodsugar_page.dart';
import 'package:vitaflowplus/ui/dashboard/dashboard_page.dart';
import 'package:vitaflowplus/ui/healthpage/viewhealth/viewhealth_page.dart';
import 'package:vitaflowplus/ui/workouts/addWorkout/addWorkout.dart';

class WorkoutsPage extends StatefulWidget {
  @override
  _WorkoutsPageState createState() => _WorkoutsPageState();
}


class _WorkoutsPageState extends State<WorkoutsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  void _viewStats(Workout workout) {
    print("Viewing stats for ${workout.workoutName}");
  }

  void _uploadWorkout() {
    print("Navigating to upload workout page");
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(),
    ),
      body: FutureBuilder<List<Workout>>(
        future: FirebaseFunctions.fetchLatestWorkouts(user.uid),
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
    final workout = workouts.reversed.toList()[index];
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          workout.workoutName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Time Trained: ${workout.timeTrained}", style: TextStyle(fontSize: 16)),
            Text("Description: ${workout.workoutDescription}", style: TextStyle(fontSize: 16)),
            Text("Exercises: ${workout.exercises.join(", ")}", style: TextStyle(fontSize: 16)),
          ],
        ),
        onTap: () => _viewStats(workout),
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
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1,
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
          }
          if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => GraphPage()));
          }
          if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SleepWaterPage()));
          }
        },
      ),
    );
  }
}