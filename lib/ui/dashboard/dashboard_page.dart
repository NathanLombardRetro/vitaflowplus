import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:vitaflowplus/models/water_model.dart';
import 'package:vitaflowplus/models/workout_model.dart';
import 'package:vitaflowplus/services/firebaseFunctions.dart';
import 'package:vitaflowplus/ui/bloodsugar/viewbloodsugar/viewbloodsugar_page.dart';
import 'package:vitaflowplus/ui/healthpage/viewhealth/viewhealth_page.dart';
import 'package:vitaflowplus/ui/workouts/workout/workouts.dart';
import 'package:vitaflowplus/components/bottom_navigation.dart';
import 'package:vitaflowplus/widgets/health-tips-widget.dart';
import 'package:vitaflowplus/widgets/weather-widget.dart';

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
    ThemeData currentTheme = ThemeProvider.themeOf(context).data;


    return Scaffold(
      backgroundColor: currentTheme.primaryColor,
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
              SizedBox(height: 10),
              HealthTipsWidget(),
              SizedBox(height: 10),
              FutureBuilder<Sugar?>(
                future: FirebaseFunctions.fetchLastSugarLevel(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    String sugarReading = snapshot.data != null
                        ? snapshot.data!.bloodSugar
                        : "No data available";
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Last Sugar Reading:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          sugarReading + " mmol/L",
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
                    child: FutureBuilder<Sugar?>(
                      future: FirebaseFunctions.fetchLastSugarLevel(user.uid),
                      builder: (context, sugarSnapshot) {
                        if (sugarSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (sugarSnapshot.hasError) {
                          return Text('Error: ${sugarSnapshot.error}');
                        } else {
                          String lastMood = sugarSnapshot.data != null
                              ? sugarSnapshot.data!.mood
                              : "No data available";
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Current Mood",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    lastMood,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FutureBuilder<waterIntake?>(
                      future: FirebaseFunctions.fetchLastWater(user.uid),
                      builder: (context, waterSnapshot) {
                        if (waterSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (waterSnapshot.hasError) {
                          return Text('Error: ${waterSnapshot.error}');
                        } else {
                          waterIntake? lastWater = waterSnapshot.data;
                          String waterAmount = lastWater != null
                              ? lastWater.amount.toString()
                              : "No data available";
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Water Intake",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    waterAmount + " litres",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FutureBuilder<List<Workout?>>(
                          future:
                              FirebaseFunctions.fetchLatestWorkout(user.uid),
                          builder: (context, workoutSnapshot) {
                            if (workoutSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (workoutSnapshot.hasError) {
                              return Text('Error: ${workoutSnapshot.error}');
                            } else {
                              List<Workout?> latestWorkouts =
                                  workoutSnapshot.data!;
                              String workoutName = latestWorkouts.isNotEmpty
                                  ? latestWorkouts[0]!.workoutName
                                  : "No workout available";
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Last Workout",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    workoutName,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FutureBuilder<String?>(
                          future: FirebaseFunctions.fetchLastSleep(user.uid),
                          builder: (context, sleepSnapshot) {
                            if (sleepSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (sleepSnapshot.hasError) {
                              return Text('Error: ${sleepSnapshot.error}');
                            } else {
                              String sleepTime = sleepSnapshot.data ??
                                  "No sleep data available";
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Last Sleep Time",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    sleepTime,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              WeatherWidget(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0,
        onTabSelected: (index) {
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WorkoutsPage()));
          }
          if (index == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => GraphPage()));
          }
          if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SleepWaterPage()));
          }
        },
      ),
    );
  }
}
