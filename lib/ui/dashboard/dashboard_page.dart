import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:vitaflowplus/models/workout_model.dart';
import 'package:vitaflowplus/services/firebaseFunctions.dart';
import 'package:vitaflowplus/ui/bloodsugar/viewbloodsugar/viewbloodsugar_page.dart';
import 'package:vitaflowplus/ui/healthpage/viewhealth/viewhealth_page.dart';
import 'package:vitaflowplus/ui/workouts/workout/workouts.dart';
import 'package:vitaflowplus/components/bottom_navigation.dart';
import 'package:vitaflowplus/widgets/health-tips-widget.dart';

import '../../models/sugar_model.dart';

class Dashboard extends StatefulWidget {
   Dashboard({super.key});

  @override
  State<Dashboard> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Dashboard> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(),
    ),
    body: ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Welcome back!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            HealthTipsWidget(),
            SizedBox(height: 16),
            FutureBuilder<Sugar?>(
              future: FirebaseFunctions.fetchLastSugarLevel(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  String sugarReading = snapshot.data != null ? snapshot.data!.bloodSugar : "No data available";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Last Sugar Reading:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        sugarReading + " mmol/L" ,
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 32),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Carbs",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Placeholder Value", // Replace with actual carbs value
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Water Intake",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Placeholder Value", // Replace with actual water intake value
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<List<Workout?>>(
  future: FirebaseFunctions.fetchLatestWorkout(user.uid),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      List<Workout?> latestWorkouts = snapshot.data!;
      return Expanded(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Last Workout",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  latestWorkouts != null ? latestWorkouts[0]!.workoutName : "No workout available",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }
  },
),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sleep Time",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Placeholder Value", // Replace with actual sleep time value
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    ),
    bottomNavigationBar: CustomBottomNavigationBar(
      selectedIndex: 0,
      onTabSelected: (index) {
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
