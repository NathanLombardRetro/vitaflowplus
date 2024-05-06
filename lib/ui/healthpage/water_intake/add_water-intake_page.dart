import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vitaflowplus/ui/healthpage/viewhealth/viewhealth_page.dart';

class LogWaterIntakePage extends StatefulWidget {
  LogWaterIntakePage({super.key});

  @override
  State<LogWaterIntakePage> createState() => _MyLogWaterIntakeState();
}

class _MyLogWaterIntakeState extends State<LogWaterIntakePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _waterAmountController = TextEditingController();

  Future<void> _logWaterIntake() async {
    try {
      String waterAmount = _waterAmountController.text;
      String waterIntakeId = Uuid().v4();

      await FirebaseFirestore.instance
          .collection('waterIntakes')
          .doc(waterIntakeId)
          .set({
        'amount': double.parse(waterAmount),
        'date': DateTime.now(),
        'userId': user.uid,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Water intake logged successfully.'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SleepWaterPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log water intake.'),
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
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
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
                    side:
                        BorderSide(color: currentTheme.primaryColor, width: 0),
                  ),
                  child: Icon(Icons.arrow_back),
                ),
                Text(
                  "Enter Water Intake",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: currentTheme.primaryColorLight),
                ),
                SizedBox(width: 56),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _waterAmountController,
              style: TextStyle(color: currentTheme.primaryColorLight),
              decoration: InputDecoration(
                labelText: 'Amount of water (in litres)',
                labelStyle: TextStyle(color: currentTheme.primaryColorLight),
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
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _logWaterIntake();
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
                  "Submit",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
