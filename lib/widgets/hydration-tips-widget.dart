import 'package:flutter/material.dart';
import 'dart:async';

class HydrationTipsWidget extends StatefulWidget {
  @override
  _HydrationTipsWidgetState createState() => _HydrationTipsWidgetState();
}

class _HydrationTipsWidgetState extends State<HydrationTipsWidget> {
  final List<String> hydrationTips = [
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
        currentIndex = (currentIndex + 1) % hydrationTips.length;
      });
    });
  }

  @override
Widget build(BuildContext context) {
  return Container(
    height: 65,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Color(0xFF26547C),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Center( 
      child: PageView.builder(
        itemCount: hydrationTips.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.water_drop_outlined),
            iconColor: Colors.yellow,
            title: Text(
              hydrationTips[currentIndex],
              style: TextStyle(color: Color(0xFFF1F1EF)),
            ),
          );
        },
      ),
    ),
  );
}
}