import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 253, 252),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 0.0),
            child: Text(
              "My workouts",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Workout>>(
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
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Card(
                          elevation: 5,
                          color: Color(0xFF26547C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              workout.workoutName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 253, 253, 252)),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 18,
                                        color: Color.fromARGB(
                                                255, 253, 253, 252)
                                            .withOpacity(0.9)), // Add time icon
                                    SizedBox(width: 5),
                                    Text("Time Trained: ${workout.timeTrained}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                    255, 253, 253, 252)
                                                .withOpacity(0.9))),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.description,
                                        size: 18,
                                        color:
                                            Color.fromARGB(255, 253, 253, 252)
                                                .withOpacity(0.9)),
                                    SizedBox(width: 5),
                                    Text(
                                        "Description: ${workout.workoutDescription}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                    255, 253, 253, 252)
                                                .withOpacity(0.9))),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.fitness_center,
                                        size: 18,
                                        color:
                                            Color.fromARGB(255, 253, 253, 252)
                                                .withOpacity(0.9)),
                                    SizedBox(width: 5),
                                    Text(
                                        "Exercises: ${workout.exercises.join(", ")}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                    255, 253, 253, 252)
                                                .withOpacity(0.9))),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.date_range,
                                        size: 18,
                                        color:
                                            Color.fromARGB(255, 253, 253, 252)
                                                .withOpacity(0.9)),
                                    SizedBox(width: 5),
                                    Text(
                                        "Date: ${DateFormat.yMMMMd().format(workout.date)}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                    255, 253, 253, 252)
                                                .withOpacity(0.9))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 5.0, right: 5.0),
        child: SizedBox(
          width: 100,
          height: 30,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddWorkoutPage()),
              );
            },
            backgroundColor: Color.fromARGB(255, 253, 253, 252),
            foregroundColor: Color(0xFF26547C),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Color(0xFF26547C), width: 1),
            ),
            child: Text(
              "Add workout",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1,
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          }
          if (index == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => GraphPage()));
          }
          if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SleepWaterPage()));
          }
        },
      ),
    );
  }
}
