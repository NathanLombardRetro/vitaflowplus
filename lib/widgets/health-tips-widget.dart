import 'package:flutter/material.dart';
import 'dart:async';

class HealthTipsWidget extends StatefulWidget {
  @override
  _HealthTipsWidgetState createState() => _HealthTipsWidgetState();
}

class _HealthTipsWidgetState extends State<HealthTipsWidget> {
  final List<String> healthTips = [
    'Tip 1: Drink plenty of water throughout the day.',
    'Tip 2: Eat a balanced diet rich in fruits and vegetables.',
    'Tip 3: Get regular exercise to stay active and healthy.',
  ];
  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % healthTips.length;
      });
    });
  }

  @override
Widget build(BuildContext context) {
  return Container(
    height: 65,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Color(0xFF26547C), // Set background color to blue
      borderRadius: BorderRadius.circular(15), // Set border radius to 15
    ),
    child: Center( // Center the content vertically
      child: PageView.builder(
        itemCount: healthTips.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.lightbulb),
            iconColor: Colors.yellow,
            title: Text(
              healthTips[currentIndex],
              style: TextStyle(color: Color(0xFFF1F1EF)), // Set text color to white
            ),
          );
        },
      ),
    ),
  );
}
}