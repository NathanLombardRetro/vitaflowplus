import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:vitaflowplus/components/bottom_navigation.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:vitaflowplus/models/sugar_model.dart';
import 'package:vitaflowplus/services/firebaseFunctions.dart';
import 'package:vitaflowplus/ui/dashboard/dashboard_page.dart';
import 'package:vitaflowplus/ui/healthpage/viewhealth/viewhealth_page.dart';
import 'package:vitaflowplus/ui/testBluetooth/testBlue_page.dart';
import 'package:vitaflowplus/ui/workouts/workout/workouts.dart';

class GraphPage extends StatelessWidget {
  final List<double> data = [0.0, 1.0, 1.5, 2.0, 0.5, 1.8, 2.5];

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
              List<double> data = snapshot.data!.map((sugar) => double.parse(sugar.bloodSugar)).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Current Trend in your sugar levels",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 200, // Specify the height here
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: Sparkline(
                        data: data,
                        lineColor: Color(0xFF26547C),
                        lineWidth: 3.0,
                        fillMode: FillMode.below,
                        fillColor: Colors.white.withOpacity(0.5),
                        pointsMode: PointsMode.all,
                        pointColor: Colors.blue,
                        pointSize: 8.0,
                      ),
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
            MaterialPageRoute(builder: (context) => DeviceScannerPage()),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 2,
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