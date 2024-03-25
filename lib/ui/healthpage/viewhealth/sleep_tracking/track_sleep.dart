import 'package:flutter/material.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogSleepPage extends StatefulWidget {
  @override
  _LogSleepPageState createState() => _LogSleepPageState();
}

class _LogSleepPageState extends State<LogSleepPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _sleepDurationController = TextEditingController();

  Future<void> _logSleepData() async {
    try {
      String sleepDuration = _sleepDurationController.text;
      if (sleepDuration.isNotEmpty) {
        await FirebaseFirestore.instance.collection('sleepData').add({
          'duration': int.parse(sleepDuration),
          'date': DateTime.now(),
          'userId': user.uid,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sleep data logged successfully')));
        Navigator.pop(context);
        _sleepDurationController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter sleep duration')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to log sleep data: $e')));
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
              "Enter Sleep Data",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _sleepDurationController,
              decoration: InputDecoration(
                labelText: 'Sleep duration (in minutes)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF26547C), width: 1),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _logSleepData(),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 253, 253, 252),
                  onPrimary: Color(0xFF26547C),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Color(0xFF26547C), width: 1),
                  ),
                ),
                child: Text("Log Sleep Data"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}