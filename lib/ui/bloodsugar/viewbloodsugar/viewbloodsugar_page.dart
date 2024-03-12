import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:vitaflowplus/components/bottom_navigation.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:vitaflowplus/models/sugar_model.dart';
import 'package:vitaflowplus/services/firebaseFunctions.dart';
import 'package:vitaflowplus/ui/dashboard/dashboard_page.dart';
import 'package:vitaflowplus/ui/healthpage/viewhealth/viewhealth_page.dart';
import 'package:vitaflowplus/ui/workouts/workout/workouts.dart';


class GraphPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: FutureBuilder<List<Sugar>>(
          future: FirebaseFunctions.fetchSugarLevels(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<double> data = snapshot.data!
                  .map((sugar) => double.parse(sugar.bloodSugar))
                  .toList();

              // Placeholder values for additional metrics
              double averageInsulin = 15.0; // Example average insulin dosage
              String mostCommonMood = "Happy"; // Example most common mood
              double averageSugarLevel = 5.5; // Example average sugar level
              String lastMeal = "Chicken salad"; // Example last meal

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Current Trend in Your Sugar Levels",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF26547C)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Sparkline(
                        data: data,
                        lineColor: Color(0xFF26547C).withOpacity(0.8),
                        lineWidth: 3.0,
                        fillMode: FillMode.below,
                        fillColor: Color(0xFF26547C).withOpacity(0.3),
                        pointsMode: PointsMode.all,
                        pointColor: Color(0xFF26547C),
                        pointSize: 8.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.local_hospital, color: Color(0xFF26547C)),
                    title: Text("Average Insulin Dosage: $averageInsulin",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.mood, color: Color(0xFF26547C)),
                    title: Text("Most Common Mood: $mostCommonMood",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.local_dining, color: Color(0xFF26547C)),
                    title: Text("Average Sugar Level: $averageSugarLevel",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.fastfood, color: Color(0xFF26547C)),
                    title: Text("Last Meal: $lastMeal",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkoutsPage()),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 2,
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WorkoutsPage()));
          } else if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SleepWaterPage()));
          }
        },
      ),
    );
  }
}