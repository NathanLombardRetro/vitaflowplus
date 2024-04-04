import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vitaflowplus/ui/workouts/workout/workouts.dart';

class AddWorkoutPage extends StatefulWidget {
  AddWorkoutPage({super.key});

  @override
  State<AddWorkoutPage> createState() => _MyAddWorkoutState();
}

class _MyAddWorkoutState extends State<AddWorkoutPage> {
  final TextEditingController _workoutNameController = TextEditingController();
  final TextEditingController _timeTrainedController = TextEditingController();
  final TextEditingController _workoutDescriptionController =
      TextEditingController();
  final TextEditingController _exercisesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;

  Future<DocumentSnapshot> getUserData() async {
    final userUID = user.uid;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .get();
  }

  Future<void> _addWorkout() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      String workoutName = _workoutNameController.text;
      String timeTrained = _timeTrainedController.text;
      String workoutDescription = _workoutDescriptionController.text;
      List<String> exercises = _exercisesController.text.split(',');

      String workoutId = Uuid().v4();

      await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .set({
        'userId': userId,
        'workoutName': workoutName,
        'timeTrained': timeTrained,
        'workoutDescription': workoutDescription,
        'exercises': exercises,
        'date': DateTime.now(),
      });

      print('Workout added successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WorkoutsPage()),
      );
    } catch (e) {
      print('Failed to add workout: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  ThemeData currentTheme = ThemeProvider.themeOf(context).data;
  return Scaffold(
    backgroundColor: currentTheme.primaryColor,
    body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: currentTheme.primaryColor,
                    foregroundColor: Color(0xFF26547C),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: currentTheme.primaryColor, width: 0),
                    ),
                    child: Icon(Icons.arrow_back),
                  ),
                  Text(
                    'Add Workout',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: currentTheme.primaryColorLight),
                  ),
                  SizedBox(width: 56),
                ],
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                        controller: _workoutNameController,
                        style: TextStyle(color: currentTheme.primaryColorLight),
                        decoration: InputDecoration(
                          labelText: 'Workout Name',
                          labelStyle:
                              TextStyle(color: currentTheme.primaryColorLight),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a workout name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _timeTrainedController,
                        style: TextStyle(color: currentTheme.primaryColorLight),
                        decoration: InputDecoration(
                          labelText: 'Time Trained',
                          labelStyle:
                              TextStyle(color: currentTheme.primaryColorLight),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the time trained';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _workoutDescriptionController,
                        style: TextStyle(color: currentTheme.primaryColorLight),
                        decoration: InputDecoration(
                          labelText: 'Workout Description',
                          labelStyle:
                              TextStyle(color: currentTheme.primaryColorLight),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a workout description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _exercisesController,
                        style: TextStyle(color: currentTheme.primaryColorLight),
                        decoration: InputDecoration(
                          labelText: 'Exercises (comma-separated)',
                          labelStyle:
                              TextStyle(color: currentTheme.primaryColorLight),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF26547C)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter at least one exercise';
                          }
                          return null;
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addWorkout();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF26547C)),
                  foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 253, 253, 252)),
                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 14)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Color(0xFF26547C)),
                    ),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
