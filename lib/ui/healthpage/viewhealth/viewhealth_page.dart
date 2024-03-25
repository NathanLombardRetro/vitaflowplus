import 'package:flutter/material.dart';
import 'package:vitaflowplus/components/bottom_navigation.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:vitaflowplus/ui/bloodsugar/viewbloodsugar/viewbloodsugar_page.dart';
import 'package:vitaflowplus/ui/dashboard/dashboard_page.dart';
import 'package:vitaflowplus/ui/workouts/workout/workouts.dart';
import 'package:vitaflowplus/widgets/hydration-tips-widget.dart';
import 'package:vitaflowplus/widgets/metric-tile-widget.dart';

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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            MetricTile(
              label: "Latest Sleep for the Week",
              value:
                  "7 hours 30 minutes", // Example value, replace with actual data
            ),
            SizedBox(height: 20),
            MetricTile(
              label: "Average Sleep Time",
              value:
                  "7 hours 30 minutes", // Example value, replace with actual data
            ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add logic for sleep analysis
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
                    child: Text("Sleep Analysis"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic to track sleep manually or integrate with sleep tracking device
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
                    child: Text("Track Sleep"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Water Intake",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            MetricTile(
              label: "Water Intake for the Week",
              value: "1.5 liters", // Example value, replace with actual data
            ),
            SizedBox(height: 20),
            MetricTile(
              label: "Average Water Intake",
              value: "0.5 liters", // Example value, replace with actual data
            ),
            SizedBox(height: 20),
            HydrationTipsWidget(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add logic to log water intake
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
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 3,
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WorkoutsPage()));
          } else if (index == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => GraphPage()));
          }
        },
      ),
    );
  }
}