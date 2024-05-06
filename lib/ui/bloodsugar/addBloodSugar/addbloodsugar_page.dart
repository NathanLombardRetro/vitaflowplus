import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vitaflowplus/ui/bloodsugar/viewbloodsugar/viewbloodsugar_page.dart';

class AddBloodSugarPage extends StatefulWidget {
  AddBloodSugarPage({super.key});

  @override
  _AddBloodSugarPageState createState() => _AddBloodSugarPageState();
}

class _AddBloodSugarPageState extends State<AddBloodSugarPage> {
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

      await FirebaseFirestore.instance
          .collection('sugarLevels')
          .doc(sugarLevelid)
          .set({
        'userId': user.uid,
        'bloodSugar': bloodSugar,
        'lastMeal': lastMeal,
        'insulinDose': insulinDose,
        'insulinType': insulinType,
        'mood': mood,
        'date': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Blood sugar added successfully.'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GraphPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add blood sugar.'),
          duration: Duration(seconds: 3),
        ),
      );
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
            child: Form(
              key: _formKey,
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
                          side: BorderSide(
                              color: currentTheme.primaryColor, width: 0),
                        ),
                        child: Icon(Icons.arrow_back),
                      ),
                      Text(
                        'Add blood sugar',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: currentTheme.primaryColorLight),
                      ),
                      SizedBox(width: 56),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: bloodSugarController,
                    style: TextStyle(color: currentTheme.primaryColorLight),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Blood Sugar',
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
                        return 'Please enter the blood sugar level';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: lastMealController,
                    style: TextStyle(color: currentTheme.primaryColorLight),
                    decoration: InputDecoration(
                      labelText: 'Last meal',
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
                        return 'Please enter the last meal';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: insulinDoseController,
                    style: TextStyle(color: currentTheme.primaryColorLight),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Insulin dose',
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
                        return 'Please enter the insulin dose';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: insulinTypeController,
                    style: TextStyle(color: currentTheme.primaryColorLight),
                    decoration: InputDecoration(
                      labelText: 'Insulin Type',
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
                        return 'Please enter the insulin type';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: moodController,
                    style: TextStyle(color: currentTheme.primaryColorLight),
                    decoration: InputDecoration(
                      labelText: 'Mood',
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
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF26547C)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 253, 253, 252)),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(fontSize: 14)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(15)),
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
      ),
    );
  }
}
