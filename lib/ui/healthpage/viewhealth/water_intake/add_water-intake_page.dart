import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:uuid/uuid.dart';

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
      // Get user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

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

      print('Water intake logged successfully');
      Navigator.pop(context);
    } catch (e) {
      print('Failed to log water intake: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Water Intake",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _waterAmountController,
              decoration: InputDecoration(
                labelText: 'Amount of water (liters)',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _logWaterIntake();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 253, 253, 252),
                  onPrimary: Color(0xFF26547C),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Color(0xFF26547C), width: 1),
                  ),
                ),
                child: Text("Log Water Intake"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
