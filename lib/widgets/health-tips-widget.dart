import 'package:flutter/material.dart';
import 'dart:async';

class HealthTipsWidget extends StatefulWidget {
  @override
  _HealthTipsWidgetState createState() => _HealthTipsWidgetState();
}

class _HealthTipsWidgetState extends State<HealthTipsWidget> {
  final List<String> healthTips = [
    'Tip 1: Monitor blood sugar regularly.',
    'Tip 2: Stay physically active.',
    'Tip 3: Choose low glycemic index carbs.',
    'Tip 4: Stay hydrated with water.',
    'Tip 5: Do not skip meals.'
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
    height: 55,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Color(0xFF26547C),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Center( 
      child: PageView.builder(
        itemCount: healthTips.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.medical_information_outlined),
            iconColor: Colors.yellow,
            title: Text(
              healthTips[currentIndex],
              style: TextStyle(color: Color(0xFFF1F1EF)),
            ),
          );
        },
      ),
    ),
  );
}
}