import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DeviceScannerPage extends StatefulWidget {
    DeviceScannerPage ({super.key});

  @override
  _DeviceScannerPageState createState() => _DeviceScannerPageState();
}

class _DeviceScannerPageState extends State<DeviceScannerPage> {

  final user = FirebaseAuth.instance.currentUser!;

  TextEditingController bloodSugarController = TextEditingController();
  TextEditingController lastMealController = TextEditingController();
  TextEditingController insulinDoseController = TextEditingController();
  TextEditingController insulinTypeController = TextEditingController();
  TextEditingController moodController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _addWorkout() async {
  try {
    String bloodSugar = bloodSugarController.text;
    String lastMeal = lastMealController.text;
    String insulinType = insulinTypeController.text;
    String insulinDose = insulinDoseController.text;
    String mood = moodController.text;

    String sugarLevelid = Uuid().v4();

    await FirebaseFirestore.instance.collection('sugarLevels').doc(sugarLevelid).set({
      'userId': user.uid,
      'bloodSugar': bloodSugar,
      'lastMeal': lastMeal,
      'insulinDose': insulinDose,
      'insulinType': insulinType,
      'mood': mood,
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
        title: Text('Blood Sugar Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Blood Sugar:',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: bloodSugarController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Enter current blood sugar'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the blood sugar level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Last Meal:',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: lastMealController,
                decoration: InputDecoration(hintText: 'Enter your last meal/snack'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the last meal';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Insulin Dose:',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: insulinDoseController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Enter your insulin dose for your latest meal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the insulin dose';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Insulin Type:',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: insulinTypeController,
                decoration: InputDecoration(hintText: 'Enter the insulin type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the insulin type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Mood:',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: moodController,
                decoration: InputDecoration(hintText: 'Enter your current mood'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mood';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
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
      ),
    );
  }
}