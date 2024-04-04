import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:vitaflowplus/components/bottom_navigation.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:vitaflowplus/services/firebaseFunctions.dart';
import 'package:vitaflowplus/ui/bloodsugar/viewbloodsugar/viewbloodsugar_page.dart';
import 'package:vitaflowplus/ui/dashboard/dashboard_page.dart';
import 'package:vitaflowplus/ui/healthpage/sleep_tracking/sleep_analysis.dart';
import 'package:vitaflowplus/ui/healthpage/sleep_tracking/track_sleep.dart';
import 'package:vitaflowplus/ui/healthpage/water_intake/add_water-intake_page.dart';
import 'package:vitaflowplus/ui/workouts/workout/workouts.dart';
import 'package:vitaflowplus/widgets/hydration-tips-widget.dart';
import 'package:vitaflowplus/widgets/metric-tile-widget.dart';

class SleepWaterPage extends StatefulWidget {
  @override
  _SleepWaterPageState createState() => _SleepWaterPageState();
}

class _SleepWaterPageState extends State<SleepWaterPage> {
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
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sleep",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: currentTheme.primaryColorLight),
            ),
            SizedBox(height: 20),
            FutureBuilder<String>(
              future: FirebaseFunctions.fetchSleepSumLastWeek(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  String averageSleep = snapshot.data ?? '';
                  return MetricTile(
                    label: "Sleep for the week",
                    value: "${averageSleep}",
                  );
                }
              },
            ),
            SizedBox(height: 20),
            FutureBuilder<String>(
              future: FirebaseFunctions.fetchAverageSleep(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  String averageSleep = snapshot.data ?? '';
                  return MetricTile(
                    label: "Average sleep amount",
                    value: "${averageSleep}",
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SleepTrendsPage()),
                      );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LogSleepPage()),
                      );
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: currentTheme.primaryColorLight),
            ),
            SizedBox(height: 20),
            FutureBuilder<double>(
              future: FirebaseFunctions.fetchWaterIntakeSumLastWeek(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  double waterIntakeLastWeek = snapshot.data ?? 0.0;
                  return MetricTile(
                    label: "Water Intake for the Week",
                    value: "${waterIntakeLastWeek.toStringAsFixed(2)} litres",
                  );
                }
              },
            ),
            SizedBox(height: 20),
            FutureBuilder<double>(
              future: FirebaseFunctions.fetchAverageWaterIntake(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  double averageWaterIntake = snapshot.data ?? 0.0;
                  return MetricTile(
                    label: "Average Water Intake",
                    value: "${averageWaterIntake.toStringAsFixed(2)} litres",
                  );
                }
              },
            ),
            SizedBox(height: 20),
            HydrationTipsWidget(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LogWaterIntakePage()),
                  );
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
