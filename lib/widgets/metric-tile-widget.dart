import 'package:flutter/material.dart';
import 'dart:async';

class MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const MetricTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFF26547C),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 253, 253, 252)),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 253, 253, 252)),
          ),
        ],
      ),
    );
  }
}
