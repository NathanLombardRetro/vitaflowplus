import 'package:flutter/material.dart';
import 'dart:async';

class HydrationTipsWidget extends StatefulWidget {
  @override
  _HydrationTipsWidgetState createState() => _HydrationTipsWidgetState();
}

class _HydrationTipsWidgetState extends State<HydrationTipsWidget> {
  final List<String> hydrationTips = [
    'Tip 1: Carry a water bottle..',
    'Tip 2: Set daily hydration goals.',
    'Tip 3: Check urine color for hydration status.',
    'Tip 4: Eat hydrating foods like fruits and veggies.',
    'Tip 5: Limit caffeine and alcohol intake.'
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