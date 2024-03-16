import 'package:flutter/material.dart';
import 'package:vitaflowplus/components/bottom_navigation.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:vitaflowplus/ui/bloodsugar/viewbloodsugar/viewbloodsugar_page.dart';
import 'package:vitaflowplus/ui/dashboard/dashboard_page.dart';
import 'package:vitaflowplus/ui/workouts/workout/workouts.dart';

class SleepWaterPage extends StatelessWidget {
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
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 3,
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
          }
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsPage()));
          }
          if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => GraphPage()));
          }
          if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SleepWaterPage()));
          }
        },
      ),
    );
  }
}