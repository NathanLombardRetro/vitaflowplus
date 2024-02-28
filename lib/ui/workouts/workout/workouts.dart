import 'package:flutter/material.dart';
import 'package:vitaflowplus/ui/workouts/addWorkout/addWorkout.dart';

class Workout {
  final String name;
  final String description;
  final String timeTrained;
  final List<String> exercises;

  Workout({
    required this.name,
    required this.description,
    required this.timeTrained,
    required this.exercises,
  });
}


class WorkoutsPage extends StatefulWidget {
  @override
  _WorkoutsPageState createState() => _WorkoutsPageState();
}


class _WorkoutsPageState extends State<WorkoutsPage> {
  // Example list of workouts
  List<Workout> workouts = [
    Workout(
      name: "Workout 1",
      description: "This was a full-body workout.",
      timeTrained: "45 minutes",
      exercises: ["Push-ups", "Squats", "Lunges", "Planks"],
    ),
    Workout(
      name: "Workout 2",
      description: "Focused on upper body strength.",
      timeTrained: "60 minutes",
      exercises: ["Push-ups", "Pull-ups", "Bench press"],
    ),
    Workout(
      name: "Workout 3",
      description: "Leg day!",
      timeTrained: "50 minutes",
      exercises: ["Squats", "Deadlifts", "Leg press"],
    ),
    Workout(
      name: "Workout 4",
      description: "Core workout.",
      timeTrained: "40 minutes",
      exercises: ["Planks", "Crunches", "Russian twists"],
    ),
    // Add more workouts as needed
  ];

  // Method to navigate to the workout stats page
  void _viewStats(Workout workout) {
    // Replace this with navigation to the stats page
    print("Viewing stats for ${workout.name}");
  }

  // Method to navigate to the upload workout page
  void _uploadWorkout() {
    // Replace this with navigation to the upload workout page
    print("Navigating to upload workout page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workouts"),
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (BuildContext context, int index) {
          final workout = workouts[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(workout.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Time Trained: ${workout.timeTrained}"),
                  Text("Description: ${workout.description}"),
                  Text("Exercises: ${workout.exercises.join(", ")}"),
                ],
              ),
              onTap: () => _viewStats(workout),
            ),
          );
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