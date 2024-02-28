import 'package:flutter/material.dart';

class SleepWaterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep & Water"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sleep",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Latest Sleep for the Week"),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to add sleep page
                  },
                  child: Text("Add Sleep"),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Average Sleep Time"),
            SizedBox(height: 30),
            Text(
              "Water Intake",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Water Intake for the Week"),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to add water intake page
                  },
                  child: Text("Add Water Intake"),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Average Water Intake"),
          ],
        ),
      ),
    );
  }
}